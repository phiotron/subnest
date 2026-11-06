import 'package:intl/intl.dart';

import '../domain/domain.dart';
import 'db/app_database.dart';

enum AppThemeMode { system, light, dark }

/// User preferences (S10). Immutable snapshot; write through [SettingsRepository].
class AppSettings {
  AppSettings({
    required this.primaryCurrency,
    Set<int>? defaultReminderOffsets,
    int? defaultReminderDays,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.themeMode = AppThemeMode.system,
    this.localeCode,
    this.onboardingDone = false,
    this.lastBackupAt,
    this.ratesFetchedAt,
    this.keptTrials = const {},
    this.homeFilter,
    this.homeSort,
    this.hideTabBarOnScroll = false,
  }) : defaultReminderOffsets =
           defaultReminderOffsets ?? ReminderOffsets.fromLegacyDays(defaultReminderDays) ?? ReminderOffsets.defaults;

  final String primaryCurrency;

  /// Default reminder offsets (days before the Due date; empty = off). See [ReminderOffsets].
  final Set<int> defaultReminderOffsets;

  /// Legacy single value of [defaultReminderOffsets] ([ReminderDays.off] = off).
  int get defaultReminderDays => ReminderOffsets.toLegacyDays(defaultReminderOffsets)!;
  final int reminderHour;
  final int reminderMinute;
  final AppThemeMode themeMode;

  /// `null` = follow the system; otherwise `en` / `vi`.
  final String? localeCode;
  final bool onboardingDone;
  final DateTime? lastBackupAt;
  final DateTime? ratesFetchedAt;

  /// Trials the user chose to keep ("Keep it" on the trial-ending card/banner): the card stays hidden
  /// for them. Pruned once a trial becomes Active or is cancelled/deleted (`keptTrialsProvider`).
  final Set<String> keptTrials;

  /// Home list filter / sort remembered between launches (opaque strings owned by the Home UI).
  final String? homeFilter;
  final String? homeSort;

  /// Bottom tab bar hides while scrolling (product.md §10.2, optional).
  final bool hideTabBarOnScroll;
}

/// Picks the Primary currency for a device locale like `vi_VN` → VND, `en_US` → USD.
String defaultCurrencyForLocale(String? localeName) {
  if (localeName == null || localeName.isEmpty) return 'USD';
  final normalized = localeName.replaceAll('-', '_');
  // A language-only locale has no region → no currency information.
  if (!normalized.contains('_')) return normalized.startsWith('vi') ? 'VND' : 'USD';
  try {
    final code = NumberFormat.simpleCurrency(locale: normalized).currencyName;
    if (code != null && code.length == 3) return code;
  } catch (_) {
    // Unknown locale for intl → fall through.
  }
  return 'USD';
}

/// Key-value settings stored in the `settings` table.
class SettingsRepository {
  SettingsRepository(this._db, {required this.deviceLocale});

  final AppDatabase _db;

  /// Device locale name (e.g. `vi_VN`), used for the default Primary currency.
  final String deviceLocale;

  static const kPrimaryCurrency = 'primaryCurrency';
  static const kDefaultReminderDays = 'defaultReminderDays'; // legacy (v1), read when offsets are missing
  static const kDefaultReminderOffsets = 'defaultReminderOffsets'; // "0,3"; '' = off
  static const kReminderTime = 'reminderTime'; // "HH:mm"
  static const kThemeMode = 'themeMode';
  static const kLocale = 'locale';
  static const kOnboardingDone = 'onboardingDone';
  static const kLastBackupAt = 'lastBackupAt';
  static const kRatesFetchedAt = 'ratesFetchedAt';
  static const kHomeFilter = 'homeFilter';
  static const kHomeSort = 'homeSort';
  static const kHideTabBarOnScroll = 'hideTabBarOnScroll';
  static const kKeptTrials = 'keptTrials'; // subscription ids, comma-separated (key-value store, no schema change)

