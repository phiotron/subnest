import 'package:subnest/domain/domain.dart';

/// The design's §8 sample data (design/system/bundle.js), shaped for the domain: today is
/// Wed 4 Nov 2026, Primary currency VND, 1 USD = 25,400 VND. Shared by the stats unit tests and
/// the Calendar / Insights widget + golden tests.
abstract final class Sample {
  static const today = LocalDate(2026, 11, 4);
  static final now = DateTime(2026, 11, 4, 10);
  static const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400});
  static const primary = 'VND';

  static Subscription _s(
    String id,
    String name,
    int priceMinor,
    LocalDate due, {
    String currency = 'VND',
    BillingCycle cycle = const BillingCycle.monthly(),
    SubscriptionCategory category = SubscriptionCategory.other,
    int color = 0xFF607D8B,
    String? icon,
    int shared = 1,
    SubscriptionStatus status = SubscriptionStatus.active,
    LocalDate? trialEnd,
    LocalDate? cancelledOn,
  }) => Subscription(
    id: id,
    name: name,
    priceMinor: priceMinor,
    currency: currency,
    cycle: cycle,
    anchorDate: due,
    startDate: const LocalDate(2025, 6, 1),
    createdAt: now,
    updatedAt: now,
    category: category,
    colorValue: color,
    iconText: icon,
    sharedWith: shared,
    status: status,
    trialEndDate: trialEnd,
    cancelledOn: cancelledOn,
  );

  static final viettel = _s(
    'viettel',
    'Viettel 5G',
    150000,
    const LocalDate(2026, 11, 1),
    category: SubscriptionCategory.telecom,
    color: 0xFFD7002B,
    icon: 'V',
  );
  static final netflix = _s(
    'netflix',
    'Netflix Premium',
    260000,
    const LocalDate(2026, 11, 4),
    category: SubscriptionCategory.video,
    color: 0xFFE50914,
    icon: 'N',
    shared: 4,
  );
  static final spotify = _s(
    'spotify',
    'Spotify Premium',
    59000,
    const LocalDate(2026, 11, 6),
    category: SubscriptionCategory.music,
    color: 0xFF1DB954,
    icon: 'S',
    status: SubscriptionStatus.trial,
    trialEnd: const LocalDate(2026, 11, 6),
  );
  static final chatgpt = _s(
    'chatgpt',
    'ChatGPT Plus',
    2000,
    const LocalDate(2026, 11, 7),
    currency: 'USD',
    category: SubscriptionCategory.ai,
    color: 0xFF202123,
    icon: 'C',
  );
  static final icloud = _s(
    'icloud',
    'iCloud+ 200GB',
    59000,
    const LocalDate(2026, 11, 15),
    category: SubscriptionCategory.storage,
    color: 0xFF3478F6,
    icon: 'iC',
  );
  static final youtube = _s(
    'youtube',
    'YouTube Premium Family',
    179000,
    const LocalDate(2026, 11, 22),
    category: SubscriptionCategory.video,
    color: 0xFFE62117,
    icon: 'YT',
    shared: 5,
  );
  static final googleOne = _s(
    'google1',
    'Google One 2TB',
    1690000,
    const LocalDate(2027, 3, 20),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.storage,
    color: 0xFF1A73E8,
    icon: 'G1',
  );
  static final canva = _s(
    'canva',
    'Canva Pro',
    1390000,
    const LocalDate(2027, 2, 12),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.software,
    color: 0xFF7D2AE8,
    icon: 'C',
  );
  static final duolingo = _s(
    'duolingo',
    'Duolingo Super',
    1029000,
    const LocalDate(2027, 1, 9),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.education,
    color: 0xFF58CC02,
    icon: 'D',
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 9, 2),
  );
  static final appleMusic = _s(
    'applemusic',
    'Apple Music',
    37500,
    const LocalDate(2026, 11, 20),
    category: SubscriptionCategory.music,
    color: 0xFFFA243C,
    icon: 'AM',
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 8, 20),
  );

  static final subscriptions = [
    viettel,
    netflix,
    spotify,
    chatgpt,
    icloud,
    youtube,
    googleOne,
    canva,
    duolingo,
    appleMusic,
  ];

  /// Payments Dec 2025 – Oct 2026 for the monthly plans, the yearly Canva (Feb) and Google One
  /// (Mar) renewals, and YouTube's skipped October period.
  static final List<ConfirmedPeriod> periods = () {
    final out = <ConfirmedPeriod>[];
    var n = 0;
    void pay(Subscription s, LocalDate due, {int? amount, bool skip = false}) => out.add(
      ConfirmedPeriod(
        id: 'p${++n}',
        subscriptionId: s.id,
        dueDate: due,
        outcome: skip ? PeriodOutcome.skipped : PeriodOutcome.payment,
        amountMinor: skip ? 0 : amount ?? s.myShareMinor,
        currency: s.currency,
        confirmedAt: now,
      ),
    );
    for (var i = 1; i <= 11; i++) {
      LocalDate at(Subscription s) => s.anchorDate.addMonths(-i);
      pay(viettel, at(viettel));
      pay(netflix, at(netflix));
      pay(chatgpt, at(chatgpt));
      pay(icloud, at(icloud));
      if (i == 1) {
        pay(youtube, at(youtube), skip: true);
      } else {
        pay(youtube, at(youtube));
      }
    }
    pay(canva, const LocalDate(2026, 2, 12));
    pay(googleOne, const LocalDate(2026, 3, 20));
    return out;
  }();

  static SpendingCalculator get calc => const SpendingCalculator(rates: rates, primaryCurrency: primary);
}
