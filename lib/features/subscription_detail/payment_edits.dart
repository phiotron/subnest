import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// Edits to one confirmed Billing period that `SubscriptionRepository` does not offer yet
/// (S5 png 40 "Mark as not paid"). Kept in the feature so lib/data stays untouched; the Core
/// session can move this into the repository (see notes/2026-11-05-ui-home.md).
class PaymentEdits {
  PaymentEdits(this._db);

  final AppDatabase _db;

  /// Turns a Payment into a Skipped period (amount 0). The subscription's Due date does not move:
  /// the period stays confirmed, only its outcome changes.
  Future<void> markNotPaid(String periodId) =>
      (_db.update(_db.confirmedPeriods)..where((t) => t.id.equals(periodId))).write(
        ConfirmedPeriodsCompanion(
          outcome: Value(PeriodOutcome.skipped.name),
          amountMinor: const Value(0),
        ),
      );
}

final paymentEditsProvider = Provider<PaymentEdits>((ref) => PaymentEdits(ref.watch(databaseProvider)));
