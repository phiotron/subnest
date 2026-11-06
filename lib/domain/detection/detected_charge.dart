import '../billing_cycle.dart';
import '../local_date.dart';
import '../money.dart';
import 'detection_source.dart';

/// One charge read from a Detection source (glossary: Detected charge): service name as read,
/// amount, currency, date. Built by the scan parser (S13) / notification / Gmail readers.
class DetectedCharge {
  const DetectedCharge({
    required this.name,
    required this.amountMinor,
    required this.currency,
    required this.date,
    required this.source,
    this.id,
    this.cycle,
    this.isRenewal = false,
  });

  /// Stored id when kept as an unmatched charge; `null` for a fresh reading.
  final String? id;

  /// Service name as read ("NETFLIX.COM", "YouTube Premium").
  final String name;
  final int amountMinor;
  final String currency;

  /// Day the money left the account — or, when [isRenewal], the next renewal date read from a store page.
  final LocalDate date;
  final DetectionSource source;

  /// Billing cycle when the source shows it (store subscription page); `null` = unknown.
  final BillingCycle? cycle;

  /// `true` when [date] is an upcoming renewal ("Renews on 15 Nov"), not a past charge.
  final bool isRenewal;

  Money get amount => Money(amountMinor, currency);

  DetectedCharge withId(String id) => DetectedCharge(
    id: id,
    name: name,
    amountMinor: amountMinor,
    currency: currency,
    date: date,
    source: source,
    cycle: cycle,
    isRenewal: isRenewal,
  );

  @override
  String toString() => 'DetectedCharge($name $amountMinor $currency $date ${source.name})';
}
