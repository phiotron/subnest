import 'detection/detection_source.dart';
import 'local_date.dart';
import 'money.dart';

/// How the user confirmed a Billing period.
enum PeriodOutcome {
  /// "Paid" — creates a Payment with the amount actually paid.
  payment,

  /// "Not paying this period" — a Skipped period, no money spent.
  skipped,
}

/// A Billing period the user has confirmed (glossary: Payment or Skipped period).
/// Actual spending is computed only from records with [PeriodOutcome.payment].
class ConfirmedPeriod {
  const ConfirmedPeriod({
    required this.id,
    required this.subscriptionId,
    required this.dueDate,
    required this.outcome,
    required this.amountMinor,
    required this.currency,
    required this.confirmedAt,
    this.source,
  });

  final String id;
  final String subscriptionId;

  /// Due date of the Billing period this record confirms.
  final LocalDate dueDate;
  final PeriodOutcome outcome;

  /// Amount actually paid (my share), minor units. 0 for a Skipped period.
  final int amountMinor;
  final String currency;
  final DateTime confirmedAt;

  /// Set when the app confirmed this period itself from a Detected charge (ADR 0003, can be undone);
  /// `null` = confirmed by the user.
  final DetectionSource? source;

  bool get isAutoConfirmed => source != null;

  bool get isPayment => outcome == PeriodOutcome.payment;
  bool get isSkipped => outcome == PeriodOutcome.skipped;

  Money get amount => Money(amountMinor, currency);

  ConfirmedPeriod copyWith({int? amountMinor, PeriodOutcome? outcome}) => ConfirmedPeriod(
    id: id,
    subscriptionId: subscriptionId,
    dueDate: dueDate,
    outcome: outcome ?? this.outcome,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency,
    confirmedAt: confirmedAt,
    source: source,
  );

  @override
  String toString() => 'ConfirmedPeriod($subscriptionId $dueDate ${outcome.name} $amountMinor $currency)';
}
