import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../domain/domain.dart';
import 'db/app_database.dart';
import 'db/mappers.dart';

/// Outcome of [SubscriptionRepository.applyDetections] — drives the S13 result screen
/// ("Added 4 subscriptions, confirmed 1 period") and the Undo snackbars.
class DetectionReport {
  const DetectionReport({
    this.added = const [],
    this.confirmed = const [],
    this.skipped = const [],
    this.keptUnmatched = 0,
  });

  /// Auto-detected subscriptions just added (Undo → [SubscriptionRepository.undoAutoAdd]).
  final List<Subscription> added;

  /// Periods just auto-confirmed (Undo → [SubscriptionRepository.undoAutoConfirm]).
  final List<ConfirmedPeriod> confirmed;

  /// Charges left to the user (unsure / dismissed / not billing).
  final List<SkipAction> skipped;

  /// Unknown payees stored until a repeat shows they are subscriptions.
  final int keptUnmatched;
}

/// Reads/writes Subscriptions and their confirmed Billing periods.
/// All business decisions are delegated to [BillingRules] / [ChargeMatcher].
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

  /// Subscriptions with their label ids and payment method name (joined).
  JoinedSelectStatement<HasResultSet, dynamic> _joined([Expression<bool> Function($SubscriptionsTable t)? where]) {
    final q = _db.select(_db.subscriptions);
    if (where != null) q.where(where);
    q.orderBy([(t) => OrderingTerm.asc(t.name.collate(Collate.noCase))]);
    return q.join([
      leftOuterJoin(_db.paymentMethods, _db.paymentMethods.id.equalsExp(_db.subscriptions.paymentMethodId)),
      leftOuterJoin(_db.subscriptionLabels, _db.subscriptionLabels.subscriptionId.equalsExp(_db.subscriptions.id)),
    ]);
  }

  List<Subscription> _collect(List<TypedResult> rows) {
    final order = <String>[];
    final subs = <String, SubscriptionRow>{};
    final pm = <String, String?>{};
    final labels = <String, Set<String>>{};
    for (final r in rows) {
      final s = r.readTable(_db.subscriptions);
      if (!subs.containsKey(s.id)) {
        order.add(s.id);
        subs[s.id] = s;
        pm[s.id] = r.readTableOrNull(_db.paymentMethods)?.name;
        labels[s.id] = {};
      }
      final l = r.readTableOrNull(_db.subscriptionLabels);
      if (l != null) labels[s.id]!.add(l.labelId);
    }
    return [
      for (final id in order) subs[id]!.toDomain(labelIds: labels[id]!, paymentMethodName: pm[id]),
    ];
  }

  Stream<List<Subscription>> watchAll() => _joined().watch().map(_collect);

  Future<List<Subscription>> all() async => _collect(await _joined().get());

  Future<Subscription?> get(String id) async => _collect(await _joined((t) => t.id.equals(id)).get()).firstOrNull;

  Stream<Subscription?> watch(String id) => _joined((t) => t.id.equals(id)).watch().map((r) => _collect(r).firstOrNull);

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
  /// A Payment method given only by name ([Subscription.paymentMethod], id `null`) is found or created.
  /// Label links are replaced by [Subscription.labelIds].
  Future<void> save(Subscription s) => _db.transaction(() async {
    var row = s;
    final pmName = s.paymentMethod?.trim();
    if (s.paymentMethodId == null && pmName != null && pmName.isNotEmpty) {
      row = s.copyWith(paymentMethodId: await paymentMethodIdForName(pmName));
    }
    await _db.into(_db.subscriptions).insertOnConflictUpdate(row.toCompanion());
    await (_db.delete(_db.subscriptionLabels)..where((t) => t.subscriptionId.equals(s.id))).go();
    for (final l in s.labelIds) {
      await _db.into(_db.subscriptionLabels).insert(
        SubscriptionLabelsCompanion.insert(subscriptionId: s.id, labelId: l),
        mode: InsertMode.insertOrIgnore,
      );
    }
  });

  /// Id of the Payment method named [name] (merged case/space-insensitively), created when missing.
  Future<String> paymentMethodIdForName(String name) async {
    final key = PaymentMethod.normalizeName(name);
    final rows = await _db.select(_db.paymentMethods).get();
    for (final r in rows) {
      if (PaymentMethod.normalizeName(r.name) == key) return r.id;
    }
    final id = _newId();
    await _db.into(_db.paymentMethods).insert(
      PaymentMethodsCompanion.insert(id: id, name: name.trim().replaceAll(RegExp(r'\s+'), ' '), sortOrder: rows.length),
    );
    return id;
  }

  /// Deletes the subscription and its whole history (Payments, Skipped periods).
  /// Removing an Auto-detected subscription also remembers it so it is never auto-added again (ADR 0003).
  Future<void> delete(String id) => _db.transaction(() async {
    final s = await get(id);
    if (s != null && s.isAutoDetected) await dismiss(DismissKey.of(s));
    await (_db.delete(_db.subscriptions)..where((t) => t.id.equals(id))).go();
  });

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
        await _saveRow(r.subscription);
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
      await _saveRow(updated);
      count += periods.length;
    }
    return count;
  });

  /// Edits the amount of a Payment (history row tap).
  Future<void> updatePeriodAmount(String periodId, int amountMinor) =>
      (_db.update(_db.confirmedPeriods)..where((t) => t.id.equals(periodId)))
          .write(ConfirmedPeriodsCompanion(amountMinor: Value(amountMinor)));

  Future<void> cancel(String id) async => _saveRow(BillingRules.cancel(await _require(id), _today, _clock()));

  Future<void> restore(String id) async => _saveRow(BillingRules.restore(await _require(id), _today, _clock()));

  /// Pauses from the next Due date (glossary: Paused).
  Future<void> pause(String id) async => _saveRow(BillingRules.pause(await _require(id), _today, _clock()));

  /// Resumes with the next Due date the user picked (UI default: today).
  Future<void> resume(String id, LocalDate nextDueDate) async =>
      _saveRow(BillingRules.resume(await _require(id), nextDueDate, _clock()));

  Future<void> setWorthIt(String id, WorthIt? rating) async =>
      _saveRow((await _require(id)).copyWith(worthIt: rating, updatedAt: _clock()));

  /// Persists Trial → Active for trials that have ended. Call on app start / resume.
  Future<int> normalizeAll() => _db.transaction(() async {
    var n = 0;
    for (final s in await all()) {
      final normalized = BillingRules.normalize(s, _today, _clock());
      if (!identical(normalized, s)) {
        await _saveRow(normalized);
        n++;
      }
    }
    return n;
  });

  // ---- Detection (ADR 0003) ------------------------------------------------------------------

  Future<List<DetectedCharge>> unmatchedCharges() async =>
      (await _db.select(_db.detectedCharges).get()).map((r) => r.toDomain()).toList();

  Future<Set<String>> dismissedKeys() async =>
      {for (final r in await _db.select(_db.dismissedDetections).get()) r.key};

  /// Remembers that the user removed an Auto-detected subscription ([DismissKey]).
  Future<void> dismiss(String key) => _db.into(_db.dismissedDetections).insert(
    DismissedDetectionsCompanion.insert(key: key, createdAt: _clock()),
    mode: InsertMode.insertOrIgnore,
  );

  /// Matches [charges] against the subscriptions and applies the sure actions in one transaction:
  /// auto-add (label Auto-detected), auto-confirm (Payment with the charged amount), store unknown payees.
  Future<DetectionReport> applyDetections(
    List<DetectedCharge> charges, {
    required List<CatalogService> catalog,
    required String region,
  }) => _db.transaction(() async {
    final actions = ChargeMatcher(catalog: catalog, region: region).match(
      charges,
      subscriptions: await all(),
      unmatched: await unmatchedCharges(),
      dismissed: await dismissedKeys(),
      today: _today,
      now: _clock(),
      newId: _newId,
    );
    final added = <Subscription>[];
    final confirmed = <ConfirmedPeriod>[];
    final skipped = <SkipAction>[];
    var kept = 0;
    for (final a in actions) {
      switch (a) {
        case AutoConfirmAction(:final result):
          await _db.into(_db.confirmedPeriods).insert(result.period.toCompanion(), mode: InsertMode.insertOrReplace);
          await _saveRow(result.subscription);
          confirmed.add(result.period);
        case AutoAddAction(:final subscription, :final payment, :final consumedChargeIds):
          await save(subscription);
          if (payment != null) await _db.into(_db.confirmedPeriods).insert(payment.toCompanion());
          for (final id in consumedChargeIds) {
            await (_db.delete(_db.detectedCharges)..where((t) => t.id.equals(id))).go();
          }
          added.add(subscription);
        case KeepUnmatchedAction(:final charge):
          await _db.into(_db.detectedCharges).insert(charge.toCompanion(charge.id ?? _newId(), _clock()));
          kept++;
        case SkipAction():
          skipped.add(a);
      }
    }
    return DetectionReport(added: added, confirmed: confirmed, skipped: skipped, keptUnmatched: kept);
  });

  /// Undo of an auto-add: deletes the subscription and never auto-adds it again.
  Future<void> undoAutoAdd(String subscriptionId) => delete(subscriptionId);

  /// Undo of an auto-confirm: removes the Payment; the period is pending again when it was the latest.
  Future<void> undoAutoConfirm(String periodId) => _db.transaction(() async {
    final row = await (_db.select(_db.confirmedPeriods)..where((t) => t.id.equals(periodId))).getSingleOrNull();
    if (row == null) return;
    final period = row.toDomain();
    final s = await get(period.subscriptionId);
    await (_db.delete(_db.confirmedPeriods)..where((t) => t.id.equals(periodId))).go();
    if (s != null) {
      final back = BillingRules.undoConfirm(s, period, _clock());
      if (!identical(back, s)) await _saveRow(back);
    }
  });

  /// Clears the Auto-detected mark (the user keeps the subscription as their own).
  Future<void> clearAutoDetected(String id) async =>
      _saveRow((await _require(id)).copyWith(detectionSource: null, detectedAt: null, updatedAt: _clock()));

  // ---- Helpers -------------------------------------------------------------------------------

  /// Writes only the subscriptions row (labels untouched) — for rule-driven updates.
  Future<void> _saveRow(Subscription s) => _db.into(_db.subscriptions).insertOnConflictUpdate(s.toCompanion());

  Future<Subscription> _require(String id) async {
    final s = await get(id);
    if (s == null) throw StateError('Subscription $id not found');
    return s;
  }
}
