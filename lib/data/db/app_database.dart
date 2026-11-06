import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/category.dart';

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
  // v2: was `category` (built-in key); built-in categories keep their key as id.
  TextColumn get categoryId => text().withDefault(const Constant('other'))();
  IntColumn get priceMinor => integer()();
  TextColumn get currency => text()();
  IntColumn get cycleEvery => integer()();
  TextColumn get cycleUnit => text()();
  TextColumn get anchorDate => text()();
  IntColumn get periodIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  TextColumn get trialEndDate => text().nullable()();
  IntColumn get sharedWith => integer().withDefault(const Constant(1))();
  // v2: was `reminder_days` (int). "0,3,7"; '' = off; NULL = Settings default.
  TextColumn get reminderOffsets => text().nullable()();
  // v2: was `payment_method` (free text) → row in payment_methods.
  TextColumn get paymentMethodId => text().nullable()();
  TextColumn get manageUrl => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get startDate => text()();
  TextColumn get cancelledOn => text().nullable()();
  TextColumn get pausedFrom => text().nullable()();
  TextColumn get worthIt => text().nullable()();
  TextColumn get detectionSource => text().nullable()();
  DateTimeColumn get detectedAt => dateTime().nullable()();
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

  /// v2: Detection source when the app confirmed it itself (ADR 0003); NULL = by the user.
  TextColumn get source => text().nullable()();

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

@DataClassName('CategoryRow')
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  IntColumn get colorValue => integer()();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer()();
  TextColumn get builtInKey => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LabelRow')
