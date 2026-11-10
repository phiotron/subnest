import 'package:collection/collection.dart';

import 'confirmed_period.dart';
import 'local_date.dart';
import 'subscription.dart';

/// Where a [PriceChange] came from (glossary: Price history).
enum PriceChangeSource {
  /// The user edited the price in the form ("You changed it").
  manual,

  /// The user accepted a Price change notice from the Catalog ("Library update").
  catalog,

  /// Inferred from the amounts of past Payments for data recorded before price history existed
  /// ("From paid periods") — see [PriceHistory.backfill].
  backfill;

  static PriceChangeSource fromName(String? name) =>
      values.firstWhereOrNull((e) => e.name == name) ?? PriceChangeSource.manual;
}

/// One change of a Subscription's plan price (full price for one Billing period, not My share).
///
/// Payments already made never change; the new price applies from [effectiveFrom] on.
class PriceChange {
  const PriceChange({
    required this.id,
    required this.subscriptionId,
    required this.oldPriceMinor,
    required this.newPriceMinor,
    required this.currency,
    this.oldCurrency,
    required this.effectiveFrom,
    required this.source,
    required this.createdAt,
  });

  final String id;
  final String subscriptionId;

  /// Plan price before the change, minor units of [fromCurrency].
  final int oldPriceMinor;

  /// Plan price from [effectiveFrom] on, minor units of [currency].
  final int newPriceMinor;

  /// Currency of [newPriceMinor].
  final String currency;

  /// Currency of [oldPriceMinor] when the currency changed too; `null` = same as [currency].
  final String? oldCurrency;

  /// First day the new price applies (usually the Due date of the next Billing period).
  final LocalDate effectiveFrom;
  final PriceChangeSource source;
  final DateTime createdAt;

  String get fromCurrency => oldCurrency ?? currency;

  bool get currencyChanged => oldCurrency != null && oldCurrency != currency;

  /// Up or down in the same currency; `null` when the currency changed (compare converted amounts).
  bool? get isIncrease => currencyChanged ? null : newPriceMinor > oldPriceMinor;

  /// Day the user learned about the change, for "increased in the last 90 days": a change the user
  /// typed today that starts next period counts from today; a backfilled one from its effective date.
  LocalDate get noticedOn {
    if (source == PriceChangeSource.backfill) return effectiveFrom;
    final created = LocalDate.fromDateTime(createdAt);
    return created.isBefore(effectiveFrom) ? created : effectiveFrom;
  }

  PriceChange copyWith({int? newPriceMinor, String? currency, Object? oldCurrency = _keep, DateTime? createdAt}) =>
      PriceChange(
        id: id,
        subscriptionId: subscriptionId,
        oldPriceMinor: oldPriceMinor,
        newPriceMinor: newPriceMinor ?? this.newPriceMinor,
        currency: currency ?? this.currency,
        oldCurrency: identical(oldCurrency, _keep) ? this.oldCurrency : oldCurrency as String?,
        effectiveFrom: effectiveFrom,
        source: source,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      other is PriceChange &&
      other.id == id &&
      other.subscriptionId == subscriptionId &&
      other.oldPriceMinor == oldPriceMinor &&
      other.newPriceMinor == newPriceMinor &&
      other.currency == currency &&
      other.oldCurrency == oldCurrency &&
      other.effectiveFrom == effectiveFrom &&
      other.source == source;

  @override
  int get hashCode => Object.hash(id, subscriptionId, oldPriceMinor, newPriceMinor, currency, effectiveFrom);

  @override
  String toString() =>
      'PriceChange($subscriptionId $effectiveFrom $oldPriceMinor $fromCurrency → $newPriceMinor $currency ${source.name})';
}

/// A plan price in its currency (minor units).
typedef PlanPrice = ({int priceMinor, String currency});

/// Price history of every Subscription, each list oldest first. Pure.
class PriceHistory {
  PriceHistory(Iterable<PriceChange> changes) : _bySub = _group(changes);

  static const PriceHistory empty = PriceHistory._(<String, List<PriceChange>>{});

  const PriceHistory._(this._bySub);

  final Map<String, List<PriceChange>> _bySub;

  static Map<String, List<PriceChange>> _group(Iterable<PriceChange> changes) {
    final out = <String, List<PriceChange>>{};
    for (final c in changes) {
      out.putIfAbsent(c.subscriptionId, () => []).add(c);
    }
    for (final l in out.values) {
      l.sort(_order);
    }
    return out;
  }

  static int _order(PriceChange a, PriceChange b) {
    final d = a.effectiveFrom.compareTo(b.effectiveFrom);
    return d != 0 ? d : a.createdAt.compareTo(b.createdAt);
  }

  /// Changes of [subscriptionId], oldest first.
  List<PriceChange> of(String subscriptionId) => _bySub[subscriptionId] ?? const [];

  bool get isEmpty => _bySub.isEmpty;

