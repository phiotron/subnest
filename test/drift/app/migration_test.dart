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

  test('v1 → v2 keeps data: categories, merged payment methods, reminders, history', () async {
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
    await verifier.migrateAndValidate(db, 2);
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
}
