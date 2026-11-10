import '../../domain/domain.dart';

/// JSON (de)serialisation for backups. Field names are part of the backup format —
/// never rename; add new optional fields and bump [BackupCodec.version] if needed.
///
/// v2 (1.0 expansion): `categoryId`, `labelIds`, `paymentMethodId`, `reminderOffsets`, `pausedFrom`,
/// `worthIt`, `detectionSource`, `detectedAt` on subscriptions; `source` on periods; top-level
/// `categories`, `labels`, `paymentMethods`, `budgets`, `dismissedDetections`. v1 fields are still
/// written (`category`, `paymentMethod` name, `reminderDays`) and v1 files restore unchanged.
///
/// v3 (auto backup): same fields; the top-level `checksum` (SHA-256 of the data part) is added by
/// [BackupService]. v1/v2 files without a checksum still restore unchanged.
abstract final class BackupCodec {
  static const format = 'subnest-backup';
  static const version = 3;

  static Map<String, Object?> subscriptionToJson(Subscription s) => {
    'id': s.id,
    'name': s.name,
    'serviceId': s.serviceId,
    'color': s.colorValue,
    'iconText': s.iconText,
    'category': s.category.key,
    'categoryId': s.categoryId,
    'priceMinor': s.priceMinor,
    'currency': s.currency,
    'cycleEvery': s.cycle.every,
    'cycleUnit': s.cycle.unit.name,
    'anchorDate': s.anchorDate.toString(),
    'periodIndex': s.periodIndex,
    'status': s.status.name,
    'trialEndDate': s.trialEndDate?.toString(),
    'sharedWith': s.sharedWith,
    'reminderDays': s.reminderDays,
    'reminderOffsets': s.reminderOffsets == null ? null : (s.reminderOffsets!.toList()..sort()),
    'paymentMethodId': s.paymentMethodId,
    'paymentMethod': s.paymentMethod,
    'labelIds': (s.labelIds.toList()..sort()),
    'pausedFrom': s.pausedFrom?.toString(),
    'worthIt': s.worthIt?.name,
    'detectionSource': s.detectionSource?.name,
    'detectedAt': s.detectedAt?.toUtc().toIso8601String(),
    'manageUrl': s.manageUrl,
    'notes': s.notes,
    'startDate': s.startDate.toString(),
    'cancelledOn': s.cancelledOn?.toString(),
    'createdAt': s.createdAt.toUtc().toIso8601String(),
    'updatedAt': s.updatedAt.toUtc().toIso8601String(),
  };

