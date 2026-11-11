import 'package:subnest/domain/domain.dart';

/// The EN / USD sample set of product.md §6 (today 10 Nov 2026) — the data every v14 mockup is
/// computed from: November ≈ $144.89 (10 subscriptions), Paid $41.99, Still to pay $74.58,
/// −$4.00 vs October, price rises +$3.50 a month (Netflix +$2.50, ChatGPT +$1.00).
abstract final class Product {
  static const today = LocalDate(2026, 11, 10);
  static final now = DateTime(2026, 11, 10, 9);
  static const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 26350});
  static const primary = 'USD';

  static Subscription _s(
    String id,
    String name,
    int priceMinor, {
    required SubscriptionCategory category,
    required LocalDate due,
    required LocalDate start,
    BillingCycle cycle = const BillingCycle.monthly(),
    SubscriptionStatus status = SubscriptionStatus.active,
    LocalDate? trialEnd,
    LocalDate? cancelledOn,
    LocalDate? pausedFrom,
    int sharedWith = 1,
    int color = 0xFF607D8B,
    WorthIt? worthIt,
  }) => Subscription(
    id: id,
    name: name,
    priceMinor: priceMinor,
    currency: 'USD',
    cycle: cycle,
    anchorDate: due,
    startDate: start,
    createdAt: now,
    updatedAt: now,
    status: status,
    category: category,
    trialEndDate: trialEnd,
    cancelledOn: cancelledOn,
    pausedFrom: pausedFrom,
    sharedWith: sharedWith,
    colorValue: color,
    worthIt: worthIt,
  );

  static final netflix = _s(
    'netflix',
    'Netflix Standard',
    1799,
    category: SubscriptionCategory.video,
    due: const LocalDate(2026, 11, 15),
    start: const LocalDate(2025, 3, 15),
    color: 0xFFE50914,
  );
  static final spotify = _s(
    'spotify',
    'Spotify Premium',
    1199,
    category: SubscriptionCategory.music,
    due: const LocalDate(2026, 11, 13),
    start: const LocalDate(2026, 10, 14),
    status: SubscriptionStatus.trial,
    trialEnd: const LocalDate(2026, 11, 13),
    color: 0xFF1DB954,
  );
  static final youtube = _s(
    'youtube',
    'YouTube Premium Family',
    2299,
    category: SubscriptionCategory.video,
    due: const LocalDate(2026, 11, 18),
    start: const LocalDate(2025, 6, 18),
    sharedWith: 5,
    color: 0xFFFF0033,
  );
  static final chatgpt = _s(
    'chatgpt',
    'ChatGPT Plus',
    2000,
    category: SubscriptionCategory.ai,
    due: const LocalDate(2026, 11, 12),
    start: const LocalDate(2025, 1, 12),
    color: 0xFF10A37F,
  );
  static final claude = _s(
    'claude',
    'Claude Pro',
    2000,
    category: SubscriptionCategory.ai,
    due: const LocalDate(2026, 11, 8),
    start: const LocalDate(2026, 6, 8),
    color: 0xFFD97757,
  );
  static final icloud = _s(
    'icloud',
    'iCloud+ 200 GB',
    299,
    category: SubscriptionCategory.storage,
    due: const LocalDate(2026, 12, 5),
    start: const LocalDate(2024, 12, 5),
    color: 0xFF3693F3,
  );
  static final gym = _s(
    'gym',
    'Gym',
    3900,
    category: SubscriptionCategory.health,
    due: const LocalDate(2026, 12, 1),
    start: const LocalDate(2026, 4, 1),
    color: 0xFF1F9D55,
    worthIt: WorthIt.notWorth,
  );
  static final disney = _s(
    'disney',
    'Disney+',
    999,
    category: SubscriptionCategory.video,
    due: const LocalDate(2026, 11, 21),
    start: const LocalDate(2025, 11, 21),
    status: SubscriptionStatus.paused,
    pausedFrom: const LocalDate(2026, 11, 21),
    color: 0xFF113CCF,
    worthIt: WorthIt.notWorth,
  );
  static final googleOne = _s(
    'googleone',
    'Google One 2 TB',
    9999,
    category: SubscriptionCategory.storage,
    due: const LocalDate(2027, 3, 20),
    start: const LocalDate(2025, 3, 20),
    cycle: const BillingCycle.yearly(),
    color: 0xFF4285F4,
  );
  static final canva = _s(
    'canva',
    'Canva Pro',
    12000,
    category: SubscriptionCategory.software,
    due: const LocalDate(2027, 2, 2),
    start: const LocalDate(2026, 2, 2),
    cycle: const BillingCycle.yearly(),
    color: 0xFF00C4CC,
  );
  static final duolingo = _s(
    'duolingo',
    'Duolingo Super',
    5999,
    category: SubscriptionCategory.education,
    due: const LocalDate(2026, 10, 12),
    start: const LocalDate(2025, 10, 12),
    cycle: const BillingCycle.yearly(),
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 10, 12),
    color: 0xFF58CC02,
  );
  static final appleMusic = _s(
    'applemusic',
    'Apple Music',
    1099,
    category: SubscriptionCategory.music,
    due: const LocalDate(2026, 10, 20),
    start: const LocalDate(2025, 10, 20),
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 10, 20),
    color: 0xFFFA243C,
  );

  static final subscriptions = [
    netflix,
    spotify,
    youtube,
    chatgpt,
    claude,
    icloud,
    gym,
    disney,
    googleOne,
    canva,
    duolingo,
    appleMusic,
  ];

  static final priceChanges = [
    PriceChange(
      id: 'pc-netflix',
      subscriptionId: 'netflix',
      oldPriceMinor: 1549,
      newPriceMinor: 1799,
      currency: 'USD',
      effectiveFrom: const LocalDate(2026, 10, 15),
      source: PriceChangeSource.manual,
      createdAt: DateTime(2026, 10, 1),
    ),
    PriceChange(
      id: 'pc-chatgpt',
      subscriptionId: 'chatgpt',
      oldPriceMinor: 1900,
      newPriceMinor: 2000,
      currency: 'USD',
      effectiveFrom: const LocalDate(2026, 3, 12),
      source: PriceChangeSource.manual,
      createdAt: DateTime(2026, 3, 1),
    ),
  ];

  static int _priceAt(Subscription s, LocalDate d) {
    var p = s.priceMinor;
    for (final c in priceChanges.where((c) => c.subscriptionId == s.id)) {
      if (d.isBefore(c.effectiveFrom)) p = c.oldPriceMinor;
    }
    return (p / s.sharedWith).round();
  }

  /// Payments for every period from the start up to (and including) [lastPaid].
  static Iterable<ConfirmedPeriod> _paid(Subscription s, LocalDate lastPaid) sync* {
    final months = s.cycle == const BillingCycle.yearly() ? 12 : 1;
    for (var d = s.startDate; !d.isAfter(lastPaid); d = d.addMonths(months)) {
      yield ConfirmedPeriod(
        id: '${s.id}-$d',
        subscriptionId: s.id,
        dueDate: d,
        outcome: PeriodOutcome.payment,
        amountMinor: _priceAt(s, d),
        currency: s.currency,
        confirmedAt: DateTime(d.year, d.month, d.day, 9),
      );
    }
  }

  static final List<ConfirmedPeriod> periods = [
    ..._paid(netflix, const LocalDate(2026, 10, 15)),
    ..._paid(youtube, const LocalDate(2026, 10, 18)),
    ..._paid(chatgpt, const LocalDate(2026, 10, 12)),
    ..._paid(claude, const LocalDate(2026, 10, 8)),
    ..._paid(icloud, const LocalDate(2026, 11, 5)),
    ..._paid(gym, const LocalDate(2026, 11, 1)),
    ..._paid(disney, const LocalDate(2026, 10, 21)),
    ..._paid(googleOne, const LocalDate(2026, 3, 20)),
    ..._paid(canva, const LocalDate(2026, 2, 2)),
    ..._paid(duolingo, const LocalDate(2025, 10, 12)),
    ..._paid(appleMusic, const LocalDate(2026, 9, 20)),
  ];

  static final categories = CategoryRules.seed();

  /// Per-category budgets like the mockup: AI over, Video near.
  static const budgets = [
    Budget(id: 'b-ai', categoryId: 'ai', amountMinor: 3500, currency: 'USD'),
    Budget(id: 'b-video', categoryId: 'video', amountMinor: 4000, currency: 'USD'),
  ];
}
