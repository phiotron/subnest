import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../domain/domain.dart';
import '../db/app_database.dart';
import '../db/mappers.dart';
import '../logos/custom_logo_store.dart';
import '../rates/exchange_rate_repository.dart';
import '../settings_repository.dart';
import '../subscription_repository.dart';
import 'backup_codec.dart';
import 'backup_logos.dart';

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
  BackupService(
    this._db,
    this._subs,
    this._settings,
    this._rates, {
    DateTime Function()? clock,
    CustomLogoStore? logos,
  }) : _clock = clock ?? DateTime.now,
       _logosOverride = logos;

  final AppDatabase _db;
  final SubscriptionRepository _subs;
  final SettingsRepository _settings;
  final ExchangeRateRepository _rates;
  final DateTime Function() _clock;
  final CustomLogoStore? _logosOverride;

  /// Custom logo files (part of the backup); the app's store unless one was passed (tests).
  CustomLogoStore get _logos => _logosOverride ?? CustomLogoStore.instance;

  String _stamp() {
    final d = LocalDate.fromDateTime(_clock());
    return d.toString();
  }

  // ---- Export --------------------------------------------------------------------------------

  /// Records that a JSON backup left the phone. Call it only after the share sheet completed —
  /// a dismissed sheet is not a backup (real phone QA 2026-11-05: cancelling still hid the nudge).
  Future<void> markBackedUp() => _settings.setLastBackupAt(_clock());

  Future<ExportFile> exportJson() async {
    final text = await exportJsonText();
    return ExportFile('subnest-backup-${_stamp()}.subnest', text, 'application/json');
  }

  /// SHA-256 of the data part of a backup (everything except `format`, `version`,
  /// `exportedAt`, `checksum`). Detects a file that was edited or corrupted after export.
  static String checksumOf(Object? data) => sha256.convert(utf8.encode(jsonEncode(data))).toString();

  /// Plain JSON backup text. Also used by the auto-backup service; the UI encrypts it when a
  /// password is set.
  Future<String> exportJsonText() async {
    final raw = await _settings.raw();
    final rates = await _rates.load();
    final subs = await _subs.all();
    final logos = await BackupLogos.export(_logos, {for (final s in subs) ?s.customLogoFile});
    final data = {
      'settings': {
        for (final k in SettingsRepository.backupKeys)
          if (raw[k] != null) k: raw[k],
      },
      'rateOverrides': rates.overrides,
      'subscriptions': [for (final s in subs) BackupCodec.subscriptionToJson(s)],
      'periods': [for (final p in await _subs.allPeriods()) BackupCodec.periodToJson(p)],
      'priceChanges': [for (final c in await _subs.allPriceChanges()) BackupCodec.priceChangeToJson(c)],
      'categories': [for (final c in await _db.select(_db.categories).get()) BackupCodec.categoryToJson(c.toDomain())],
      'labels': [for (final l in await _db.select(_db.labels).get()) BackupCodec.labelToJson(l.toDomain())],
      'paymentMethods': [
        for (final p in await _db.select(_db.paymentMethods).get()) BackupCodec.paymentMethodToJson(p.toDomain()),
      ],
      'budgets': [for (final b in await _db.select(_db.budgets).get()) BackupCodec.budgetToJson(b.toDomain())],
      'dismissedDetections': (await _subs.dismissedKeys()).toList()..sort(),
      BackupLogos.key: ?logos,
    };
    return const JsonEncoder.withIndent('  ').convert({
      'format': BackupCodec.format,
      'version': BackupCodec.version,
      'exportedAt': _clock().toUtc().toIso8601String(),
      'checksum': checksumOf(data),
      ...data,
    });
  }

  /// Two CSV files (UTF-8 with BOM so Excel shows Vietnamese correctly):
  /// subscriptions and payment history.
  Future<List<ExportFile>> exportCsv() async {
    final settings = await _settings.load();
    final calc = SpendingCalculator(rates: await _rates.load(), primaryCurrency: settings.primaryCurrency);
    final subs = await _subs.all();
    final byId = {for (final s in subs) s.id: s};
    final catNames = {for (final c in await _db.select(_db.categories).get()) c.id: c.name ?? c.builtInKey ?? c.id};
    final labelNames = {for (final l in await _db.select(_db.labels).get()) l.id: l.name};
    String money(int minor, String cur) => toMajorUnits(minor, cur).toStringAsFixed(currencyDecimals(cur));

    final subRows = <List<Object?>>[
      [
        'name', 'status', 'category', 'price', 'currency', 'cycle_every', 'cycle_unit', 'next_due_date',
        'trial_end_date', 'shared_with', 'my_share', 'monthly_cost_${settings.primaryCurrency}',
        'payment_method', 'manage_url', 'notes', 'started_on', 'cancelled_on',
        'labels', 'worth_it', 'paused_from', 'detection_source',
      ],
      for (final s in subs)
        [
          s.name, s.status.name, catNames[s.categoryId] ?? s.categoryId, money(s.priceMinor, s.currency), s.currency, s.cycle.every,
          s.cycle.unit.name, BillingRules.hasSchedule(s.status) ? s.dueDate : '', s.trialEndDate,
          s.sharedWith, money(s.myShareMinor, s.currency),
          calc.monthlyCost(s)?.toStringAsFixed(currencyDecimals(settings.primaryCurrency)),
          s.paymentMethod, s.manageUrl, s.notes, s.startDate, s.cancelledOn,
          ([for (final id in s.labelIds) labelNames[id] ?? id]..sort()).join('; '),
          s.worthIt?.name, s.pausedFrom, s.detectionSource?.name,
        ],
    ];
    final periods = (await _subs.allPeriods())..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final payRows = <List<Object?>>[
      ['subscription', 'due_date', 'outcome', 'amount', 'currency', 'confirmed_at', 'source'],
      for (final p in periods)
        [
          byId[p.subscriptionId]?.name ?? p.subscriptionId, p.dueDate, p.outcome.name,
          money(p.amountMinor, p.currency), p.currency, p.confirmedAt.toIso8601String(), p.source?.name ?? 'manual',
        ],
    ];
    final changes = await _subs.allPriceChanges();
    final priceRows = <List<Object?>>[
      ['subscription', 'effective_from', 'old_price', 'old_currency', 'new_price', 'currency', 'source'],
      for (final c in changes)
        [
          byId[c.subscriptionId]?.name ?? c.subscriptionId, c.effectiveFrom, money(c.oldPriceMinor, c.fromCurrency),
          c.fromCurrency, money(c.newPriceMinor, c.currency), c.currency, c.source.name,
        ],
    ];
    return [
      ExportFile('subnest-subscriptions-${_stamp()}.csv', toCsv(subRows), 'text/csv'),
      ExportFile('subnest-payments-${_stamp()}.csv', toCsv(payRows), 'text/csv'),
      // Price history (DB v3) — only when there is any, so files without it stay two.
      if (changes.isNotEmpty) ExportFile('subnest-price-history-${_stamp()}.csv', toCsv(priceRows), 'text/csv'),
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
    if (v is! int || v < 1 || v > BackupCodec.version) {
      throw const BackupFormatException('Backup made by a newer app version');
    }
    // v3 files carry a checksum; v1/v2 files do not and are still accepted.
    final checksum = decoded['checksum'];
    if (checksum != null) {
      final data = {...decoded}
        ..remove('format')
        ..remove('version')
        ..remove('exportedAt')
        ..remove('checksum');
      if (checksum is! String || checksum != checksumOf(data)) {
        throw const BackupFormatException('Backup checksum does not match');
      }
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
      // Checked here so a bad Price history fails before anything is replaced.
      for (final j in (decoded['priceChanges'] as List? ?? const [])) {
        BackupCodec.priceChangeFromJson(j as Map<String, Object?>);
      }
      return (subscriptions: subs, periods: periods, json: decoded);
    } on Object catch (e) {
      if (e is BackupFormatException) rethrow;
      throw BackupFormatException('Corrupted backup: $e');
    }
  }

  /// Restores a backup by REPLACING everything (there is no merge): every subscription, payment,
  /// list and rate override is deleted, then the file's content is loaded, and every setting in
  /// [SettingsRepository.backupKeys] takes the file's value (a key the file lacks goes back to its
  /// default). Device-only state stays: onboarding, the rates cache, "last backup", and the
  /// automatic-backup configuration (kept in secure storage, never in the database). Custom logo
  /// files are replaced by the file's `customLogos` (none if it has none). The file is
  /// parsed and checked first, and everything runs in one transaction, so a bad file changes nothing.
  Future<ImportResult> importJson(String text) async {
    final parsed = parse(text);
    final json = parsed.json;
    await _db.transaction(() async {
      await _db.wipeUserData();
      final settings = json['settings'];
      for (final k in SettingsRepository.backupKeys) {
        final v = settings is Map ? settings[k] : null;
        await _settings.set(k, v is String ? v : null);
      }
      await _importLists(json);
      final knownLabels = {for (final l in await _db.select(_db.labels).get()) l.id};
      for (final s in parsed.subscriptions) {
        await _subs.save(s.copyWith(labelIds: s.labelIds.where(knownLabels.contains).toSet()));
      }
      for (final p in parsed.periods) {
        await _db.into(_db.confirmedPeriods).insert(p.toCompanion(), mode: InsertMode.insertOrIgnore);
      }
      // Price history: from the file; a file made before price history existed → backfill from its Payments.
      final changes = json['priceChanges'];
      if (changes is List) {
        final ids = {for (final s in parsed.subscriptions) s.id};
        for (final j in changes) {
          final c = BackupCodec.priceChangeFromJson(j as Map<String, Object?>);
          if (ids.contains(c.subscriptionId)) await _subs.insertPriceChange(c);
        }
      } else {
        await _subs.backfillPriceHistory();
      }
      final overrides = json['rateOverrides'];
      if (overrides is Map) {
        for (final e in overrides.entries) {
          if (e.key is! String || e.value is! num) continue;
          await _db.into(_db.rateOverrides).insert(
            RateOverridesCompanion.insert(pair: e.key as String, rate: (e.value as num).toDouble()),
            mode: InsertMode.insertOrReplace,
          );
        }
      }
      await _fixCategories();
    });
    // Custom logo files, after the database committed (a bad file above changed nothing).
    await BackupLogos.restore(_logos, json[BackupLogos.key], {for (final s in parsed.subscriptions) ?s.customLogoFile});
    return ImportResult(parsed.subscriptions.length, parsed.periods.length);
  }

  /// v2 lists (absent in v1 files). Rows from the file overwrite the seeded built-in categories.
  Future<void> _importLists(Map<String, Object?> json) async {
    const m = InsertMode.insertOrReplace;
    List<Map<String, Object?>> list(String k) => [for (final j in (json[k] as List? ?? const [])) j as Map<String, Object?>];
    for (final j in list('categories')) {
      await _db.into(_db.categories).insert(BackupCodec.categoryFromJson(j).toCompanion(), mode: m);
    }
    for (final j in list('labels')) {
      await _db.into(_db.labels).insert(BackupCodec.labelFromJson(j).toCompanion(), mode: m);
    }
    for (final j in list('paymentMethods')) {
      await _db.into(_db.paymentMethods).insert(BackupCodec.paymentMethodFromJson(j).toCompanion(), mode: m);
    }
    for (final j in list('budgets')) {
      await _db.into(_db.budgets).insert(BackupCodec.budgetFromJson(j).toCompanion(), mode: m);
    }
    for (final k in (json['dismissedDetections'] as List? ?? const [])) {
      if (k is String) await _subs.dismiss(k);
    }
  }

  /// Subscriptions pointing at a category that does not exist (custom one missing) → "other".
  Future<void> _fixCategories() async {
    final known = {for (final c in await _db.select(_db.categories).get()) c.id};
    for (final s in await _subs.all()) {
      final id = CategoryRules.resolve(s.categoryId, known);
      if (id != s.categoryId) await _subs.save(s.copyWith(categoryId: id));
    }
  }
}
