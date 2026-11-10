import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/subscription_repository.dart' show DetectionReport;
import '../../domain/domain.dart';
import '../subscription_detail/cancel_flow.dart';
import 'home_list.dart';
import 'subscription_labels.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/overview_cards.dart';
import 'widgets/overview_v13.dart';
import 'widgets/sort_sheet.dart';

/// S2 Overview (mockup v13, png 08–20): date + "Overview" + search, spend hero (Month ↔ Year,
/// budget bar — or the colour strip without a budget —, "Biggest …", stale-rates chip),
/// reminders-off banner, "N payments to confirm", trial ending, "Due this week", then the
/// Active · Trials · Cancelled list with Filter (sheet + removable chips) and Sort (both
/// remembered in Settings), rows with logo, period progress, label chip, Auto badge, Paused /
/// "Pauses 15 Nov"; swipe Confirm / Cancel; savings card; Undo snackbar after automatic adds
/// ([homeAutoUndoProvider]) and the add FAB. Empty: illustration + "Browse services".
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _yearly = false;
  HomeTab _tab = HomeTab.active;
  HomeSort _sort = HomeSort.dueDate;
  HomeFilter _filter = HomeFilter.none;
  bool _restored = false;
  Set<String> _flashIds = const {};
  Timer? _flashTimer;
  bool _searching = false;
  final _query = TextEditingController();
  final _scroll = ScrollController();
  final _listKey = GlobalKey();

  @override
  void dispose() {
    _flashTimer?.cancel();
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
    if (!ok && mounted) {
      showAppToast(context, context.l10n.subscriptionDetailLinkFailed(linkHost(link)), icon: AppIcons.alert);
    }
  }

  void _setSort(HomeSort sort) {
    setState(() => _sort = sort);
    ref.read(settingsRepositoryProvider).setHomeSort(sort == HomeSort.dueDate ? null : sort.name);
  }

  void _setFilter(HomeFilter filter, {List<Subscription> all = const [], LocalDate? today}) {
    setState(() {
      _filter = filter;
      // Nothing left in this tab but some in another (e.g. "Cancelled" picked on Active) → go there.
      if (today != null &&
          filter.statuses.isNotEmpty &&
          !all.any((s) => tabOf(s, today) == _tab && filter.matches(s, today))) {
        for (final t in HomeTab.values) {
          if (all.any((s) => tabOf(s, today) == t && filter.matches(s, today))) {
            _tab = t;
            break;
          }
        }
      }
    });
    ref.read(settingsRepositoryProvider).setHomeFilter(filter.encode());
  }

  Future<void> _openFilter(List<Subscription> all, LocalDate today) async {
    final cats = ref.read(categoriesProvider).value ?? const <Category>[];
    final used = {for (final s in all) s.categoryId, ..._filter.categoryIds};
    final picked = await showFilterSheet(
      context,
      current: _filter,
      categories: [
        for (final c in cats)
          if (used.contains(c.id)) c,
      ],
      labels: ref.read(labelsProvider).value ?? const [],
      paymentMethods: ref.read(paymentMethodsProvider).value ?? const [],
      countFor: (f) => all.where((s) => f.matches(s, today)).length,
    );
    if (picked != null && mounted) _setFilter(picked, all: all, today: today);
  }

  void _showAutoUndo(DetectionReport report) {
    final l = context.l10n;
    final parts = <String>[
      if (report.added.isNotEmpty)
        report.added.every((s) => s.detectionSource == DetectionSource.scan)
            ? l.homeAutoAddedScan(report.added.length)
            : l.homeAutoAdded(report.added.length),
      if (report.confirmed.isNotEmpty) l.homeAutoConfirmed(report.confirmed.length),
    ];
    _flashTimer?.cancel();
    setState(() => _flashIds = {for (final s in report.added) s.id});
    _flashTimer = Timer(AppMotion.newRowFlash + const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _flashIds = const {});
    });
    final repo = ref.read(subscriptionRepositoryProvider);
    final c = context.colors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 6),
          action: SnackBarAction(
            label: l.homeUndo,
            onPressed: () async {
              for (final s in report.added) {
                await repo.undoAutoAdd(s.id);
              }
              for (final p in report.confirmed) {
                await repo.undoAutoConfirm(p.id);
              }
              if (mounted) showAppToast(context, l.homeUndone);
            },
          ),
          content: Row(
            children: [
              Icon(LucideIcons.sparkles, size: 18, color: c.bg),
              const SizedBox(width: 10),
              Expanded(child: Text(parts.join(' · '))),
            ],
          ),
        ),
      );
  }

  Future<void> _turnOnReminders() async {
    await ref.read(notificationServiceProvider).requestPermissionOrOpenSettings();
    ref.invalidate(notificationsEnabledProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final subsAsync = ref.watch(subscriptionsProvider);
    final today = ref.watch(todayProvider);

    // Filter + sort remembered between launches (restored once, when Settings first load).
    final settings = ref.watch(settingsProvider).value;
    if (!_restored && settings != null) {
      _restored = true;
      _sort = HomeSort.parse(settings.homeSort);
      _filter = HomeFilter.decode(settings.homeFilter);
    }

    ref.listen(homeAutoUndoProvider, (_, report) {
      if (report == null) return;
      ref.read(homeAutoUndoProvider.notifier).clear();
      _showAutoUndo(report);
    });

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

    Widget pad(Widget w) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      child: w,
    );

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
        ..add(pad(SpendHero(label: l.homeMonthlySpend, amount: 0, format: (v) => l.amount(v, primary))))
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
      return ListView(
        padding: const EdgeInsets.only(bottom: AppSpace.s10 + AppSize.fabSize),
        children: children,
      );
    }

    // 1. Hero
    final active = activeByCost(all, today, calc);
    final total = summary?.monthly ?? 0;
    final biggest = active.isEmpty || total <= 0 ? null : active.first;
    final staleChip = _ratesChip(context, all, primary, rates, now);
    final segments = [for (final (s, cost) in active) SpendSegment(color: Color(s.colorValue), value: cost)];
    final leadingMeta = [
      l.homeActiveCount(summary?.activeCount ?? 0),
      l.homeTrialCount(summary?.trialCount ?? 0),
    ].join(' · ');
    final trailingMeta = biggest == null ? null : l.homeBiggest(biggest.$1.name, (biggest.$2 / total * 100).round());
    final budget = ref.watch(budgetUsageProvider).where((u) => u.budget.isTotal && u.ratio != null).firstOrNull;
    final heroLabel = _yearly ? l.homeYearlySpend : l.homeMonthlySpend;
    final heroApprox = anyConverted(active.map((e) => e.$1), primary);
    children.add(
      pad(
        budget == null
            ? SpendHero(
                label: heroLabel,
                amount: _yearly ? (summary?.yearly ?? 0) : total,
                format: (v) => l.amount(v, primary),
                approx: heroApprox,
                yearly: _yearly,
                onPeriodChanged: (y) => setState(() => _yearly = y),
                segments: segments,
                leadingMeta: leadingMeta,
                trailingMeta: trailingMeta,
                footer: staleChip,
              )
            // With a total budget the colour strip becomes the budget bar, between the total and the
            // meta line (png 08). SpendHero has no slot there, so the bar + meta go in its footer.
            : SpendHero(
                label: heroLabel,
                amount: _yearly ? (summary?.yearly ?? 0) : total,
                format: (v) => l.amount(v, primary),
                approx: heroApprox,
                yearly: _yearly,
                onPeriodChanged: (y) => setState(() => _yearly = y),
                footer: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BudgetBar(
                        ratio: budget.ratio!,
                        budget: l.amount(budget.limit!, primary),
                        segments: segments,
                        onTap: () => context.push(AppRoutes.settingsBudgets),
                      ),
                      const SizedBox(height: AppSpace.s1),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        spacing: AppSpace.s2,
                        runSpacing: 2,
                        children: [
                          Text(leadingMeta, style: AppType.meta.copyWith(color: c.inkMuted)),
                          if (trailingMeta != null) Text(trailingMeta, style: AppType.meta.copyWith(color: c.inkMuted)),
                        ],
                      ),
                      if (staleChip != null) ...[
                        const SizedBox(height: AppSpace.s3),
                        Align(alignment: AlignmentDirectional.centerStart, child: staleChip),
                      ],
                    ],
                  ),
                ),
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
          subtitle: l.homeTrialThen(pricePerCycle(l, trial), AppDates.weekdayShort(l, trial.dueDate, today: today)),
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

    // 3. Due this week (awaiting amounts shown apart, in amber)
    final week = ref.watch(weekStripProvider);
    if (week != null) {
      var waiting = 0.0;
      final days = <WeekDay>[];
      for (var i = 0; i < week.days.length; i++) {
        final date = week.start.addDays(i);
        final subs = <Subscription>[];
        final awaitingIds = <String>{};
        for (final it in week.days[i]) {
          if (!subs.contains(it.subscription)) subs.add(it.subscription);
          if (date == today && BillingRules.isAwaitingConfirmation(it.subscription, today)) {
            awaitingIds.add(it.subscription.id);
            waiting += it.amount;
          }
        }
        days.add(WeekDay(date: date, subscriptions: subs, awaitingIds: awaitingIds));
      }
      final weekApprox = anyConverted({
        for (final d in days)
          for (final x in d.subscriptions)
            if (!d.awaitingIds.contains(x.id)) x,
      }, primary);
      final waitApprox = anyConverted({
        for (final d in days)
          for (final x in d.subscriptions)
            if (d.awaitingIds.contains(x.id)) x,
      }, primary);
      children.add(
        pad(
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s5),
            child: WeekCard(
              total: l.amount(week.total - waiting, primary, approx: weekApprox),
              toConfirm: waiting > 0 ? l.amount(waiting, primary, approx: waitApprox) : null,
              days: days,
              today: today,
              onTap: () => context.go(AppRoutes.calendar),
            ),
          ),
        ),
      );
    }

    // 4. Subscriptions list
    final counts = {for (final t in HomeTab.values) t: all.where((s) => tabOf(s, today) == t).length};
    final filter = _filter.prune(
      categoryIds: ref.watch(categoriesProvider).value?.map((e) => e.id).toSet(),
      labelIds: ref.watch(labelsProvider).value?.map((e) => e.id).toSet(),
      paymentMethodIds: ref.watch(paymentMethodsProvider).value?.map((e) => e.id).toSet(),
    );
    final list = listFor(all, _tab, _sort, today: today, calc: calc, filter: filter);
    final categories = ref.watch(categoryByIdProvider);
    final labels = {for (final x in ref.watch(labelsProvider).value ?? const <Label>[]) x.id: x};
    final methods = {for (final x in ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[]) x.id: x};
    final activeFilters = <ActiveFilter>[
      for (final st in HomeStatus.values)
        if (filter.statuses.contains(st))
          ActiveFilter(
            statusLabel(l, st),
            () => _setFilter(filter.copyWith(statuses: {...filter.statuses}..remove(st))),
          ),
      for (final id in filter.categoryIds)
        if (categories[id] case final cat?)
          ActiveFilter(
            l.categoryName(cat),
            () => _setFilter(filter.copyWith(categoryIds: {...filter.categoryIds}..remove(id))),
          ),
      for (final id in filter.labelIds)
        if (labels[id] case final lb?)
          ActiveFilter(
            l.homeFilterChipLabel(lb.name),
            () => _setFilter(filter.copyWith(labelIds: {...filter.labelIds}..remove(id))),
          ),
      for (final id in filter.paymentMethodIds)
        if (methods[id] case final m?)
          ActiveFilter(
            m.name,
            () => _setFilter(filter.copyWith(paymentMethodIds: {...filter.paymentMethodIds}..remove(id))),
          ),
    ];
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
              Semantics(
                header: true,
                child: Text(l.homeSubscriptions, style: AppType.title.copyWith(color: c.ink)),
              ),
              Wrap(
                spacing: AppSpace.s2,
                children: [
                  SortButton(
                    icon: LucideIcons.slidersHorizontal,
                    label: l.homeFilter,
                    semanticLabel: l.homeFilterButtonLabel(filter.count),
                    active: !filter.isEmpty,
                    count: filter.count,
                    onPressed: () => _openFilter(all, today),
                  ),
                  SortButton(
                    label: sortLabel(l, _sort),
                    semanticLabel: l.homeSortLabel(sortLabel(l, _sort)),
                    onPressed: () => showSortSheet(context, current: _sort, onChanged: _setSort),
                  ),
                ],
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
      if (activeFilters.isNotEmpty)
        pad(
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpace.s2),
            child: ActiveFilterChips(filters: activeFilters, onClear: () => _setFilter(HomeFilter.none)),
          ),
        ),
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
                  !filter.isEmpty
                      ? l.homeEmptyFiltered
                      : switch (_tab) {
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

  Widget _row(BuildContext context, Subscription s, LocalDate today, String primary, SpendingCalculator calc) {
    final l = context.l10n;
    final state = rowState(s, today);
    final (amount, amountMeta) = rowAmounts(l, s, primary: primary, calc: calc);
    final catalog = ref.watch(catalogByIdProvider);
    final labels = ref.watch(labelsProvider).value ?? const <Label>[];
    final mine = [
      for (final x in labels)
        if (s.labelIds.contains(x.id)) x,
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final pauses = pausesOn(s, today);
    final trialEnd = s.trialEndDate;
    final CycleProgress? progress = switch (state) {
      SubscriptionRowState.trial when trialEnd != null && trialEnd.isAfter(s.startDate) => CycleProgress(
        from: s.startDate,
        due: trialEnd,
        today: today,
      ),
      SubscriptionRowState.normal ||
      SubscriptionRowState.trial ||
      SubscriptionRowState.awaiting => CycleProgress.forSubscription(s, today: today),
      SubscriptionRowState.cancelled || SubscriptionRowState.paused => null,
    };
    return SubscriptionRow(
      key: ValueKey('row-${s.id}'),
      name: s.name,
      colorValue: s.colorValue,
      iconText: s.iconText,
      state: state,
      meta: rowMeta(l, s, today, categories: ref.watch(categoryByIdProvider)),
      logoDomain: s.serviceId == null ? null : catalog[s.serviceId]?.logoDomain,
      progress: progress,
      highlight: _flashIds.contains(s.id),
      nameBadge: s.isAutoDetected ? const AutoBadge() : null,
      metaExtras: [
        if (pauses != null)
          StatusBadge(
            label: l.homePausesOn(AppDates.short(l, pauses, today: today)),
            icon: LucideIcons.pause,
          ),
        if (mine.isNotEmpty && state != SubscriptionRowState.cancelled) ...[
          LabelChip(name: mine.first.name, colorValue: mine.first.colorValue),
          if (mine.length > 1)
            Text(
              '+${mine.length - 1}',
              semanticsLabel: l.homeMoreLabels(mine.length - 1),
              style: AppType.meta.copyWith(color: context.colors.inkMuted),
            ),
        ],
      ],
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
