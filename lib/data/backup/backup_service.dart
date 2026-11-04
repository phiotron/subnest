import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/domain.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';
import '../rates/exchange_rate_repository.dart';
import '../settings_repository.dart';
import '../subscription_repository.dart';
import 'backup_codec.dart';

enum ImportMode {
  /// Delete current data, then load the backup (settings restored too).
  replace,

  /// Keep current data; add new items, newer `updatedAt` wins. Settings untouched.
  merge,
}

class ImportResult {
  const ImportResult(this.subscriptions, this.periods);
  final int subscriptions;
  final int periods;
}

class BackupFormatException implements Exception {
  const BackupFormatException(this.message);
  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// Exported file: [name] + text [content].
class ExportFile {
  const ExportFile(this.name, this.content, this.mimeType);
  final String name;
  final String content;
  final String mimeType;
}

/// Full JSON backup / restore and CSV export (F7). No platform code here —
/// sharing and file picking live in `backup_files.dart`.
class BackupService {
  BackupService(this._db, this._subs, this._settings, this._rates, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final SubscriptionRepository _subs;
  final SettingsRepository _settings;
  final ExchangeRateRepository _rates;
  final DateTime Function() _clock;

  String _stamp() {
    final d = LocalDate.fromDateTime(_clock());
    return d.toString();
  }

  // ---- Export --------------------------------------------------------------------------------

  Future<ExportFile> exportJson() async {
    final raw = await _settings.raw();
    final rates = await _rates.load();
    final data = {
      'format': BackupCodec.format,
      'version': BackupCodec.version,
      'exportedAt': _clock().toUtc().toIso8601String(),
      'settings': {
        for (final k in SettingsRepository.backupKeys)
          if (raw[k] != null) k: raw[k],
      },
      'rateOverrides': rates.overrides,
      'subscriptions': [for (final s in await _subs.all()) BackupCodec.subscriptionToJson(s)],
      'periods': [for (final p in await _subs.allPeriods()) BackupCodec.periodToJson(p)],
    };
    await _settings.setLastBackupAt(_clock());
    return ExportFile(
      'subnest-backup-${_stamp()}.json',
      const JsonEncoder.withIndent('  ').convert(data),
      'application/json',
    );
  }

  /// Two CSV files (UTF-8 with BOM so Excel shows Vietnamese correctly):
  /// subscriptions and payment history.
  Future<List<ExportFile>> exportCsv() async {
    final settings = await _settings.load();
    final calc = SpendingCalculator(rates: await _rates.load(), primaryCurrency: settings.primaryCurrency);
    final subs = await _subs.all();
    final byId = {for (final s in subs) s.id: s};
    String money(int minor, String cur) => toMajorUnits(minor, cur).toStringAsFixed(currencyDecimals(cur));

    final subRows = <List<Object?>>[
      [
        'name', 'status', 'category', 'price', 'currency', 'cycle_every', 'cycle_unit', 'next_due_date',
        'trial_end_date', 'shared_with', 'my_share', 'monthly_cost_${settings.primaryCurrency}',
        'payment_method', 'manage_url', 'notes', 'started_on', 'cancelled_on',
      ],
      for (final s in subs)
        [
          s.name, s.status.name, s.category.key, money(s.priceMinor, s.currency), s.currency, s.cycle.every,
          s.cycle.unit.name, s.status == SubscriptionStatus.cancelled ? '' : s.dueDate, s.trialEndDate,
          s.sharedWith, money(s.myShareMinor, s.currency),
          calc.monthlyCost(s)?.toStringAsFixed(currencyDecimals(settings.primaryCurrency)),
          s.paymentMethod, s.manageUrl, s.notes, s.startDate, s.cancelledOn,
        ],
    ];
    final periods = (await _subs.allPeriods())..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final payRows = <List<Object?>>[
      ['subscription', 'due_date', 'outcome', 'amount', 'currency', 'confirmed_at'],
      for (final p in periods)
        [
          byId[p.subscriptionId]?.name ?? p.subscriptionId, p.dueDate, p.outcome.name,
          money(p.amountMinor, p.currency), p.currency, p.confirmedAt.toIso8601String(),
        ],
    ];
    return [
      ExportFile('subnest-subscriptions-${_stamp()}.csv', toCsv(subRows), 'text/csv'),
      ExportFile('subnest-payments-${_stamp()}.csv', toCsv(payRows), 'text/csv'),
    ];
  }

  /// RFC 4180 CSV with a UTF-8 BOM and CRLF line endings.
  static String toCsv(List<List<Object?>> rows) {
    String cell(Object? v) {
      final s = v?.toString() ?? '';
      if (s.contains(RegExp(r'[",\r\n]'))) return '"${s.replaceAll('"', '""')}"';
      return s;
    }

    return '﻿${rows.map((r) => r.map(cell).join(',')).join('\r\n')}\r\n';
  }

  // ---- Import --------------------------------------------------------------------------------

  /// Parses and validates without writing (to show "N subscriptions" before confirming).
  ({List<Subscription> subscriptions, List<ConfirmedPeriod> periods, Map<String, Object?> json}) parse(String text) {
    final Object? decoded;
    try {
      decoded = jsonDecode(text.startsWith('﻿') ? text.substring(1) : text);
    } on FormatException {
      throw const BackupFormatException('Not a JSON file');
    }
    if (decoded is! Map<String, Object?> || decoded['format'] != BackupCodec.format) {
      throw const BackupFormatException('Not a Subnest backup');
    }
    final v = decoded['version'];
    if (v is! int || v > BackupCodec.version) {
      throw const BackupFormatException('Backup made by a newer app version');
    }
    try {
      final subs = [
        for (final j in (decoded['subscriptions'] as List? ?? const []))
          BackupCodec.subscriptionFromJson(j as Map<String, Object?>),
      ];
      final ids = subs.map((s) => s.id).toSet();
      final periods = [
        for (final j in (decoded['periods'] as List? ?? const []))
          BackupCodec.periodFromJson(j as Map<String, Object?>),
      ].where((p) => ids.contains(p.subscriptionId)).toList();
      return (subscriptions: subs, periods: periods, json: decoded);
    } on Object catch (e) {
      if (e is BackupFormatException) rethrow;
      throw BackupFormatException('Corrupted backup: $e');
    }
  }

  Future<ImportResult> importJson(String text, ImportMode mode) async {
    final parsed = parse(text);
    final json = parsed.json;
    await _db.transaction(() async {
      if (mode == ImportMode.replace) {
        await _db.wipeUserData();
        final settings = json['settings'];
        if (settings is Map) {
          for (final k in SettingsRepository.backupKeys) {
            final v = settings[k];
            if (v is String) await _settings.set(k, v);
          }
        }
      }
      for (final s in parsed.subscriptions) {
        final existing = mode == ImportMode.merge ? await _subs.get(s.id) : null;
        if (existing == null || s.updatedAt.isAfter(existing.updatedAt)) await _subs.save(s);
      }
      for (final p in parsed.periods) {
        await _db.into(_db.confirmedPeriods).insert(p.toCompanion(), mode: InsertMode.insertOrIgnore);
      }
      final overrides = json['rateOverrides'];
      if (overrides is Map) {
        for (final e in overrides.entries) {
          if (e.key is! String || e.value is! num) continue;
          await _db.into(_db.rateOverrides).insert(
            RateOverridesCompanion.insert(pair: e.key as String, rate: (e.value as num).toDouble()),
            mode: mode == ImportMode.replace ? InsertMode.insertOrReplace : InsertMode.insertOrIgnore,
          );
        }
      }
      if (mode == ImportMode.merge) await _reconcile();
    });
    return ImportResult(parsed.subscriptions.length, parsed.periods.length);
  }

  /// After a merge a subscription may point at a period that is already confirmed
  /// (history came from the other device). Move it past confirmed periods.
  Future<void> _reconcile() async {
    final confirmed = <String, Set<LocalDate>>{};
    for (final p in await _subs.allPeriods()) {
      confirmed.putIfAbsent(p.subscriptionId, () => {}).add(p.dueDate);
    }
    for (final s in await _subs.all()) {
      final done = confirmed[s.id];
      if (done == null) continue;
      var current = s;
      while (done.contains(current.dueDate)) {
        current = current.copyWith(periodIndex: current.periodIndex + 1);
      }
      if (!identical(current, s)) await _subs.save(current);
    }
  }
}
