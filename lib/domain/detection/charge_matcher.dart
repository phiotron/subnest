import '../billing_cycle.dart';
import '../billing_rules.dart';
import '../catalog.dart';
import '../confirmed_period.dart';
import '../local_date.dart';
import '../subscription.dart';
import 'detected_charge.dart';

/// Thresholds of a "sure" match (ADR 0003: tuning them needs no new ADR, only these tests).
abstract final class MatchThresholds {
  /// Amount may differ from the expected My share / price by this fraction (price rises, tax, FX).
  static const double amountTolerance = 0.20;

  /// Charge date window around the Due date: [Due − daysBeforeDue, Due + daysAfterDue].
  static const int daysBeforeDue = 3;
  static const int daysAfterDue = 5;

  /// An unknown (non-Catalog) payee is added only after this many charges of the same amount ~1 cycle apart.
  static const int minRepeatsForUnknown = 2;

  /// Allowed gap between repeated unknown charges, per inferred cycle (days).
  static const List<(int, int, BillingCycle)> repeatGaps = [
    (6, 8, BillingCycle.weekly()),
    (27, 33, BillingCycle.monthly()),
    (85, 95, BillingCycle.quarterly()),
    (358, 372, BillingCycle.yearly()),
  ];
}

/// Why a charge was not acted on automatically.
enum DetectionSkipReason {
  /// The user removed an Auto-detected subscription for this payee before — never re-added.
  dismissed,

  /// Matched a subscription but not surely (amount, date window, currency, several periods pending…).
  unsure,

  /// Matched a Paused/Cancelled subscription.
  notBilling,

  /// A renewal date for a subscription already tracked — nothing to do.
  alreadyTracked,
}

/// What to do with one Detected charge. Applied by `SubscriptionRepository.applyDetections`.
sealed class DetectionAction {
  const DetectionAction(this.charge);
  final DetectedCharge charge;
}

/// Confirm the current period of [subscription] with the charged amount (Undo-able).
class AutoConfirmAction extends DetectionAction {
  const AutoConfirmAction(super.charge, this.subscription, this.result);
  final Subscription subscription;

  /// Updated subscription + the new Payment (`source` set).
  final ConfirmResult result;
}

/// Add a new Auto-detected [subscription] (+ its first Payment when the charge was a past charge).
class AutoAddAction extends DetectionAction {
  const AutoAddAction(super.charge, this.subscription, {this.payment, this.consumedChargeIds = const []});
  final Subscription subscription;
  final ConfirmedPeriod? payment;

  /// Stored unmatched charges used as evidence (deleted when applied).
  final List<String> consumedChargeIds;
}

/// Leave to the user (ADR 0001 flow). [candidate] is the subscription it probably belongs to.
class SkipAction extends DetectionAction {
  const SkipAction(super.charge, this.reason, {this.candidate});
  final DetectionSkipReason reason;
  final Subscription? candidate;
}

/// Unknown payee seen once: store it until a repeat shows it is a subscription.
class KeepUnmatchedAction extends DetectionAction {
  const KeepUnmatchedAction(super.charge);
}

/// Keys of the "removed, never re-add" list.
abstract final class DismissKey {
  static String service(String serviceId) => 'service:$serviceId';
  static String name(String readName) => 'name:${ChargeMatcher.normalizeName(readName)}';

  /// Key for a subscription the user removed (service when from Catalog, else name).
  static String of(Subscription s) => s.serviceId != null ? service(s.serviceId!) : name(s.name);
}

/// Pure matching rules of ADR 0003. No clock, no storage: pass `today`, `now`, ids.
class ChargeMatcher {
  const ChargeMatcher({required this.catalog, required this.region});

  final List<CatalogService> catalog;

  /// Catalog price region (`US` / `VN`) used to pick the plan of an added subscription.
  final String region;

  /// Lower-case, no accents, punctuation → spaces, single spaces ("NETFLIX.COM" → "netflix com").
  static String normalizeName(String s) =>
      normalizeForSearch(s).replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();

  static bool _containsWords(String haystack, String needle) =>
      needle.isNotEmpty && ' $haystack '.contains(' $needle ');

