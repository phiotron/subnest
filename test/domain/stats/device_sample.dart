import 'package:subnest/domain/domain.dart';

/// Data shaped like the Galaxy A13 on 2026-11-06 when S9 looked wrong: the VI demo backup
/// (store/screenshots/tools/make_demo_backup.py, generated 2026-11-05) with the Primary currency
/// switched to USD, plus a yearly "ChatGPT Pro 100" added on the phone (renews in December, no
/// Payment yet). History starts in December 2025, so last year is almost empty.
abstract final class DeviceSample {
  static const today = LocalDate(2026, 11, 6);
  static final now = DateTime(2026, 11, 5, 10);
  static const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25701});
  static const primary = 'USD';

  static Subscription _s(
    String id,
    String name,
    int priceMinor,
    LocalDate due, {
    String currency = 'VND',
    BillingCycle cycle = const BillingCycle.monthly(),
    SubscriptionCategory category = SubscriptionCategory.other,
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
    colorValue: 0xFF607D8B,
    sharedWith: shared,
    status: status,
    trialEndDate: trialEnd,
    cancelledOn: cancelledOn,
  );

  static final viettel = _s('viettel', 'Viettel 5G', 150000, const LocalDate(2026, 11, 1), category: SubscriptionCategory.telecom);
  static final netflix = _s('netflix', 'Netflix Premium', 260000, const LocalDate(2026, 11, 5), category: SubscriptionCategory.video, shared: 4);
  static final spotify = _s(
    'spotify',
    'Spotify Premium',
    59000,
    const LocalDate(2026, 11, 7),
    category: SubscriptionCategory.music,
    status: SubscriptionStatus.trial,
    trialEnd: const LocalDate(2026, 11, 7),
  );
  static final youtube = _s('youtube', 'YouTube Premium Family', 179000, const LocalDate(2026, 11, 23), category: SubscriptionCategory.video, shared: 5);
  static final chatgpt = _s('chatgpt', 'ChatGPT Plus', 2000, const LocalDate(2026, 11, 8), currency: 'USD', category: SubscriptionCategory.ai);
  static final chatgptPro = _s(
    'chatgpt-pro',
    'ChatGPT Pro 100',
    34188000,
    const LocalDate(2026, 12, 2),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.ai,
  );
  static final icloud = _s('icloud', 'iCloud+ 200GB', 59000, const LocalDate(2026, 11, 16), category: SubscriptionCategory.storage);
  static final googleOne = _s(
    'google1',
    'Google One 2TB',
    1690000,
    const LocalDate(2027, 3, 21),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.storage,
  );
  static final canva = _s(
    'canva',
    'Canva Pro',
    1390000,
    const LocalDate(2027, 2, 3),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.software,
  );
  static final duolingo = _s(
    'duolingo',
    'Duolingo Super',
    699000,
    const LocalDate(2027, 1, 9),
    cycle: const BillingCycle.yearly(),
    category: SubscriptionCategory.education,
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 10, 12),
  );
  static final appleMusic = _s(
    'applemusic',
    'Apple Music',
    65000,
    const LocalDate(2026, 11, 21),
    category: SubscriptionCategory.music,
    status: SubscriptionStatus.cancelled,
    cancelledOn: const LocalDate(2026, 8, 20),
  );

  static final subscriptions = [
    viettel,
    netflix,
    spotify,
    youtube,
    chatgpt,
    chatgptPro,
    icloud,
    googleOne,
    canva,
    duolingo,
    appleMusic,
  ];

  /// As the demo script writes them: monthly plans pay the 11 periods before their Due date
  /// (Viettel 10, YouTube skipped the last one), yearly plans paid once a year ago.
  static final List<ConfirmedPeriod> periods = () {
    final out = <ConfirmedPeriod>[];
    var n = 0;
    void add(Subscription s, LocalDate due, {bool skip = false}) => out.add(
      ConfirmedPeriod(
        id: 'd${++n}',
        subscriptionId: s.id,
        dueDate: due,
        outcome: skip ? PeriodOutcome.skipped : PeriodOutcome.payment,
        amountMinor: skip ? 0 : s.myShareMinor,
        currency: s.currency,
        confirmedAt: now,
      ),
    );
    for (final (s, count) in [(viettel, 10), (netflix, 11), (youtube, 11), (chatgpt, 11), (icloud, 11)]) {
      for (var i = 1; i <= count; i++) {
        add(s, s.anchorDate.addMonths(-i), skip: s == youtube && i == 1);
      }
    }
    add(googleOne, const LocalDate(2026, 3, 21));
    add(canva, const LocalDate(2026, 2, 3));
    return out;
  }();

  static SpendingCalculator get calc => const SpendingCalculator(rates: rates, primaryCurrency: primary);
}
