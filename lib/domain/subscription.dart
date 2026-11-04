import 'billing_cycle.dart';
import 'category.dart';
import 'local_date.dart';
import 'money.dart';

/// Stored status of a Subscription. Use `SubscriptionRules.effectiveStatus`
/// for display: a Trial whose end date has arrived is already `active`.
enum SubscriptionStatus { trial, active, cancelled }

/// Reminder setting of one Subscription.
///
/// `null` in [Subscription.reminderDays] means "use the default from Settings".
abstract final class ReminderDays {
  static const int off = -1;
  static const int onTheDay = 0;

  /// Choices offered in the UI (product.md §3.11).
  static const List<int> choices = [off, onTheDay, 1, 3, 7];
}

/// A recurring payment the user tracks (glossary: Subscription).
///
/// The current Due date is derived: `cycle.occurrence(anchorDate, periodIndex)`.
/// Confirming a Billing period increments [periodIndex]; editing the due date or
/// the cycle re-anchors (`anchorDate = new due date`, `periodIndex = 0`).
class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.priceMinor,
    required this.currency,
    required this.cycle,
    required this.anchorDate,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
    this.periodIndex = 0,
    this.status = SubscriptionStatus.active,
    this.serviceId,
    this.colorValue = 0xFF607D8B,
    this.iconText,
    this.category = SubscriptionCategory.other,
    this.trialEndDate,
    this.sharedWith = 1,
    this.reminderDays,
    this.paymentMethod,
    this.manageUrl,
    this.notes,
    this.cancelledOn,
  }) : assert(sharedWith >= 1),
       assert(periodIndex >= 0);

  final String id;

  /// Display name, usually service + plan ("Netflix Premium").
  final String name;

  /// Catalog Service id, `null` for a custom service.
  final String? serviceId;

  /// Tile colour (ARGB).
  final int colorValue;

  /// Monogram or emoji override for the tile; `null` = initials of [name].
  final String? iconText;

  final SubscriptionCategory category;

  /// Full plan price for one Billing period, minor units of [currency].
  final int priceMinor;
  final String currency;

  final BillingCycle cycle;
  final LocalDate anchorDate;
  final int periodIndex;

  final SubscriptionStatus status;

  /// Last day of the Trial = Due date of the first paid Billing period.
  final LocalDate? trialEndDate;

  /// Number of people sharing the plan, including the user. 1 = not shared.
  final int sharedWith;

  /// Days before the Due date to remind (see [ReminderDays]); `null` = Settings default.
  final int? reminderDays;

  final String? paymentMethod;

  /// "How to cancel / manage" link.
  final String? manageUrl;
  final String? notes;

  /// "Started on" shown in details.
  final LocalDate startDate;
  final LocalDate? cancelledOn;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Current Due date (stands still until the period is confirmed — ADR 0001).
  LocalDate get dueDate => cycle.occurrence(anchorDate, periodIndex);

  bool get isShared => sharedWith > 1;

  /// My share of one Billing period, minor units (rounded to the currency's minor unit).
  int get myShareMinor => isShared ? (priceMinor / sharedWith).round() : priceMinor;

  Money get price => Money(priceMinor, currency);
  Money get myShare => Money(myShareMinor, currency);

  Subscription copyWith({
    String? name,
    Object? serviceId = _keep,
    int? colorValue,
    Object? iconText = _keep,
    SubscriptionCategory? category,
    int? priceMinor,
    String? currency,
    BillingCycle? cycle,
    LocalDate? anchorDate,
    int? periodIndex,
    SubscriptionStatus? status,
    Object? trialEndDate = _keep,
    int? sharedWith,
    Object? reminderDays = _keep,
    Object? paymentMethod = _keep,
    Object? manageUrl = _keep,
    Object? notes = _keep,
    LocalDate? startDate,
    Object? cancelledOn = _keep,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id,
      name: name ?? this.name,
      serviceId: identical(serviceId, _keep) ? this.serviceId : serviceId as String?,
      colorValue: colorValue ?? this.colorValue,
      iconText: identical(iconText, _keep) ? this.iconText : iconText as String?,
      category: category ?? this.category,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      cycle: cycle ?? this.cycle,
      anchorDate: anchorDate ?? this.anchorDate,
      periodIndex: periodIndex ?? this.periodIndex,
      status: status ?? this.status,
      trialEndDate: identical(trialEndDate, _keep) ? this.trialEndDate : trialEndDate as LocalDate?,
      sharedWith: sharedWith ?? this.sharedWith,
      reminderDays: identical(reminderDays, _keep) ? this.reminderDays : reminderDays as int?,
      paymentMethod: identical(paymentMethod, _keep) ? this.paymentMethod : paymentMethod as String?,
      manageUrl: identical(manageUrl, _keep) ? this.manageUrl : manageUrl as String?,
      notes: identical(notes, _keep) ? this.notes : notes as String?,
      startDate: startDate ?? this.startDate,
      cancelledOn: identical(cancelledOn, _keep) ? this.cancelledOn : cancelledOn as LocalDate?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Subscription($name, due $dueDate, $status)';
}

const Object _keep = Object();
