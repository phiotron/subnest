import 'billing_cycle.dart';
import 'category.dart';
import 'detection/detection_source.dart';
import 'local_date.dart';
import 'money.dart';

/// Stored status of a Subscription. Use `BillingRules.effectiveStatus`
/// for display: a Trial whose end date has arrived is already `active`.
///
/// `paused` (glossary: Paused): no Due date waits, no Reminder, not in totals. See [Subscription.pausedFrom].
enum SubscriptionStatus { trial, active, paused, cancelled }

/// Worth-it rating ("Đáng tiền?"). `null` on a Subscription = not rated yet.
enum WorthIt { worth, unsure, notWorth }

/// Legacy single-choice reminder setting ("N days before", off, on the day).
///
/// Kept for screens not yet moved to [ReminderOffsets]: `Subscription.reminderDays` and the
/// `reminderDays:` constructor/copyWith arguments convert to/from offset sets.
abstract final class ReminderDays {
  static const int off = -1;
  static const int onTheDay = 0;

  /// Choices offered in the old UI (product.md §3.11).
  static const List<int> choices = [off, onTheDay, 1, 3, 7];
}

/// Multi-point reminders (product.md §10.3): a set of "days before the Due date".
/// `0` = on the day. An empty set = reminders off. On a Subscription `null` = Settings default.
abstract final class ReminderOffsets {
  /// Offsets the UI offers, each toggled on its own.
  static const List<int> choices = [0, 1, 3, 7];

  /// Default for new installs (= old default "3 days before" + the due-day notice).
  static const Set<int> defaults = {0, 3};

  /// Old single value → set. The old planner always added the due-day notice unless off.
  static Set<int>? fromLegacyDays(int? days) {
    if (days == null) return null;
    if (days == ReminderDays.off) return const {};
    if (days <= 0) return const {0};
    return {0, days};
  }

  /// Set → closest old single value (largest offset; off when empty).
  static int? toLegacyDays(Set<int>? offsets) {
    if (offsets == null) return null;
    if (offsets.isEmpty) return ReminderDays.off;
    return offsets.reduce((a, b) => a > b ? a : b);
  }

  /// Storage text "0,3,7" (sorted); `''` = off. `null` stays `null`.
  static String? encode(Set<int>? offsets) => offsets == null ? null : (offsets.toList()..sort()).join(',');

  static Set<int>? decode(String? text) {
    if (text == null) return null;
    return {
      for (final p in text.split(','))
        if (int.tryParse(p.trim()) case final v? when v >= 0) v,
    };
  }
}

/// A recurring payment the user tracks (glossary: Subscription).
///
/// The current Due date is derived: `cycle.occurrence(anchorDate, periodIndex)`.
/// Confirming a Billing period increments [periodIndex]; editing the due date or
/// the cycle re-anchors (`anchorDate = new due date`, `periodIndex = 0`).
class Subscription {
  Subscription({
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
    String? categoryId,
    SubscriptionCategory? category,
    this.trialEndDate,
    this.sharedWith = 1,
    Set<int>? reminderOffsets,
    int? reminderDays,
    this.paymentMethodId,
    this.paymentMethod,
    this.manageUrl,
    this.notes,
    this.cancelledOn,
    this.pausedFrom,
    this.worthIt,
    this.labelIds = const {},
    this.detectionSource,
    this.detectedAt,
  }) : categoryId = categoryId ?? (category ?? SubscriptionCategory.other).key,
       reminderOffsets = reminderOffsets ?? ReminderOffsets.fromLegacyDays(reminderDays),
       assert(sharedWith >= 1),
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

  /// Id of the user's [Category]. Built-in categories use their key as id (`video`, `music`…).
  final String categoryId;

  /// Built-in view of [categoryId] (custom categories → [SubscriptionCategory.other]).
  /// Legacy: new UI should resolve [categoryId] against the categories list instead.
  SubscriptionCategory get category => SubscriptionCategory.fromKey(categoryId);

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

  /// Reminder offsets (days before the Due date, see [ReminderOffsets]); `null` = Settings default.
  final Set<int>? reminderOffsets;

