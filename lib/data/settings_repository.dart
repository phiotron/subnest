import 'package:intl/intl.dart';

import '../domain/domain.dart';
import 'db/app_database.dart';

enum AppThemeMode { system, light, dark }

/// User preferences (S10). Immutable snapshot; write through [SettingsRepository].
class AppSettings {
  const AppSettings({
    required this.primaryCurrency,
    this.defaultReminderDays = 3,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.themeMode = AppThemeMode.system,
    this.localeCode,
    this.onboardingDone = false,
    this.lastBackupAt,
    this.ratesFetchedAt,
  });

  final String primaryCurrency;

  /// Default "remind N days before" ([ReminderDays.off] = off).
  final int defaultReminderDays;
  final int reminderHour;
  final int reminderMinute;
  final AppThemeMode themeMode;

  /// `null` = follow the system; otherwise `en` / `vi`.
  final String? localeCode;
  final bool onboardingDone;
  final DateTime? lastBackupAt;
  final DateTime? ratesFetchedAt;
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
  static const kDefaultReminderDays = 'defaultReminderDays';
  static const kReminderTime = 'reminderTime'; // "HH:mm"
  static const kThemeMode = 'themeMode';
  static const kLocale = 'locale';
  static const kOnboardingDone = 'onboardingDone';
  static const kLastBackupAt = 'lastBackupAt';
  static const kRatesFetchedAt = 'ratesFetchedAt';

  /// Keys copied into / restored from a JSON backup.
  static const backupKeys = [kPrimaryCurrency, kDefaultReminderDays, kReminderTime, kThemeMode, kLocale];

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
      defaultReminderDays: int.tryParse(m[kDefaultReminderDays] ?? '') ?? 3,
      reminderHour: int.tryParse(time.first) ?? 9,
      reminderMinute: time.length > 1 ? int.tryParse(time[1]) ?? 0 : 0,
      themeMode: AppThemeMode.values.firstWhere((e) => e.name == m[kThemeMode], orElse: () => AppThemeMode.system),
      localeCode: m[kLocale],
      onboardingDone: m[kOnboardingDone] == 'true',
      lastBackupAt: DateTime.tryParse(m[kLastBackupAt] ?? ''),
      ratesFetchedAt: DateTime.tryParse(m[kRatesFetchedAt] ?? ''),
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

  Future<void> setDefaultReminderDays(int days) {
    assert(ReminderDays.choices.contains(days));
    return set(kDefaultReminderDays, '$days');
  }

  Future<void> setReminderTime(int hour, int minute) =>
      set(kReminderTime, '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}');

  Future<void> setThemeMode(AppThemeMode mode) => set(kThemeMode, mode.name);

  Future<void> setLocale(String? code) => set(kLocale, code);

  Future<void> setOnboardingDone(bool done) => set(kOnboardingDone, '$done');

  Future<void> setLastBackupAt(DateTime at) => set(kLastBackupAt, at.toIso8601String());

  Future<void> setRatesFetchedAt(DateTime at) => set(kRatesFetchedAt, at.toIso8601String());
}
