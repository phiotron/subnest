import 'billing_cycle.dart';
import 'billing_rules.dart';
import 'category.dart';
import 'local_date.dart';
import 'subscription.dart';

enum DraftError { nameEmpty, priceNotPositive, trialEndInPast }

/// Mutable form state for S4 (add / edit). Holds the rules for turning form input into a
/// Subscription so every UI version of the form behaves the same.
class SubscriptionDraft {
  SubscriptionDraft({
    required this.name,
    required this.priceMinor,
    required this.currency,
    required this.cycle,
    required this.dueDate,
    this.trial = false,
    this.trialEnd,
    this.sharedWith = 1,
    this.category = SubscriptionCategory.other,
    this.reminderDays,
    this.paymentMethod,
    this.manageUrl,
    this.notes,
    this.serviceId,
    this.colorValue = 0xFF607D8B,
    this.iconText,
  });

  factory SubscriptionDraft.blank({required String currency, required LocalDate today, String name = ''}) =>
      SubscriptionDraft(
        name: name,
        priceMinor: 0,
        currency: currency,
        cycle: const BillingCycle.monthly(),
        dueDate: const BillingCycle.monthly().occurrence(today, 1),
      );

  /// Form state for editing [s]. A Trial whose end date has passed is edited as Active.
  factory SubscriptionDraft.fromSubscription(Subscription s, LocalDate today) => SubscriptionDraft(
    name: s.name,
    priceMinor: s.priceMinor,
    currency: s.currency,
    cycle: s.cycle,
    dueDate: s.dueDate,
    trial: BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial,
    trialEnd: s.trialEndDate,
    sharedWith: s.sharedWith,
    category: s.category,
    reminderDays: s.reminderDays,
    paymentMethod: s.paymentMethod,
    manageUrl: s.manageUrl,
    notes: s.notes,
    serviceId: s.serviceId,
    colorValue: s.colorValue,
    iconText: s.iconText,
  );

  String name;
  int priceMinor;
  String currency;
  BillingCycle cycle;

  /// Next Due date (ignored while [trial] is on: the trial end is the first Due date).
  LocalDate dueDate;
  bool trial;
  LocalDate? trialEnd;
  int sharedWith;
  SubscriptionCategory category;
  int? reminderDays;
  String? paymentMethod;
  String? manageUrl;
  String? notes;
  String? serviceId;
  int colorValue;
  String? iconText;

  /// My share preview ("Your share: 65.000đ").
  int get myShareMinor => sharedWith > 1 ? (priceMinor / sharedWith).round() : priceMinor;

  /// "Then: 04/12, 04/01…" preview of the next due dates.
  List<LocalDate> nextDueDates([int count = 3]) {
    final first = trial ? (trialEnd ?? dueDate) : dueDate;
    return [for (var i = 0; i < count; i++) cycle.occurrence(first, i)];
  }

  List<DraftError> validate(LocalDate today) => [
    if (name.trim().isEmpty) DraftError.nameEmpty,
    if (priceMinor <= 0) DraftError.priceNotPositive,
    if (trial && (trialEnd == null || trialEnd!.isBefore(today))) DraftError.trialEndInPast,
  ];

  static String? _clean(String? v) => (v == null || v.trim().isEmpty) ? null : v.trim();

  Subscription _fields(Subscription base, DateTime now) => base.copyWith(
    name: name.trim(),
    priceMinor: priceMinor,
    currency: currency.toUpperCase(),
    sharedWith: sharedWith < 1 ? 1 : sharedWith,
    category: category,
    reminderDays: reminderDays,
    paymentMethod: _clean(paymentMethod),
    manageUrl: _clean(manageUrl),
    notes: _clean(notes),
    serviceId: serviceId,
    colorValue: colorValue,
    iconText: _clean(iconText),
    updatedAt: now,
  );

  /// A new Subscription (call [validate] first).
  Subscription toNew({required String id, required LocalDate today, required DateTime now}) {
    var s = _fields(
      Subscription(
        id: id,
        name: name,
        priceMinor: priceMinor,
        currency: currency,
        cycle: cycle,
        anchorDate: dueDate,
        startDate: today,
        createdAt: now,
        updatedAt: now,
      ),
      now,
    );
    if (trial && trialEnd != null) s = BillingRules.startTrial(s, trialEnd!, now);
    return s;
  }

  /// Applies an edit. A changed Due date or cycle re-anchors the schedule; past Payments are
  /// untouched (a new price applies from the next unconfirmed period).
  Subscription applyTo(Subscription original, {required DateTime now}) {
    var s = _fields(original, now);
    if (original.status == SubscriptionStatus.cancelled) {
      return s.copyWith(cycle: cycle);
    }
    if (trial && trialEnd != null) {
      final changed = original.status != SubscriptionStatus.trial || original.trialEndDate != trialEnd || original.cycle != cycle;
      if (changed) s = BillingRules.startTrial(s.copyWith(cycle: cycle), trialEnd!, now);
      return s;
    }
    if (original.status == SubscriptionStatus.trial) {
      s = s.copyWith(status: SubscriptionStatus.active, trialEndDate: null);
    }
    if (cycle != original.cycle || dueDate != original.dueDate) {
      s = BillingRules.rebase(s.copyWith(cycle: cycle), dueDate, now);
    }
    return s;
  }
}
