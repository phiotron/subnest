import 'package:drift/drift.dart';

import '../../domain/domain.dart';
import 'app_database.dart';

T _enumByName<T extends Enum>(List<T> values, String name, T fallback) =>
    values.firstWhere((e) => e.name == name, orElse: () => fallback);

T? _enumOrNull<T extends Enum>(List<T> values, String? name) =>
    name == null ? null : values.where((e) => e.name == name).firstOrNull;

extension SubscriptionRowMapper on SubscriptionRow {
  /// [labelIds] and [paymentMethodName] come from the join tables (see SubscriptionRepository).
  Subscription toDomain({Set<String> labelIds = const {}, String? paymentMethodName}) => Subscription(
    id: id,
    name: name,
    serviceId: serviceId,
    colorValue: colorValue,
    iconText: iconText,
    categoryId: categoryId,
    priceMinor: priceMinor,
    currency: currency,
    cycle: BillingCycle(cycleEvery, _enumByName(CycleUnit.values, cycleUnit, CycleUnit.month)),
    anchorDate: LocalDate.parse(anchorDate),
    periodIndex: periodIndex,
    status: _enumByName(SubscriptionStatus.values, status, SubscriptionStatus.active),
    trialEndDate: LocalDate.tryParse(trialEndDate),
    sharedWith: sharedWith,
    reminderOffsets: ReminderOffsets.decode(reminderOffsets),
    paymentMethodId: paymentMethodId,
    paymentMethod: paymentMethodName,
    manageUrl: manageUrl,
    notes: notes,
    startDate: LocalDate.parse(startDate),
    cancelledOn: LocalDate.tryParse(cancelledOn),
    pausedFrom: LocalDate.tryParse(pausedFrom),
    worthIt: _enumOrNull(WorthIt.values, worthIt),
    labelIds: labelIds,
    detectionSource: DetectionSource.tryName(detectionSource),
    detectedAt: detectedAt,
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
    categoryId: Value(categoryId),
    priceMinor: priceMinor,
    currency: currency,
    cycleEvery: cycle.every,
    cycleUnit: cycle.unit.name,
    anchorDate: anchorDate.toString(),
    periodIndex: Value(periodIndex),
    status: status.name,
    trialEndDate: Value(trialEndDate?.toString()),
    sharedWith: Value(sharedWith),
    reminderOffsets: Value(ReminderOffsets.encode(reminderOffsets)),
    paymentMethodId: Value(paymentMethodId),
    manageUrl: Value(manageUrl),
    notes: Value(notes),
    startDate: startDate.toString(),
    cancelledOn: Value(cancelledOn?.toString()),
    pausedFrom: Value(pausedFrom?.toString()),
    worthIt: Value(worthIt?.name),
    detectionSource: Value(detectionSource?.name),
    detectedAt: Value(detectedAt),
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
    source: DetectionSource.tryName(source),
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
    source: Value(source?.name),
  );
}

extension CategoryRowMapper on CategoryRow {
  Category toDomain() =>
      Category(id: id, name: name, colorValue: colorValue, icon: icon, sortOrder: sortOrder, builtInKey: builtInKey);
}

extension CategoryToRow on Category {
  CategoriesCompanion toCompanion() => CategoriesCompanion.insert(
    id: id,
    name: Value(name),
    colorValue: colorValue,
    icon: Value(icon),
    sortOrder: sortOrder,
    builtInKey: Value(builtInKey),
  );
}

extension LabelRowMapper on LabelRow {
  Label toDomain() => Label(id: id, name: name, colorValue: colorValue, sortOrder: sortOrder);
}

extension LabelToRow on Label {
  LabelsCompanion toCompanion() =>
      LabelsCompanion.insert(id: id, name: name, colorValue: Value(colorValue), sortOrder: sortOrder);
}

extension PaymentMethodRowMapper on PaymentMethodRow {
  PaymentMethod toDomain() => PaymentMethod(id: id, name: name, sortOrder: sortOrder);
}

extension PaymentMethodToRow on PaymentMethod {
  PaymentMethodsCompanion toCompanion() => PaymentMethodsCompanion.insert(id: id, name: name, sortOrder: sortOrder);
}

extension BudgetRowMapper on BudgetRow {
  Budget toDomain() => Budget(id: id, categoryId: categoryId, amountMinor: amountMinor, currency: currency);
}

extension BudgetToRow on Budget {
  BudgetsCompanion toCompanion() =>
      BudgetsCompanion.insert(id: id, categoryId: Value(categoryId), amountMinor: amountMinor, currency: currency);
}

extension DetectedChargeRowMapper on DetectedChargeRow {
  DetectedCharge toDomain() => DetectedCharge(
    id: id,
    name: name,
    amountMinor: amountMinor,
    currency: currency,
    date: LocalDate.parse(date),
    source: DetectionSource.tryName(source) ?? DetectionSource.scan,
    cycle: cycleEvery == null || cycleUnit == null
        ? null
        : BillingCycle(cycleEvery!, _enumByName(CycleUnit.values, cycleUnit!, CycleUnit.month)),
    isRenewal: isRenewal,
  );
}

extension DetectedChargeToRow on DetectedCharge {
  DetectedChargesCompanion toCompanion(String id, DateTime now) => DetectedChargesCompanion.insert(
    id: id,
    name: name,
    amountMinor: amountMinor,
    currency: currency.toUpperCase(),
    date: date.toString(),
    source: source.name,
    cycleEvery: Value(cycle?.every),
    cycleUnit: Value(cycle?.unit.name),
    isRenewal: Value(isRenewal),
    createdAt: now,
  );
}
