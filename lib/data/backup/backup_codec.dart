import '../../domain/domain.dart';

/// JSON (de)serialisation for backups. Field names are part of the backup format —
/// never rename; add new optional fields and bump [BackupCodec.version] if needed.
abstract final class BackupCodec {
  static const format = 'subnest-backup';
  static const version = 1;

  static Map<String, Object?> subscriptionToJson(Subscription s) => {
    'id': s.id,
    'name': s.name,
    'serviceId': s.serviceId,
    'color': s.colorValue,
    'iconText': s.iconText,
    'category': s.category.key,
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
    'paymentMethod': s.paymentMethod,
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
      category: SubscriptionCategory.fromKey(j['category'] as String?),
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
      reminderDays: j['reminderDays'] as int?,
      paymentMethod: j['paymentMethod'] as String?,
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
    );
  }
}