  static Subscription subscriptionFromJson(Map<String, Object?> j) {
    T req<T>(String k) {
      final v = j[k];
      if (v is! T) throw FormatException('Subscription field "$k" missing or invalid');
      return v;
    }

    final every = req<int>('cycleEvery');
    final sharedWith = (j['sharedWith'] as int?) ?? 1;
    if (every < 1 || sharedWith < 1) throw const FormatException('Invalid cycle or sharedWith');
    return Subscription(
      id: req<String>('id'),
      name: req<String>('name'),
      serviceId: j['serviceId'] as String?,
      colorValue: (j['color'] as int?) ?? 0xFF607D8B,
      iconText: j['iconText'] as String?,
      categoryId: (j['categoryId'] as String?) ?? SubscriptionCategory.fromKey(j['category'] as String?).key,
      priceMinor: req<int>('priceMinor'),
      currency: req<String>('currency').toUpperCase(),
      cycle: BillingCycle(
        every,
        CycleUnit.values.firstWhere((u) => u.name == j['cycleUnit'], orElse: () => CycleUnit.month),
      ),
      anchorDate: LocalDate.parse(req<String>('anchorDate')),
      periodIndex: (j['periodIndex'] as int?) ?? 0,
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == j['status'],
        orElse: () => SubscriptionStatus.active,
      ),
      trialEndDate: LocalDate.tryParse(j['trialEndDate'] as String?),
      sharedWith: sharedWith,
      reminderOffsets: j['reminderOffsets'] is List
          ? {for (final v in j['reminderOffsets'] as List) if (v is int && v >= 0) v}
          : ReminderOffsets.fromLegacyDays(j['reminderDays'] as int?),
      paymentMethodId: j['paymentMethodId'] as String?,
      paymentMethod: j['paymentMethod'] as String?,
      labelIds: {for (final v in (j['labelIds'] as List? ?? const [])) if (v is String) v},
      pausedFrom: LocalDate.tryParse(j['pausedFrom'] as String?),
      worthIt: WorthIt.values.where((e) => e.name == j['worthIt']).firstOrNull,
      detectionSource: DetectionSource.tryName(j['detectionSource'] as String?),
      detectedAt: j['detectedAt'] is String ? DateTime.tryParse(j['detectedAt'] as String)?.toLocal() : null,
      manageUrl: j['manageUrl'] as String?,
      notes: j['notes'] as String?,
      startDate: LocalDate.parse(req<String>('startDate')),
      cancelledOn: LocalDate.tryParse(j['cancelledOn'] as String?),
      createdAt: DateTime.parse(req<String>('createdAt')).toLocal(),
      updatedAt: DateTime.parse(req<String>('updatedAt')).toLocal(),
    );
  }

  static Map<String, Object?> periodToJson(ConfirmedPeriod p) => {
    'id': p.id,
    'subscriptionId': p.subscriptionId,
    'dueDate': p.dueDate.toString(),
    'outcome': p.outcome.name,
    'amountMinor': p.amountMinor,
    'currency': p.currency,
    'confirmedAt': p.confirmedAt.toUtc().toIso8601String(),
    'source': p.source?.name,
  };

  static ConfirmedPeriod periodFromJson(Map<String, Object?> j) {
    final outcome = PeriodOutcome.values.where((e) => e.name == j['outcome']).firstOrNull;
    if (outcome == null) throw const FormatException('Period outcome invalid');
    return ConfirmedPeriod(
      id: j['id'] as String,
      subscriptionId: j['subscriptionId'] as String,
      dueDate: LocalDate.parse(j['dueDate'] as String),
      outcome: outcome,
      amountMinor: j['amountMinor'] as int,
      currency: (j['currency'] as String).toUpperCase(),
      confirmedAt: DateTime.parse(j['confirmedAt'] as String).toLocal(),
      source: DetectionSource.tryName(j['source'] as String?),
    );
  }

  static Map<String, Object?> categoryToJson(Category c) => {
    'id': c.id,
    'name': c.name,
    'color': c.colorValue,
    'icon': c.icon,
    'sortOrder': c.sortOrder,
    'builtInKey': c.builtInKey,
  };

  static Category categoryFromJson(Map<String, Object?> j) => Category(
    id: j['id'] as String,
    name: j['name'] as String?,
    colorValue: (j['color'] as int?) ?? 0xFF8B8D98,
    icon: j['icon'] as String?,
    sortOrder: (j['sortOrder'] as int?) ?? 0,
    builtInKey: j['builtInKey'] as String?,
  );

  static Map<String, Object?> labelToJson(Label l) => {
    'id': l.id,
    'name': l.name,
    'color': l.colorValue,
    'sortOrder': l.sortOrder,
  };

  static Label labelFromJson(Map<String, Object?> j) => Label(
    id: j['id'] as String,
    name: j['name'] as String,
    colorValue: j['color'] as int?,
    sortOrder: (j['sortOrder'] as int?) ?? 0,
  );

  static Map<String, Object?> paymentMethodToJson(PaymentMethod p) => {
    'id': p.id,
    'name': p.name,
    'sortOrder': p.sortOrder,
  };

  static PaymentMethod paymentMethodFromJson(Map<String, Object?> j) =>
      PaymentMethod(id: j['id'] as String, name: j['name'] as String, sortOrder: (j['sortOrder'] as int?) ?? 0);

  static Map<String, Object?> budgetToJson(Budget b) => {
    'id': b.id,
    'categoryId': b.categoryId,
    'amountMinor': b.amountMinor,
    'currency': b.currency,
  };

  static Budget budgetFromJson(Map<String, Object?> j) => Budget(
    id: j['id'] as String,
    categoryId: j['categoryId'] as String?,
    amountMinor: j['amountMinor'] as int,
    currency: (j['currency'] as String).toUpperCase(),
  );
}