  /// Plan price of [s] in effect on [date]: the newest change effective on/before [date]; before the
  /// first change, that change's old price; with no history (or after the last change) the current
  /// price of [s] when its currency matches the last change, so editing the subscription without a
  /// recorded change never shows a stale price for today.
  PlanPrice priceAt(Subscription s, LocalDate date) {
    final list = of(s.id);
    if (list.isEmpty) return (priceMinor: s.priceMinor, currency: s.currency);
    if (date.isBefore(list.first.effectiveFrom)) {
      return (priceMinor: list.first.oldPriceMinor, currency: list.first.fromCurrency);
    }
    final last = list.lastWhere((c) => !c.effectiveFrom.isAfter(date));
    if (identical(last, list.last)) return (priceMinor: s.priceMinor, currency: s.currency);
    return (priceMinor: last.newPriceMinor, currency: last.currency);
  }

  /// My share of [priceAt] (rounded to the currency's minor unit, like [Subscription.myShareMinor]).
  PlanPrice myShareAt(Subscription s, LocalDate date) {
    final p = priceAt(s, date);
    final share = s.isShared ? (p.priceMinor / s.sharedWith).round() : p.priceMinor;
    return (priceMinor: share, currency: p.currency);
  }

  /// A copy of [s] priced as on [date] (for maths that read [Subscription.myShareMinor]).
  Subscription pricedAt(Subscription s, LocalDate date) {
    final p = priceAt(s, date);
    if (p.priceMinor == s.priceMinor && p.currency == s.currency) return s;
    return s.copyWith(priceMinor: p.priceMinor, currency: p.currency);
  }

  // ---- Backfill ---------------------------------------------------------------------------------

  /// Price changes inferred from the Payments of [s] (data recorded before price history existed).
  ///
  /// Rules (kept deliberately strict — a wrong "price went up" is worse than a missing one):
  /// 1. Only Payments confirmed by the user ([ConfirmedPeriod.source] `null`): an auto-confirmed
  ///    amount is what the bank charged (FX, fees), not the price.
  /// 2. Only Payments in the subscription's current currency (another currency = old rate noise).
  /// 3. Payments, oldest first, are grouped into runs of the same amount. A run of a single Payment
  ///    is an odd period (discount, pro-rata, typo) and is dropped — except the last run when it
  ///    equals the current My share (the current price confirms it).
  /// 4. Each change between consecutive kept runs (after merging runs that became neighbours with
  ///    the same amount) is one [PriceChange] effective on the Due date of the first Payment of the
  ///    new run.
  /// 5. When the last kept run differs from the current My share, the price was edited later without
  ///    a record: one more change to the current price, effective on the first Due date after that
  ///    run (the next Payment, or the current Due date when there is none).
  /// 6. Amounts are My share; for a Shared plan the plan price is `amount × sharedWith`, except an
  ///    amount equal to the current My share, which maps to the exact current price.
  /// Nothing is returned when [s] has fewer than two usable Payments and no change can be seen.
  static List<PriceChange> backfill(
    Subscription s,
    Iterable<ConfirmedPeriod> periods, {
    required DateTime now,
    required String Function() newId,
  }) {
    final paid = periods
        .where((p) => p.subscriptionId == s.id && p.isPayment && p.source == null && p.currency == s.currency)
        .sorted((a, b) => a.dueDate.compareTo(b.dueDate));
    if (paid.isEmpty) return const [];

    // 3. Runs of equal amounts.
    final runs = <({int amount, List<ConfirmedPeriod> items})>[];
    for (final p in paid) {
      if (runs.isNotEmpty && runs.last.amount == p.amountMinor) {
        runs.last.items.add(p);
      } else {
        runs.add((amount: p.amountMinor, items: [p]));
      }
    }
    final current = s.myShareMinor;
    final kept = <({int amount, List<ConfirmedPeriod> items})>[];
    for (final (i, r) in runs.indexed) {
      final isLast = i == runs.length - 1;
      if (r.items.length < 2 && !(isLast && r.amount == current)) continue;
      if (kept.isNotEmpty && kept.last.amount == r.amount) {
        kept.last.items.addAll(r.items);
      } else {
        kept.add((amount: r.amount, items: [...r.items]));
      }
    }
    if (kept.isEmpty) return const [];

    int planPrice(int amount) => amount == current ? s.priceMinor : amount * s.sharedWith;

    final out = <PriceChange>[];
    PriceChange change(int from, int to, LocalDate at) => PriceChange(
      id: newId(),
      subscriptionId: s.id,
      oldPriceMinor: planPrice(from),
      newPriceMinor: planPrice(to),
      currency: s.currency,
      effectiveFrom: at,
      source: PriceChangeSource.backfill,
      createdAt: now,
    );
    for (var i = 1; i < kept.length; i++) {
      out.add(change(kept[i - 1].amount, kept[i].amount, kept[i].items.first.dueDate));
    }
    // 5. Edited later without a record.
    final lastRun = kept.last;
    if (lastRun.amount != current) {
      final lastDue = lastRun.items.last.dueDate;
      final after = paid.firstWhereOrNull((p) => p.dueDate.isAfter(lastDue))?.dueDate;
      final at = after ?? (s.dueDate.isAfter(lastDue) ? s.dueDate : lastDue.addDays(1));
      out.add(change(lastRun.amount, current, at));
    }
    return out;
  }
}

const Object _keep = Object();
