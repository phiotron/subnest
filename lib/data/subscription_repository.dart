import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/domain.dart';
import 'db/app_database.dart';
import 'db/mappers.dart';

/// Reads/writes Subscriptions and their confirmed Billing periods.
/// All business decisions are delegated to [BillingRules].
class SubscriptionRepository {
  SubscriptionRepository(this._db, {DateTime Function()? clock, String Function()? newId})
    : _clock = clock ?? DateTime.now,
      _newId = newId ?? const Uuid().v4;

  final AppDatabase _db;
  final DateTime Function() _clock;
  final String Function() _newId;

  String newId() => _newId();

  LocalDate get _today => LocalDate.fromDateTime(_clock());

  // ---- Queries -------------------------------------------------------------------------------

  Stream<List<Subscription>> watchAll() => (_db.select(_db.subscriptions)
        ..orderBy([(t) => OrderingTerm.asc(t.name.collate(Collate.noCase))]))
      .watch()
      .map((rows) => rows.map((r) => r.toDomain()).toList());

  Future<List<Subscription>> all() async =>
      (await _db.select(_db.subscriptions).get()).map((r) => r.toDomain()).toList();

  Future<Subscription?> get(String id) async =>
      (await (_db.select(_db.subscriptions)..where((t) => t.id.equals(id))).getSingleOrNull())?.toDomain();

  Stream<Subscription?> watch(String id) => (_db.select(_db.subscriptions)..where((t) => t.id.equals(id)))
      .watchSingleOrNull()
      .map((r) => r?.toDomain());

  /// Payments + Skipped periods, newest first. Pass [subscriptionId] for one subscription's history.
  Stream<List<ConfirmedPeriod>> watchPeriods({String? subscriptionId}) {
    final q = _db.select(_db.confirmedPeriods)..orderBy([(t) => OrderingTerm.desc(t.dueDate)]);
    if (subscriptionId != null) q.where((t) => t.subscriptionId.equals(subscriptionId));
    return q.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<List<ConfirmedPeriod>> allPeriods() async =>
      (await _db.select(_db.confirmedPeriods).get()).map((r) => r.toDomain()).toList();

  // ---- Commands ------------------------------------------------------------------------------

  /// Inserts or updates. Uses an UPSERT (not REPLACE) so the period history is not cascaded away.
  Future<void> save(Subscription s) =>
      _db.into(_db.subscriptions).insertOnConflictUpdate(s.toCompanion());

  /// Deletes the subscription and its whole history (Payments, Skipped periods).
  Future<void> delete(String id) => (_db.delete(_db.subscriptions)..where((t) => t.id.equals(id))).go();

  /// Confirms the current pending period of [id]. Returns the new record.
  Future<ConfirmedPeriod> confirm(String id, PeriodOutcome outcome, {int? amountMinor}) =>
      _db.transaction(() async {
        final s = await _require(id);
        final r = BillingRules.confirm(
          s,
          outcome: outcome,
          amountMinor: amountMinor,
          today: _today,
          now: _clock(),
          newId: _newId,
        );
        // REPLACE resolves a (subscription, due date) clash left by an imported history.
        await _db.into(_db.confirmedPeriods).insert(r.period.toCompanion(), mode: InsertMode.insertOrReplace);
        await save(r.subscription);
        return r.period;
      });

  /// "Confirm all" — every pending period of [ids] (all subscriptions when null) paid at current My share.
  /// Returns the number of periods confirmed.
  Future<int> confirmAll({Iterable<String>? ids}) => _db.transaction(() async {
    final subs = ids == null ? await all() : [for (final id in ids) await _require(id)];
    var count = 0;
    for (final s in subs) {
      final (updated, periods) = BillingRules.confirmAll(s, today: _today, now: _clock(), newId: _newId);
      if (periods.isEmpty) continue;
      for (final p in periods) {
        await _db.into(_db.confirmedPeriods).insert(p.toCompanion(), mode: InsertMode.insertOrReplace);
      }
      await save(updated);
      count += periods.length;
    }
    return count;
  });

  /// Edits the amount of a Payment (history row tap).
  Future<void> updatePeriodAmount(String periodId, int amountMinor) =>
      (_db.update(_db.confirmedPeriods)..where((t) => t.id.equals(periodId)))
          .write(ConfirmedPeriodsCompanion(amountMinor: Value(amountMinor)));

  Future<void> cancel(String id) async => save(BillingRules.cancel(await _require(id), _today, _clock()));

  Future<void> restore(String id) async => save(BillingRules.restore(await _require(id), _today, _clock()));

  /// Persists Trial → Active for trials that have ended. Call on app start / resume.
  Future<int> normalizeAll() => _db.transaction(() async {
    var n = 0;
    for (final s in await all()) {
      final normalized = BillingRules.normalize(s, _today, _clock());
      if (!identical(normalized, s)) {
        await save(normalized);
        n++;
      }
    }
    return n;
  });

  Future<Subscription> _require(String id) async {
    final s = await get(id);
    if (s == null) throw StateError('Subscription $id not found');
    return s;
  }
}
