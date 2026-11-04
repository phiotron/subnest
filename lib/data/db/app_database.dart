import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// Storage notes:
// - Dates (Due date, Trial end…) are ISO `YYYY-MM-DD` text, matching LocalDate.toString().
// - Enums are stored by name (stable when enum order changes).
// - Amounts are integer minor units of their currency (see lib/domain/money.dart).

@DataClassName('SubscriptionRow')
class Subscriptions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get serviceId => text().nullable()();
  IntColumn get colorValue => integer()();
  TextColumn get iconText => text().nullable()();
  TextColumn get category => text()();
  IntColumn get priceMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get cycleEvery => integer()();
  TextColumn get cycleUnit => text()();
  TextColumn get anchorDate => text()();
  IntColumn get periodIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  TextColumn get trialEndDate => text().nullable()();
  IntColumn get sharedWith => integer().withDefault(const Constant(1))();
  IntColumn get reminderDays => integer().nullable()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get manageUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get startDate => text()();
  TextColumn get cancelledOn => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Payments and Skipped periods.
@DataClassName('ConfirmedPeriodRow')
class ConfirmedPeriods extends Table {
  TextColumn get id => text()();
  TextColumn get subscriptionId => text().references(Subscriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get dueDate => text()();
  TextColumn get outcome => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get confirmedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {subscriptionId, dueDate},
  ];
}

/// Provider rates, "units per 1 USD" (cache for offline use).
@DataClassName('CachedRateRow')
class CachedRates extends Table {
  TextColumn get code => text()();
  RealColumn get perUsd => real()();

  @override
  Set<Column> get primaryKey => {code};
}

/// User overrides, key `FROM>TO` (1 FROM = rate TO).
@DataClassName('RateOverrideRow')
class RateOverrides extends Table {
  TextColumn get pair => text()();
  RealColumn get rate => real()();

  @override
  Set<Column> get primaryKey => {pair};
}

/// Key-value app settings (see SettingsRepository for keys).
@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Subscriptions, ConfirmedPeriods, CachedRates, RateOverrides, Settings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// On-device database file `subnest.sqlite`.
  AppDatabase.defaults() : super(driftDatabase(name: 'subnest'));

  /// Bump when changing tables, then run `dart run drift_dev make-migrations`
  /// (see docs/dev.md → Database migrations) and add a step in [migration].
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Example for v2 (generated helpers in app_database.steps.dart):
      // await m.runMigrationSteps(from: from, to: to, steps: migrationSteps(from1To2: (m, schema) async {...}));
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Deletes all user data (used by "restore — replace").
  Future<void> wipeUserData() => transaction(() async {
    await delete(confirmedPeriods).go();
    await delete(subscriptions).go();
    await delete(rateOverrides).go();
  });
}