  /// Catalog service whose name / store names (as words) or aliases (exactly) match [readName].
  CatalogService? matchService(String readName) {
    final n = normalizeName(readName);
    if (n.isEmpty) return null;
    CatalogService? best;
    var bestLen = 0;
    for (final s in catalog) {
      for (final c in [s.name, ...s.storeNames]) {
        final cn = normalizeName(c);
        if (cn.length >= 2 && (_containsWords(n, cn) || n.replaceAll(' ', '') == cn.replaceAll(' ', '')) &&
            cn.length > bestLen) {
          best = s;
          bestLen = cn.length;
        }
      }
      for (final a in s.aliases) {
        final an = normalizeName(a);
        if (an.length >= 3 && an == n && an.length > bestLen) {
          best = s;
          bestLen = an.length;
        }
      }
    }
    return best;
  }

  /// Subscription the charge belongs to: same Catalog service first, else by name.
  Subscription? matchSubscription(DetectedCharge c, Iterable<Subscription> subs, CatalogService? service) {
    if (service != null) {
      for (final s in subs) {
        if (s.serviceId == service.id) return s;
      }
    }
    final n = normalizeName(c.name);
    for (final s in subs) {
      final sn = normalizeName(s.name);
      if (sn.length >= 3 && (sn == n || _containsWords(n, sn) || _containsWords(sn, n))) return s;
    }
    return null;
  }

  static bool _amountClose(int actual, int expected) {
    if (expected <= 0) return false;
    return (actual - expected).abs() <= expected * MatchThresholds.amountTolerance;
  }

  /// "Sure" match of a past charge with the current Billing period of [s] (ADR 0003 §2).
  static bool isSureMatch(Subscription s, DetectedCharge c, LocalDate today) {
    if (c.isRenewal || c.date.isAfter(today)) return false;
    if (!BillingRules.hasSchedule(BillingRules.effectiveStatus(s, today))) return false;
    if (c.currency.toUpperCase() != s.currency.toUpperCase()) return false;
    if (!_amountClose(c.amountMinor, s.myShareMinor) && !_amountClose(c.amountMinor, s.priceMinor)) return false;
    final due = s.dueDate;
    if (c.date.isBefore(due.addDays(-MatchThresholds.daysBeforeDue))) return false;
    if (c.date.isAfter(due.addDays(MatchThresholds.daysAfterDue))) return false;
    // A backlog of several pending periods: the charge may belong to a later one → let the user decide.
    if (BillingRules.pendingDueDates(s, today).length > 1) return false;
    return true;
  }

  /// Decides an action per charge, in order. Earlier actions are visible to later charges
  /// (two charges of one batch never confirm the same period).
  List<DetectionAction> match(
    List<DetectedCharge> charges, {
    required List<Subscription> subscriptions,
    List<DetectedCharge> unmatched = const [],
    Set<String> dismissed = const {},
    required LocalDate today,
    required DateTime now,
    required String Function() newId,
  }) {
    final subs = [...subscriptions];
    final pool = [...unmatched];
    final out = <DetectionAction>[];
    for (final c in charges) {
      final service = matchService(c.name);
      final sub = matchSubscription(c, subs, service);
      if (sub != null) {
        final status = BillingRules.effectiveStatus(sub, today);
        if (!BillingRules.hasSchedule(status)) {
          out.add(SkipAction(c, DetectionSkipReason.notBilling, candidate: sub));
        } else if (c.isRenewal) {
          out.add(SkipAction(c, DetectionSkipReason.alreadyTracked, candidate: sub));
        } else if (isSureMatch(sub, c, today)) {
          final r = BillingRules.confirmDetected(
            sub,
            amountMinor: c.amountMinor,
            source: c.source,
            today: today,
            now: now,
            newId: newId,
          );
          subs[subs.indexOf(sub)] = r.subscription;
          out.add(AutoConfirmAction(c, sub, r));
        } else {
          out.add(SkipAction(c, DetectionSkipReason.unsure, candidate: sub));
        }
        continue;
      }

      if (service != null) {
        if (dismissed.contains(DismissKey.service(service.id))) {
          out.add(SkipAction(c, DetectionSkipReason.dismissed));
          continue;
        }
        final add = _addFromCatalog(c, service, now: now, newId: newId);
        subs.add(add.subscription);
        out.add(add);
        continue;
      }

      if (dismissed.contains(DismissKey.name(c.name))) {
        out.add(SkipAction(c, DetectionSkipReason.dismissed));
        continue;
      }
      final repeat = _repeatOf(c, pool);
      if (repeat != null) {
        final add = _addUnknown(c, repeat.$1, repeat.$2, now: now, newId: newId);
        pool.removeWhere((p) => identical(p, repeat.$1));
        subs.add(add.subscription);
        out.add(add);
      } else if (!c.isRenewal) {
        pool.add(c);
        out.add(KeepUnmatchedAction(c));
      } else {
        out.add(SkipAction(c, DetectionSkipReason.unsure));
      }
    }
    return out;
  }

