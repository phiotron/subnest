import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/streams.dart';
import '../../domain/domain.dart';
import '../db/app_database.dart';
import '../settings_repository.dart';
import 'fallback_rates.dart';

/// Result of a refresh attempt.
enum RatesRefreshResult { updated, notNeeded, failed }

/// Exchange rates: provider rates cached in the DB (refreshed at most once a day when online),
/// plus user overrides per pair. Falls back to a bundled snapshot before the first refresh.
///
/// Provider: https://open.er-api.com (ExchangeRate-API open access) — free, no key, includes VND,
/// updates daily. Terms ask for attribution: show "Rates by Exchange Rate API" in Settings.
class ExchangeRateRepository {
  ExchangeRateRepository(this._db, this._settings, {http.Client? client, DateTime Function()? clock})
    : _client = client ?? http.Client(),
      _clock = clock ?? DateTime.now;

  static final Uri endpoint = Uri.parse('https://open.er-api.com/v6/latest/USD');
  static const attributionUrl = 'https://www.exchangerate-api.com';

  final AppDatabase _db;
  final SettingsRepository _settings;
  final http.Client _client;
  final DateTime Function() _clock;

  Stream<ExchangeRates> watch() => combineLatest3(
    _db.select(_db.cachedRates).watch(),
    _db.select(_db.rateOverrides).watch(),
    _settings.watch().map((s) => s.ratesFetchedAt).distinct(),
    _build,
  );

  Future<ExchangeRates> load() async => _build(
    await _db.select(_db.cachedRates).get(),
    await _db.select(_db.rateOverrides).get(),
    (await _settings.load()).ratesFetchedAt,
  );

  ExchangeRates _build(List<CachedRateRow> cached, List<RateOverrideRow> overrides, DateTime? fetchedAt) {
    final usd = cached.isEmpty ? fallbackUsdRates : {for (final r in cached) r.code: r.perUsd};
    return ExchangeRates(
      usdRates: usd,
      overrides: {for (final o in overrides) o.pair: o.rate},
      fetchedAt: cached.isEmpty ? null : fetchedAt,
    );
  }

  /// Fetches new rates when the cache is older than a day (or [force]). Never throws.
  Future<RatesRefreshResult> refreshIfStale({bool force = false}) async {
    final current = await load();
    if (!force && !current.isStale(_clock())) return RatesRefreshResult.notNeeded;
    try {
      final res = await _client.get(endpoint).timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return RatesRefreshResult.failed;
      final rates = parseResponse(res.body);
      if (rates.isEmpty) return RatesRefreshResult.failed;
      await _db.transaction(() async {
        await _db.delete(_db.cachedRates).go();
        await _db.batch((b) {
          b.insertAll(_db.cachedRates, [
            for (final e in rates.entries) CachedRatesCompanion.insert(code: e.key, perUsd: e.value),
          ]);
        });
        await _settings.setRatesFetchedAt(_clock());
      });
      return RatesRefreshResult.updated;
    } catch (_) {
      return RatesRefreshResult.failed;
    }
  }

  /// Parses the open.er-api.com payload into "units per USD". Empty map when invalid.
  static Map<String, double> parseResponse(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map || json['result'] != 'success' || json['base_code'] != 'USD') return const {};
      final rates = json['rates'];
      if (rates is! Map) return const {};
      return {
        for (final e in rates.entries)
          if (e.key is String && e.value is num && (e.value as num) > 0) e.key as String: (e.value as num).toDouble(),
      };
    } on FormatException {
      return const {};
    }
  }

  /// Sets "1 [from] = [rate] [to]" manually.
  Future<void> setOverride(String from, String to, double rate) async {
    assert(rate > 0);
    await _clearPair(from, to);
    await _db.into(_db.rateOverrides).insertOnConflictUpdate(
      RateOverridesCompanion.insert(pair: ExchangeRates.pairKey(from, to), rate: rate),
    );
  }

  /// Back to automatic rates for this pair (either direction).
  Future<void> clearOverride(String from, String to) => _clearPair(from, to);

  Future<void> _clearPair(String from, String to) => (_db.delete(_db.rateOverrides)
        ..where((t) => t.pair.isIn([ExchangeRates.pairKey(from, to), ExchangeRates.pairKey(to, from)])))
      .go();

  /// Currency codes known to the provider (for pickers), sorted.
  Future<List<String>> knownCurrencies() async {
    final r = await load();
    return r.usdRates.keys.toList()..sort();
  }
}