  /// Keys copied into / restored from a JSON backup.
  static const backupKeys = [
    kPrimaryCurrency,
    kDefaultReminderDays,
    kDefaultReminderOffsets,
    kReminderTime,
    kThemeMode,
    kLocale,
    kHomeFilter,
    kHomeSort,
    kHideTabBarOnScroll,
  ];

  Stream<AppSettings> watch() => _db.select(_db.settings).watch().map(_fromRows);

  Future<AppSettings> load() async => _fromRows(await _db.select(_db.settings).get());

  Future<Map<String, String>> raw() async => {
    for (final r in await _db.select(_db.settings).get()) r.key: r.value,
  };

  AppSettings _fromRows(List<SettingRow> rows) {
    final m = {for (final r in rows) r.key: r.value};
    final time = (m[kReminderTime] ?? '09:00').split(':');
    return AppSettings(
      primaryCurrency: m[kPrimaryCurrency] ?? defaultCurrencyForLocale(deviceLocale),
      defaultReminderOffsets: ReminderOffsets.decode(m[kDefaultReminderOffsets]) ??
          ReminderOffsets.fromLegacyDays(int.tryParse(m[kDefaultReminderDays] ?? '')),
      reminderHour: int.tryParse(time.first) ?? 9,
      reminderMinute: time.length > 1 ? int.tryParse(time[1]) ?? 0 : 0,
      themeMode: AppThemeMode.values.firstWhere((e) => e.name == m[kThemeMode], orElse: () => AppThemeMode.system),
      localeCode: m[kLocale],
      onboardingDone: m[kOnboardingDone] == 'true',
      lastBackupAt: DateTime.tryParse(m[kLastBackupAt] ?? ''),
      ratesFetchedAt: DateTime.tryParse(m[kRatesFetchedAt] ?? ''),
      keptTrials: {...?m[kKeptTrials]?.split(',').where((e) => e.isNotEmpty)},
      homeFilter: m[kHomeFilter],
      homeSort: m[kHomeSort],
      hideTabBarOnScroll: m[kHideTabBarOnScroll] == 'true',
    );
  }

  Future<void> set(String key, String? value) async {
    if (value == null) {
      await (_db.delete(_db.settings)..where((t) => t.key.equals(key))).go();
    } else {
      await _db.into(_db.settings).insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
    }
  }

  Future<void> setPrimaryCurrency(String code) => set(kPrimaryCurrency, code.toUpperCase());

  /// Legacy single-choice setter (old Settings screen) — stored as offsets.
  Future<void> setDefaultReminderDays(int days) {
    assert(ReminderDays.choices.contains(days));
    return setDefaultReminderOffsets(ReminderOffsets.fromLegacyDays(days)!);
  }

  Future<void> setDefaultReminderOffsets(Set<int> offsets) =>
      set(kDefaultReminderOffsets, ReminderOffsets.encode(offsets));

  Future<void> setHomeFilter(String? value) => set(kHomeFilter, value);

  Future<void> setHomeSort(String? value) => set(kHomeSort, value);

  Future<void> setHideTabBarOnScroll(bool on) => set(kHideTabBarOnScroll, '$on');

  Future<void> setReminderTime(int hour, int minute) =>
      set(kReminderTime, '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');

  Future<void> setThemeMode(AppThemeMode mode) => set(kThemeMode, mode.name);

  Future<void> setLocale(String? code) => set(kLocale, code);

  Future<void> setOnboardingDone(bool done) => set(kOnboardingDone, '$done');

  Future<void> setLastBackupAt(DateTime at) => set(kLastBackupAt, at.toIso8601String());

  Future<void> setRatesFetchedAt(DateTime at) => set(kRatesFetchedAt, at.toIso8601String());

  Future<void> setKeptTrials(Set<String> ids) => set(kKeptTrials, ids.isEmpty ? null : (ids.toList()..sort()).join(','));
}