  /// Earlier charge of the same payee and amount about one cycle apart → (that charge, cycle).
  (DetectedCharge, BillingCycle)? _repeatOf(DetectedCharge c, List<DetectedCharge> pool) {
    if (c.isRenewal) return null;
    final n = normalizeName(c.name);
    for (final p in pool) {
      if (p.isRenewal || normalizeName(p.name) != n) continue;
      if (p.amountMinor != c.amountMinor || p.currency.toUpperCase() != c.currency.toUpperCase()) continue;
      final gap = p.date.daysUntil(c.date).abs();
      for (final (lo, hi, cycle) in MatchThresholds.repeatGaps) {
        if (gap >= lo && gap <= hi) return (p, cycle);
      }
    }
    return null;
  }

  AutoAddAction _addFromCatalog(
    DetectedCharge c,
    CatalogService service, {
    required DateTime now,
    required String Function() newId,
  }) {
    final plans = service.plans.where((p) => p.status == CatalogPlanStatus.active).toList();
    final candidates = plans.isEmpty ? service.plans : plans;
    CatalogPlan plan = candidates.first;
    int? bestDiff;
    for (final p in candidates) {
      if (c.cycle != null && p.cycle != c.cycle) continue;
      final price = p.priceFor(region);
      if (price == null || price.currency != c.currency.toUpperCase()) continue;
      final diff = (price.minor - c.amountMinor).abs();
      if (bestDiff == null || diff < bestDiff) {
        bestDiff = diff;
        plan = p;
      }
    }
    final cycle = c.cycle ?? plan.cycle;
    final name = service.plans.length > 1 ? '${service.name} ${plan.name}' : service.name;
    return _build(
      c,
      name: name,
      cycle: cycle,
      now: now,
      newId: newId,
      serviceId: service.id,
      colorValue: service.colorValue,
      iconText: service.monogram,
      categoryId: service.category.key,
      manageUrl: service.cancelUrl ?? service.manageUrl,
    );
  }

  AutoAddAction _addUnknown(
    DetectedCharge c,
    DetectedCharge earlier,
    BillingCycle cycle, {
    required DateTime now,
    required String Function() newId,
  }) {
    final latest = earlier.date.isAfter(c.date) ? earlier : c;
    final add = _build(latest, name: _prettyName(c.name), cycle: c.cycle ?? cycle, now: now, newId: newId);
    return AutoAddAction(
      c,
      add.subscription,
      payment: add.payment,
      consumedChargeIds: [if (earlier.id != null) earlier.id!],
    );
  }

  AutoAddAction _build(
    DetectedCharge c, {
    required String name,
    required BillingCycle cycle,
    required DateTime now,
    required String Function() newId,
    String? serviceId,
    int colorValue = 0xFF607D8B,
    String? iconText,
    String categoryId = 'other',
    String? manageUrl,
  }) {
    final id = newId();
    final sub = Subscription(
      id: id,
      name: name,
      serviceId: serviceId,
      colorValue: colorValue,
      iconText: iconText,
      categoryId: categoryId,
      priceMinor: c.amountMinor,
      currency: c.currency.toUpperCase(),
      cycle: cycle,
      anchorDate: c.date,
      periodIndex: c.isRenewal ? 0 : 1,
      manageUrl: manageUrl,
      startDate: c.date,
      createdAt: now,
      updatedAt: now,
      detectionSource: c.source,
      detectedAt: now,
    );
    final payment = c.isRenewal
        ? null
        : ConfirmedPeriod(
            id: newId(),
            subscriptionId: id,
            dueDate: c.date,
            outcome: PeriodOutcome.payment,
            amountMinor: c.amountMinor,
            currency: c.currency.toUpperCase(),
            confirmedAt: now,
            source: c.source,
          );
    return AutoAddAction(c, sub, payment: payment);
  }

  /// "NETFLIX.COM" → "Netflix.com"; keeps mixed-case names as read.
  static String _prettyName(String s) {
    final t = s.trim();
    if (t.isEmpty || t != t.toUpperCase()) return t;
    final lower = t.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }
}