class Labels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get colorValue => integer().nullable()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SubscriptionLabelRow')
class SubscriptionLabels extends Table {
  TextColumn get subscriptionId => text().references(Subscriptions, #id, onDelete: KeyAction.cascade)();
  TextColumn get labelId => text().references(Labels, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {subscriptionId, labelId};
}

@DataClassName('PaymentMethodRow')
class PaymentMethods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Monthly budgets; `category_id` NULL = the overall budget.
@DataClassName('BudgetRow')
class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Detected charges not (yet) matched to a subscription (evidence for "≥ 2 charges ~1 cycle apart").
@DataClassName('DetectedChargeRow')
class DetectedCharges extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text()();
  TextColumn get date => text()();
  TextColumn get source => text()();
  IntColumn get cycleEvery => integer().nullable()();
  TextColumn get cycleUnit => text().nullable()();
  BoolColumn get isRenewal => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Auto-detected subscriptions the user removed — never added again (key: see DismissKey).
@DataClassName('DismissedDetectionRow')
class DismissedDetections extends Table {
  TextColumn get key => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Subscriptions,
    ConfirmedPeriods,
    CachedRates,
    RateOverrides,
    Settings,
    Categories,
    Labels,
    SubscriptionLabels,
    PaymentMethods,
    Budgets,
    DetectedCharges,
    DismissedDetections,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// On-device database file `subnest.sqlite`.
  AppDatabase.defaults() : super(driftDatabase(name: 'subnest'));

  /// Bump when changing tables, then run `dart run drift_dev make-migrations`
  /// (see docs/dev.md → Database migrations) and add a step in [migration].
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedCategories();
    },
    onUpgrade: (m, from, to) async {
      // Table rebuilds must not cascade-delete history (drift docs: migrations + foreign keys).
      await customStatement('PRAGMA foreign_keys = OFF');
      await transaction(() async {
        if (from < 2) await _from1To2(m);
      });
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static String _sql(String v) => "'${v.replaceAll("'", "''")}'";

  /// Merge key of a payment method name (same rule as PaymentMethod.normalizeName).
  static String _pmKey(String v) => v.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// v1 → v2 (1.0 expansion): categories, labels, payment methods, budgets, multi-point reminders,
  /// Paused / Worth-it, detection. Old data is kept: category key → category id (seeded with the same
  /// ids), payment method text → payment_methods rows (duplicates merged), reminder_days → offsets.
  Future<void> _from1To2(Migrator m) async {
    for (final t in <TableInfo>[
      categories,
      labels,
      subscriptionLabels,
      paymentMethods,
      budgets,
      detectedCharges,
      dismissedDetections,
    ]) {
      await m.createTable(t);
    }
    await m.addColumn(confirmedPeriods, confirmedPeriods.source);
    await seedCategories();

    // Payment method strings → rows, merged case/space-insensitively; first spelling (oldest subscription) wins.
    final old = await customSelect(
      "SELECT payment_method AS pm FROM subscriptions WHERE payment_method IS NOT NULL AND trim(payment_method) <> '' "
      'ORDER BY created_at',
    ).get();
    final idByKey = <String, String>{};
    final idByRaw = <String, String>{};
    for (final r in old) {
      final raw = r.read<String>('pm');
      final key = _pmKey(raw);
      var id = idByKey[key];
      if (id == null) {
        id = 'pm-${idByKey.length + 1}';
        idByKey[key] = id;
        await into(paymentMethods).insert(
          PaymentMethodsCompanion.insert(
            id: id,
            name: raw.trim().replaceAll(RegExp(r'\s+'), ' '),
            sortOrder: idByKey.length - 1,
          ),
        );
      }
      idByRaw[raw] = id;
    }
    final pmCase = idByRaw.isEmpty
        ? 'NULL'
        : 'CASE payment_method ${[for (final e in idByRaw.entries) 'WHEN ${_sql(e.key)} THEN ${_sql(e.value)}'].join(' ')} '
              'ELSE NULL END';
    final keys = SubscriptionCategory.values.map((c) => _sql(c.key)).join(', ');

    await m.alterTable(
      TableMigration(
        subscriptions,
        columnTransformer: {
          subscriptions.categoryId: CustomExpression<String>(
            "CASE WHEN category IN ($keys) THEN category ELSE 'other' END",
          ),
          subscriptions.reminderOffsets: const CustomExpression<String>(
            "CASE WHEN reminder_days IS NULL THEN NULL WHEN reminder_days < 0 THEN '' "
            "WHEN reminder_days = 0 THEN '0' ELSE '0,' || reminder_days END",
          ),
          subscriptions.paymentMethodId: CustomExpression<String>(pmCase),
        },
        newColumns: [
          subscriptions.categoryId,
          subscriptions.reminderOffsets,
          subscriptions.paymentMethodId,
          subscriptions.pausedFrom,
          subscriptions.worthIt,
          subscriptions.detectionSource,
          subscriptions.detectedAt,
        ],
      ),
    );

    // Settings: single default reminder → offsets (old key kept for downgrade safety).
    final def = await (select(settings)..where((t) => t.key.equals('defaultReminderDays'))).getSingleOrNull();
    final days = int.tryParse(def?.value ?? '');
    if (days != null) {
      final offsets = days < 0 ? '' : (days == 0 ? '0' : '0,$days');
      await into(settings).insertOnConflictUpdate(
        SettingsCompanion.insert(key: 'defaultReminderOffsets', value: offsets),
      );
    }
  }

  /// Inserts the 11 built-in categories when missing (install, migration, restore).
  Future<void> seedCategories() async {
    for (final c in CategoryRules.seed()) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          id: c.id,
          colorValue: c.colorValue,
          sortOrder: c.sortOrder,
          builtInKey: Value(c.builtInKey),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }

  /// Deletes all user data (used by "restore — replace"). Built-in categories are seeded again.
  Future<void> wipeUserData() => transaction(() async {
    await delete(subscriptionLabels).go();
    await delete(confirmedPeriods).go();
    await delete(subscriptions).go();
    await delete(rateOverrides).go();
    await delete(labels).go();
    await delete(paymentMethods).go();
    await delete(budgets).go();
    await delete(categories).go();
    await delete(detectedCharges).go();
    await delete(dismissedDetections).go();
    await seedCategories();
  });
}