  /// Legacy single value of [reminderOffsets] (see [ReminderDays]).
  int? get reminderDays => ReminderOffsets.toLegacyDays(reminderOffsets);

  /// Id of the user's Payment method, `null` = none.
  final String? paymentMethodId;

  /// Display name of the Payment method — filled by the repository when reading.
  /// When saving with [paymentMethodId] `null` and a name here, the repository finds or creates the method.
  final String? paymentMethod;

  /// "How to cancel / manage" link.
  final String? manageUrl;
  final String? notes;

  /// "Started on" shown in details.
  final LocalDate startDate;
  final LocalDate? cancelledOn;

  /// Paused: the Due date that would have come next when the user paused ("Paused from 15/11").
  final LocalDate? pausedFrom;

  final WorthIt? worthIt;

  /// Ids of the user's Labels (many per subscription).
  final Set<String> labelIds;

  /// Set when the app added this Subscription itself (glossary: Auto-detected); `null` = added by hand.
  final DetectionSource? detectionSource;
  final DateTime? detectedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAutoDetected => detectionSource != null;

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
    String? categoryId,
    SubscriptionCategory? category,
    int? priceMinor,
    String? currency,
    BillingCycle? cycle,
    LocalDate? anchorDate,
    int? periodIndex,
    SubscriptionStatus? status,
    Object? trialEndDate = _keep,
    int? sharedWith,
    Object? reminderOffsets = _keep,
    Object? reminderDays = _keep,
    Object? paymentMethodId = _keep,
    Object? paymentMethod = _keep,
    Object? manageUrl = _keep,
    Object? notes = _keep,
    LocalDate? startDate,
    Object? cancelledOn = _keep,
    Object? pausedFrom = _keep,
    Object? worthIt = _keep,
    Set<String>? labelIds,
    Object? detectionSource = _keep,
    Object? detectedAt = _keep,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final Set<int>? offsets = !identical(reminderOffsets, _keep)
        ? reminderOffsets as Set<int>?
        : !identical(reminderDays, _keep)
        ? ReminderOffsets.fromLegacyDays(reminderDays as int?)
        : this.reminderOffsets;
    return Subscription(
      id: id,
      name: name ?? this.name,
      serviceId: identical(serviceId, _keep) ? this.serviceId : serviceId as String?,
      colorValue: colorValue ?? this.colorValue,
      iconText: identical(iconText, _keep) ? this.iconText : iconText as String?,
      categoryId: categoryId ?? category?.key ?? this.categoryId,
      priceMinor: priceMinor ?? this.priceMinor,
      currency: currency ?? this.currency,
      cycle: cycle ?? this.cycle,
      anchorDate: anchorDate ?? this.anchorDate,
      periodIndex: periodIndex ?? this.periodIndex,
      status: status ?? this.status,
      trialEndDate: identical(trialEndDate, _keep) ? this.trialEndDate : trialEndDate as LocalDate?,
      sharedWith: sharedWith ?? this.sharedWith,
      reminderOffsets: offsets,
      paymentMethodId: identical(paymentMethodId, _keep) ? this.paymentMethodId : paymentMethodId as String?,
      paymentMethod: identical(paymentMethod, _keep) ? this.paymentMethod : paymentMethod as String?,
      manageUrl: identical(manageUrl, _keep) ? this.manageUrl : manageUrl as String?,
      notes: identical(notes, _keep) ? this.notes : notes as String?,
      startDate: startDate ?? this.startDate,
      cancelledOn: identical(cancelledOn, _keep) ? this.cancelledOn : cancelledOn as LocalDate?,
      pausedFrom: identical(pausedFrom, _keep) ? this.pausedFrom : pausedFrom as LocalDate?,
      worthIt: identical(worthIt, _keep) ? this.worthIt : worthIt as WorthIt?,
      labelIds: labelIds ?? this.labelIds,
      detectionSource: identical(detectionSource, _keep) ? this.detectionSource : detectionSource as DetectionSource?,
      detectedAt: identical(detectedAt, _keep) ? this.detectedAt : detectedAt as DateTime?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Subscription($name, due $dueDate, $status)';
}

const Object _keep = Object();
