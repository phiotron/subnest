import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../subscription_detail/cancel_flow.dart';
import 'home_list.dart';
import 'subscription_labels.dart';
import 'widgets/overview_cards.dart';
import 'widgets/sort_sheet.dart';

/// S2 Overview (png 08–15): date + "Overview" + search, spend hero (Month ↔ Year, colour strip,
/// "Biggest …", stale-rates chip), reminders-off banner, "N payments to confirm", trial ending,
/// upcoming 7 days, the Active · Trials · Cancelled list (sort sheet, swipe Confirm / Cancel,
/// savings card) and the add FAB. Empty: illustration + "Browse services".
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _yearly = false;
  HomeTab _tab = HomeTab.active;
  HomeSort _sort = HomeSort.dueDate;
  bool _searching = false;
  final _query = TextEditingController();
  final _scroll = ScrollController();
  final _listKey = GlobalKey();

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _closeSearch() => setState(() {
    _searching = false;
    _query.clear();
  });

  Future<void> _openLink(Subscription s, Uri? link) async {
    if (link == null) {
      await context.push(AppRoutes.subscriptionDetail(s.id));
      return;
    }
    var ok = false;
    try {
      ok = await launchUrl(link, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && mounted) showAppToast(context, context.l10n.subscriptionDetailLinkFailed(linkHost(link)), icon: AppIcons.alert);
  }

  Future<void> _turnOnReminders() async {
    await ref.read(notificationServiceProvider).requestPermission();
    ref.invalidate(notificationsEnabledProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final subsAsync = ref.watch(subscriptionsProvider);
    final today = ref.watch(todayProvider);

    // "See cancelled" from the celebration screen.
    final requested = ref.watch(homeTabRequestProvider);
    if (requested != null) {
      _tab = requested;
      _searching = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(homeTabRequestProvider.notifier).clear();
        final ctx = _listKey.currentContext;
        if (ctx != null && ctx.mounted) Scrollable.ensureVisible(ctx, duration: AppMotion.of(ctx, AppMotion.sheet));
      });
    }

    final subs = subsAsync.value;
    Widget body;
    if (subs == null) {
      body = subsAsync.hasError
          ? Center(child: Text('${subsAsync.error}'))
          : const Center(child: CircularProgressIndicator());
    } else if (_searching) {
      body = _searchBody(context, subs, today);
    } else {
      body = _overviewBody(context, subs, today);
    }

    return PopScope(
      canPop: !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _searching) _closeSearch();
      },
      child: Scaffold(
        backgroundColor: c.bg,
        floatingActionButton: _searching
            ? null
            : AppFab(tooltip: l.homeAdd, onPressed: () => context.push(AppRoutes.catalog)),
        body: SafeArea(bottom: false, child: body),
      ),
    );
  }

  // ---- Overview ------------------------------------------------------------------------------

  Widget _overviewBody(BuildContext context, List<Subscription> all, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final summary = ref.watch(spendingSummaryProvider);
    final rates = ref.watch(ratesProvider).value;
    final remindersOn = ref.watch(notificationsEnabledProvider).value ?? true;
    final catalog = ref.watch(catalogByIdProvider);
    final kept = ref.watch(keptTrialsProvider);
    final now = ref.watch(clockProvider)();

    Widget pad(Widget w) => Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4), child: w);

    final children = <Widget>[
      pad(_header(context, today)),
      if (!remindersOn)
        pad(
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s4),
            child: AppBanner(
              kind: BannerKind.neutral,
              icon: AppIcons.remindersOff,
              title: l.homeRemindersOffTitle,
              body: l.homeRemindersOffBody,
              actionLabel: l.homeRemindersTurnOn,
              onAction: _turnOnReminders,
            ),
          ),
        ),
    ];

    if (all.isEmpty) {
      children
        ..add(
          pad(
            SpendHero(
              label: l.homeMonthlySpend,
              amount: 0,
              format: (v) => l.amount(v, primary),
            ),
          ),
        )
        ..add(
          EmptyState(
            art: const NestArt(kind: NestArtKind.empty, width: 180),
            title: l.homeEmptyTitle,
            body: l.homeEmptyBody,
            actionLabel: l.homeBrowse,
            actionIcon: AppIcons.library,
            onAction: () => context.push(AppRoutes.catalog),
          ),
        );
      return ListView(padding: const EdgeInsets.only(bottom: AppSpace.s10 + AppSize.fabSize), children: children);
    }

    // 1. Hero
    final active = activeByCost(all, today, calc);
    final total = summary?.monthly ?? 0;
    final biggest = active.isEmpty || total <= 0 ? null : active.first;
    final staleChip = _ratesChip(context, all, primary, rates, now);
    children.add(
      pad(
        SpendHero(
          label: _yearly ? l.homeYearlySpend : l.homeMonthlySpend,
          amount: _yearly ? total * 12 : total,
          format: (v) => l.amount(v, primary),
          approx: anyConverted(active.map((e) => e.$1), primary),
          yearly: _yearly,
          onPeriodChanged: (y) => setState(() => _yearly = y),
          segments: [for (final (s, cost) in active) SpendSegment(color: Color(s.colorValue), value: cost)],
          leadingMeta: [
            l.homeActiveCount(summary?.activeCount ?? 0),
            l.homeTrialCount(summary?.trialCount ?? 0),
          ].join(' · '),
          trailingMeta: biggest == null
              ? null
              : l.homeBiggest(biggest.$1.name, (biggest.$2 / total * 100).round()),
          footer: staleChip,
        ),
      ),
    );

    // 2. Awaiting + trial cards
    final awaiting = ref.watch(awaitingPeriodsProvider);
    final cards = <Widget>[];
    if (awaiting.isNotEmpty) {
      final names = <String>[];
      for (final (s, _) in awaiting) {
        final n = shortName(s, catalog);
        if (!names.contains(n)) names.add(n);
      }
      final waitingSubs = {for (final (s, _) in awaiting) s};
      final sum = l.amount(summary?.awaitingTotal ?? 0, primary, approx: anyConverted(waitingSubs, primary));
      cards.add(
        AwaitingCard(
          count: awaiting.length,
          subtitle: '$sum · ${names.join(', ')}',
          onTap: () => context.push(AppRoutes.awaiting),
        ),
      );
    }
    final trial = endingTrial(all, today, kept);
    if (trial != null) {
      final name = shortName(trial, catalog);
      cards.add(
        TrialEndingCard(
          subscription: trial,
          title: l.homeTrialEnds(name, BillingRules.daysUntilDue(trial, today)),
          subtitle: l.homeTrialThen(
            pricePerCycle(l, trial),
            AppDates.weekdayShort(l, trial.dueDate, today: today),
          ),
          onTap: () => context.push(AppRoutes.subscriptionDetail(trial.id)),
          onHowToCancel: () => _openLink(trial, cancelLink(trial, catalog)),
          onKeep: () {
            ref.read(keptTrialsProvider.notifier).keep(trial.id);
            showAppToast(context, l.homeKept(name, AppDates.weekdayShort(l, trial.dueDate, today: today)));
          },
        ),
      );
    }
    if (cards.isNotEmpty) {
      children.add(
        pad(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[if (i > 0) const SizedBox(height: AppSpace.s3), cards[i]],
            ],
          ),
        ),
      );
    }

    // 3. Upcoming · 7 days
    final upcoming = CalendarBuilder.upcoming(subscriptions: all, today: today);
    if (upcoming.isNotEmpty) {
      children
        ..add(
          pad(
            SectionHeader(
              label: l.homeUpcoming,
              actionLabel: l.homeCalendar,
              onAction: () => context.go(AppRoutes.calendar),
              padding: const EdgeInsets.fromLTRB(0, AppSpace.s5, 0, AppSpace.s2),
            ),
          ),
        )
        ..add(
          pad(
            UpcomingStrip(
              cards: [
                for (final e in upcoming)
                  UpcomingCard(
                    subscription: e.subscription,
                    when: '${AppDates.weekdayShort(l, e.date, today: today)} · ${AppDates.relative(l, e.date, today: today)}',
                    amount: l.money(e.subscription.myShare),
                    amountMeta: _upcomingMeta(l, e, today, primary, calc),
                    onTap: () => context.push(AppRoutes.subscriptionDetail(e.subscription.id)),
                  ),
              ],
            ),
          ),
        );
    }

    // 4. Subscriptions list
    final counts = {for (final t in HomeTab.values) t: all.where((s) => tabOf(s, today) == t).length};
    final list = listFor(all, _tab, _sort, today: today, calc: calc);
    children.addAll([
      pad(
        Padding(
          key: _listKey,
          padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpace.s3,
            children: [
              Semantics(header: true, child: Text(l.homeSubscriptions, style: AppType.title.copyWith(color: c.ink))),
              SortButton(
                label: sortLabel(l, _sort),
                semanticLabel: l.homeSortLabel(sortLabel(l, _sort)),
                onPressed: () => showSortSheet(context, current: _sort, onChanged: (s) => setState(() => _sort = s)),
              ),
            ],
          ),
        ),
      ),
      pad(
        AppSegmentedControl<HomeTab>(
          selected: _tab,
          onChanged: (t) => setState(() => _tab = t),
          segments: [
            AppSegment(value: HomeTab.active, label: l.homeTabActive, count: counts[HomeTab.active]),
            AppSegment(value: HomeTab.trials, label: l.homeTabTrials, count: counts[HomeTab.trials]),
            AppSegment(value: HomeTab.cancelled, label: l.homeTabCancelled, count: counts[HomeTab.cancelled]),
          ],
        ),
      ),
      const SizedBox(height: AppSpace.s2),
      if (_tab == HomeTab.cancelled && (summary?.savingsYearly ?? 0) > 0)
        pad(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.s3),
            child: SavingsCard(
              label: l.homeSaving,
              amount: l.homePerYear(
                l.amount(
                  summary!.savingsYearly,
                  primary,
                  approx: anyConverted(all.where((s) => tabOf(s, today) == HomeTab.cancelled), primary),
                ),
              ),
            ),
          ),
        ),
      pad(
        list.isEmpty
            ? AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s5),
                child: Text(
                  switch (_tab) {
                    HomeTab.active => l.homeEmptyActive,
                    HomeTab.trials => l.homeEmptyTrials,
                    HomeTab.cancelled => l.homeEmptyCancelled,
                  },
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
              )
            : AppGroup(children: [for (final s in list) _row(context, s, today, primary, calc)]),
      ),
      if (_tab == HomeTab.trials)
        pad(
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s2, AppSpace.s1, 0),
            child: Text(l.homeTrialsNote, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        ),
    ]);

    return ListView(
      controller: _scroll,
      padding: const EdgeInsets.only(bottom: AppSpace.s4 + AppSize.fabSize + AppSpace.s6),
      children: children,
    );
  }

  Widget _header(BuildContext context, LocalDate today) {
    final l = context.l10n;
    return LargeTitle(
      eyebrow: AppDates.weekdayLong(l, today),
      title: l.homeTitle,
      trailing: AppIconButton(
        icon: AppIcons.search,
        tooltip: l.homeSearch,
        onPressed: () => setState(() => _searching = true),
      ),
    );
  }

  Widget? _ratesChip(BuildContext context, List<Subscription> all, String primary, ExchangeRates? rates, DateTime now) {
    if (rates == null || !all.any((s) => s.currency != primary && s.status != SubscriptionStatus.cancelled)) {
      return null;
    }
    final l = context.l10n;
    final at = rates.fetchedAt;
    String label;
    if (at == null) {
      label = l.homeRatesNever;
    } else {
      final days = now.difference(at).inDays;
      if (days < 2) return null; // refreshed daily when online; one missed day is not "offline"
      label = l.homeRatesStale(days);
    }
    return StatusBadge(label: label, icon: AppIcons.offline, large: true);
  }

  String _upcomingMeta(AppLocalizations l, CalendarEntry e, LocalDate today, String primary, SpendingCalculator calc) {
    final s = e.subscription;
    if (BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial && e.date == s.dueDate) {
      return l.homeFirstCharge;
    }
    if (s.currency != primary) {
      final v = calc.periodCost(s);
      if (v != null) return l.amount(v, primary, approx: true);
    }
    return perCycle(l, s.cycle);
  }

  Widget _row(BuildContext context, Subscription s, LocalDate today, String primary, SpendingCalculator calc) {
    final l = context.l10n;
    final state = rowState(s, today);
    final (amount, amountMeta) = rowAmounts(l, s, primary: primary, calc: calc);
    return SubscriptionRow(
      key: ValueKey('row-${s.id}'),
      name: s.name,
      colorValue: s.colorValue,
      iconText: s.iconText,
      state: state,
      meta: rowMeta(l, s, today),
      awaitingCount: state == SubscriptionRowState.awaiting ? BillingRules.pendingDueDates(s, today).length : 1,
      badgeLabel: state == SubscriptionRowState.trial ? l.homeTrialBadge : null,
      sharedCount: s.isShared ? s.sharedWith : null,
      amount: amount,
      amountMeta: amountMeta,
      onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
      onConfirm: () => context.push(AppRoutes.confirm(s.id)),
      onCancel: state == SubscriptionRowState.cancelled ? null : () => markCancelledFlow(context, ref, s),
    );
  }

  // ---- Search --------------------------------------------------------------------------------

  Widget _searchBody(BuildContext context, List<Subscription> all, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final q = _query.text.trim();
    final results = search(all, q);
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s6),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _query,
                autofocus: true,
                textInputAction: TextInputAction.search,
                onChanged: (_) => setState(() {}),
                style: AppType.body.copyWith(color: c.ink),
                decoration: InputDecoration(
                  hintText: l.homeSearchHint,
                  prefixIcon: Icon(AppIcons.search, size: 20, color: c.inkMuted),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: q.isEmpty
                      ? null
                      : IconButton(
                          tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                          icon: Icon(AppIcons.clear, size: 20, color: c.inkMuted),
                          onPressed: () => setState(_query.clear),
                        ),
                ),
              ),
            ),
            const SizedBox(width: AppSpace.s1),
            AppIconButton(icon: AppIcons.close, tooltip: l.homeSearchClose, onPressed: _closeSearch),
          ],
        ),
        const SizedBox(height: AppSpace.s4),
        if (q.isNotEmpty && results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s6),
            child: Text(
              l.homeSearchEmpty(q),
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: c.inkMuted),
            ),
          ),
        if (results.isNotEmpty) AppGroup(children: [for (final s in results) _row(context, s, today, primary, calc)]),
      ],
    );
  }
}
