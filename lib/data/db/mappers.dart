import 'package:drift/drift.dart';

import '../../domain/domain.dart';
import 'app_database.dart';

T _enumByName<T extends Enum>(List<T> values, String name, T fallback) =>
    values.firstWhere((e) => e.name == name, orElse: () => fallback);

extension SubscriptionRowMapper on SubscriptionRow {
  Subscription toDomain() => Subscription(
    id: id,
    name: name,
    serviceId: serviceId,
    colorValue: colorValue,
    iconText: iconText,
    category: SubscriptionCategory.fromKey(category),
    priceMinor: priceMinor,
    currency: currency,
    cycle: BillingCycle(cycleEvery, _enumByName(CycleUnit.values, cycleUnit, CycleUnit.month)),
    anchorDate: LocalDate.parse(anchorDate),
    periodIndex: periodIndex,
    status: _enumByName(SubscriptionStatus.values, status, SubscriptionStatus.active),
    trialEndDate: LocalDate.tryParse(trialEndDate),
    sharedWith: sharedWith,
    reminderDays: reminderDays,
    paymentMethod: paymentMethod,
    manageUrl: manageUrl,
    notes: notes,
    startDate: LocalDate.parse(startDate),
    cancelledOn: LocalDate.tryParse(cancelledOn),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension SubscriptionToRow on Subscription {
  SubscriptionsCompanion toCompanion() => SubscriptionsCompanion.insert(
    id: id,
    name: name,
    serviceId: Value(serviceId),
    colorValue: colorValue,
    iconText: Value(iconText),
    category: category.key,
    priceMinor: priceMinor,
    currency: currency,
    cycleEvery: cycle.every,
    cycleUnit: cycle.unit.name,
    anchorDate: anchorDate.toString(),
    periodIndex: Value(periodIndex),
    status: status.name,
    trialEndDate: Value(trialEndDate?.toString()),
    sharedWith: Value(sharedWith),
    reminderDays: Value(reminderDays),
    paymentMethod: Value(paymentMethod),
    manageUrl: Value(manageUrl),
    notes: Value(notes),
    startDate: startDate.toString(),
    cancelledOn: Value(cancelledOn?.toString()),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

extension ConfirmedPeriodRowMapper on ConfirmedPeriodRow {
  ConfirmedPeriod toDomain() => ConfirmedPeriod(
    id: id,
    subscriptionId: subscriptionId,
    dueDate: LocalDate.parse(dueDate),
    outcome: _enumByName(PeriodOutcome.values, outcome, PeriodOutcome.payment),
    amountMinor: amountMinor,
    currency: currency,
    confirmedAt: confirmedAt,
  );
}

extension ConfirmedPeriodToRow on ConfirmedPeriod {
  ConfirmedPeriodsCompanion toCompanion() => ConfirmedPeriodsCompanion.insert(
    id: id,
    subscriptionId: subscriptionId,
    dueDate: dueDate.toString(),
    outcome: outcome.name,
    amountMinor: amountMinor,
    currency: currency,
    confirmedAt: confirmedAt,
  );
}
