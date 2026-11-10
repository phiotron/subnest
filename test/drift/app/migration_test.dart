// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart' hide isNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // Reads through the current repository, so it migrates to the latest version.
  test('v1 → latest keeps v2 data: categories, merged payment methods, reminders, history', () async {
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    Future<void> sub(String id, String cat, String? pm, int? remind, int created) => old.customStatement(
      'INSERT INTO subscriptions (id, name, service_id, color_value, icon_text, category, price_minor, currency, '
      'cycle_every, cycle_unit, anchor_date, period_index, status, trial_end_date, shared_with, reminder_days, '
      'payment_method, manage_url, notes, start_date, cancelled_on, created_at, updated_at) VALUES '
      '(?, ?, NULL, 1, NULL, ?, 26000000, ?, 1, ?, ?, 2, ?, NULL, 1, ?, ?, NULL, NULL, ?, NULL, ?, ?)',
      [id, 'Sub $id', cat, 'VND', 'month', '2026-09-15', 'active', remind, pm, '2026-09-01', created, created],
    );
    await sub('a', 'video', 'Visa ••4821', 3, 1);
    await sub('b', 'music', '  visa   ••4821 ', null, 2);
    await sub('c', 'weird-old', 'MoMo', -1, 3);
    await sub('d', 'ai', null, 0, 4);
    await sub('e', 'gaming', "O'Brien card", 7, 5);
    await old.customStatement(
      "INSERT INTO confirmed_periods (id, subscription_id, due_date, outcome, amount_minor, currency, confirmed_at) "
      "VALUES ('p1', 'a', '2026-09-15', 'payment', 26000000, 'VND', 10)",
    );
    await old.customStatement("INSERT INTO settings (key, value) VALUES ('defaultReminderDays', '7')");
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, GeneratedHelper.versions.last);
    final repo = SubscriptionRepository(db);
    final subs = {for (final s in await repo.all()) s.id: s};
    expect(subs.length, 5);
    expect(subs['a']!.categoryId, 'video');
    expect(subs['c']!.categoryId, 'other');
    expect(subs['a']!.paymentMethodId, subs['b']!.paymentMethodId);
    expect(subs['a']!.paymentMethod, 'Visa ••4821');
    expect(subs['c']!.paymentMethod, 'MoMo');
    expect(subs['d']!.paymentMethodId, isNull);
    expect(subs['e']!.paymentMethod, "O'Brien card");
    expect(subs['a']!.reminderOffsets, {0, 3});
    expect(subs['b']!.reminderOffsets, isNull);
    expect(subs['c']!.reminderOffsets, isEmpty);
    expect(subs['d']!.reminderOffsets, {0});
    expect(subs['a']!.periodIndex, 2);
    expect(subs['a']!.priceMinor, 26000000);
    expect((await db.select(db.paymentMethods).get()).length, 3);
    expect((await db.select(db.categories).get()).length, 11);
    final periods = await repo.allPeriods();
    expect(periods.single.id, 'p1');
    expect(periods.single.source, isNull);
    final set = await (db.select(db.settings)..where((t) => t.key.equals('defaultReminderOffsets'))).getSingle();
    expect(set.value, '0,7');
    await db.close();
  });

  test('v1 → v3 keeps data; custom logo column + price history from Payments', () async {
    final schema = await verifier.schemaAt(1);
    final old = v1.DatabaseAtV1(schema.newConnection());
    await old.customStatement(
      'INSERT INTO subscriptions (id, name, service_id, color_value, icon_text, category, price_minor, currency, '
      'cycle_every, cycle_unit, anchor_date, period_index, status, trial_end_date, shared_with, reminder_days, '
      'payment_method, manage_url, notes, start_date, cancelled_on, created_at, updated_at) VALUES '
      "('a', 'Netflix', NULL, 1, 'N', 'video', 26000000, 'VND', 1, 'month', '2026-07-15', 4, 'active', NULL, 1, 3, "
      "'Visa', NULL, NULL, '2026-07-15', NULL, 1, 1)",
    );
    for (final (i, (due, amount)) in [
      ('2026-07-15', 22000000),
      ('2026-08-15', 22000000),
      ('2026-09-15', 26000000),
      ('2026-10-15', 26000000),
    ].indexed) {
      await old.customStatement(
        'INSERT INTO confirmed_periods (id, subscription_id, due_date, outcome, amount_minor, currency, confirmed_at) '
        "VALUES ('p$i', 'a', '$due', 'payment', $amount, 'VND', 10)",
      );
    }
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 3);
    final repo = SubscriptionRepository(db);
    final a = (await repo.all()).single;
    expect(a.name, 'Netflix');
    expect(a.iconText, 'N');
    expect(a.customLogoFile, isNull);
    expect(a.paymentMethod, 'Visa');
    expect(a.reminderOffsets, {0, 3});
    expect((await repo.allPeriods()).length, 4);
    final changes = await repo.allPriceChanges();
    expect(changes, hasLength(1));
    expect(changes.single.oldPriceMinor, 22000000);
    expect(changes.single.newPriceMinor, 26000000);
    expect(changes.single.effectiveFrom.toString(), '2026-09-15');
    expect(changes.single.source.name, 'backfill');
    await db.close();
  });

  test('v2 → v3 keeps data, adds the custom logo column and backfills price history', () async {
    final schema = await verifier.schemaAt(2);
    final old = v2.DatabaseAtV2(schema.newConnection());
    Future<void> sub(String id, int price, int shared) => old.customStatement(
      'INSERT INTO subscriptions (id, name, service_id, color_value, icon_text, category_id, price_minor, currency, '
      'cycle_every, cycle_unit, anchor_date, period_index, status, trial_end_date, shared_with, reminder_offsets, '
      'payment_method_id, manage_url, notes, start_date, cancelled_on, paused_from, worth_it, detection_source, '
      'detected_at, created_at, updated_at) VALUES '
      "(?, ?, NULL, 1, NULL, 'music', ?, 'USD', 1, 'month', '2026-06-01', 5, 'paused', NULL, ?, '0,3', NULL, NULL, "
      "NULL, '2026-06-01', NULL, '2026-11-01', 'worth', NULL, NULL, 1, 1)",
      [id, 'Sub $id', price, shared],
    );
    await sub('a', 1199, 1);
    await sub('b', 1999, 2);
    var n = 0;
    Future<void> pay(String sub, String due, int amount, {String? source}) => old.customStatement(
      'INSERT INTO confirmed_periods (id, subscription_id, due_date, outcome, amount_minor, currency, confirmed_at, '
      "source) VALUES ('q${n++}', ?, ?, 'payment', ?, 'USD', 10, ?)",
      [sub, due, amount, source],
    );
    // a: 10.99 ×2 → 11.99 ×2 (one odd 5.00 in between is ignored).
    await pay('a', '2026-06-01', 1099);
    await pay('a', '2026-07-01', 1099);
    await pay('a', '2026-08-01', 500);
    await pay('a', '2026-09-01', 1199);
    await pay('a', '2026-10-01', 1199);
    // b: shared by 2, paid 7.50 twice, then the price was edited to 19.99 (share 10.00) without a record;
    // an auto-detected 9.99 charge is not the price.
    await pay('b', '2026-09-01', 750);
    await pay('b', '2026-10-01', 750);
    await pay('b', '2026-10-15', 999, source: 'scan');
    await old.close();

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 3);
    final repo = SubscriptionRepository(db);
    final subs = {for (final s in await repo.all()) s.id: s};
    expect(subs['a']!.pausedFrom.toString(), '2026-11-01');
    expect(subs['a']!.worthIt?.name, 'worth');
    expect(subs['b']!.sharedWith, 2);
    expect((await repo.allPeriods()).length, 8);
    final changes = {for (final c in await repo.allPriceChanges()) c.subscriptionId: c};
    expect(changes['a']!.oldPriceMinor, 1099);
    expect(changes['a']!.newPriceMinor, 1199);
    expect(changes['a']!.effectiveFrom.toString(), '2026-09-01');
    expect(changes['b']!.oldPriceMinor, 1500);
    expect(changes['b']!.newPriceMinor, 1999);
    // No user-confirmed Payment after the last run (2026-10-01) → the current Due date (anchor + 5 months).
    expect(changes['b']!.effectiveFrom.toString(), '2026-11-01');

    // Custom logo column is writable.
    await repo.save(subs['a']!.copyWith(customLogoFile: 'a.png'));
    expect((await repo.get('a'))!.customLogoFile, 'a.png');
    // Deleting a subscription removes its price history.
    await repo.delete('a');
    expect((await repo.allPriceChanges()).map((c) => c.subscriptionId), ['b']);
    await db.close();
  });
}
