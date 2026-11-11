import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/catalog/catalog_providers.dart';
import '../../data/providers.dart';
import '../../data/subscription_repository.dart' show DetectionReport;
import '../../domain/domain.dart';
import '../catalog/catalog_helpers.dart' show CatalogView;
import '../subscription_detail/cancel_flow.dart';
import 'home_list.dart';
import 'subscription_labels.dart';
import 'widgets/cost_card.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/overview_cards.dart';
import 'widgets/overview_v13.dart';
import 'widgets/sort_sheet.dart';
import 'widgets/upcoming_budget.dart';

/// S2 Overview (mockup v14, png 012–029): date + "Overview" + search; reminders-off banner; the
/// **Cost card** (Monthly | Yearly, change vs the month before, ≈ total + (i), per-day line, Paid /
/// Still to pay, 6 month columns → Insights on that month); offline-rates chip; "N payments to
/// confirm", the trial card (Keep it · View · How to cancel) and library price notices; **Upcoming
/// payments** strip; **Budget**; then the Active · Trial · Paused · Cancelled list with search,
/// Filter (sheet + removable chips) and Sort (both remembered), rows with logo, cycle chip and ↑ for
/// recent price rises; swipe Confirm / Cancel; Undo snackbar after automatic adds
/// ([homeAutoUndoProvider]) and the add FAB. Empty: zero card + illustration + "Browse services".
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

  /// A column of the Cost card: Insights opens on that month (decision 2026-11-10 (2) #4).
  void _openInsights(LocalDate month) {
    ref.read(selectedStatsMonthProvider.notifier).select(month);
    context.go(AppRoutes.insights);
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
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final rates = ref.watch(ratesProvider).value;
    final remindersOn = ref.watch(notificationsEnabledProvider).value ?? true;
    final now = ref.watch(clockProvider)();

    Widget pad(Widget w, {double top = 0}) =>
        Padding(padding: EdgeInsets.fromLTRB(AppSpace.s4, top, AppSpace.s4, 0), child: w);

    final children = <Widget>[
      pad(_header(context, today)),
      if (!remindersOn)
        pad(
          top: AppSpace.s4,
          AppBanner(
            kind: BannerKind.neutral,
            icon: AppIcons.remindersOff,
            title: l.homeRemindersOffTitle,
            body: l.homeRemindersOffBody,
            actionLabel: l.homeRemindersTurnOn,
            onAction: _turnOnReminders,
          ),
        ),
    ];

    if (all.isEmpty) {
      children
        ..add(
          pad(
            top: AppSpace.s3,
            CostCard.empty(total: 0, format: (v) => l.amount(v, primary), subline: l.homeCostNone),
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
      return ListView(
        padding: const EdgeInsets.only(bottom: AppSpace.s10 + AppSize.fabSize),
        children: children,
      );
    }

    // 1. Cost card + offline chip
    children.add(pad(top: AppSpace.s3, _costCard(context, today, primary)));
    final staleChip = _ratesChip(context, all, primary, rates, now);
    if (staleChip != null) {
      children.add(
        pad(
          top: AppSpace.s3,
          Align(alignment: AlignmentDirectional.centerStart, child: staleChip),
        ),
      );
    }

    // 2. To confirm, trial, price notices
    final cards = [..._awaitingCards(context, primary), ..._trialCards(context, all, today, calc, primary)];
    cards.addAll(_noticeCards(context, today));
    for (var i = 0; i < cards.length; i++) {
      children.add(pad(top: AppSpace.s3, cards[i]));
    }

    // 3. Upcoming payments + budget
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: AppSpace.s5),
        child: _upcoming(context, all, today, primary),
      ),
    );
    final budget = _budget(context, primary);
    if (budget != null) children.add(pad(top: AppSpace.s4, budget));

    // 4. Subscriptions list
    children.addAll(_listSection(context, all, today, primary, calc));

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

  /// "Nov" / "Thg 11" (columns) — [lower]: "thg 10" inside a sentence ("so với thg 10").
  static String _monthShort(AppLocalizations l, LocalDate m, {bool lower = false}) {
    final lang = l.localeName.split(RegExp('[_-]')).first;
    if (lang == 'vi') return '${lower ? 'thg' : 'Thg'} ${m.month}';
    return DateFormat('MMM', lang).format(DateTime(m.year, m.month));
  }

  Widget _costCard(BuildContext context, LocalDate today, String primary) {
    final l = context.l10n;
    final month = today.firstOfMonth;
    String money(int minor, {bool approx = false}) => l.money(Money(minor, primary), approx: approx);
    double major(int minor) => toMajorUnits(minor, primary);

    CostColumn column(MonthSpend m, {required bool selected, required bool future}) => CostColumn(
      label: _monthShort(l, m.month),
      value: m.total,
      valueText: money(m.totalMinor),
      semanticLabel: l.spoken(
        l.homeColumnLabel(AppDates.monthTitle(l, m.month.year, m.month.month), money(m.totalMinor)),
      ),
      selected: selected,
      future: future,
      onTap: () => _openInsights(m.month),
    );

    if (!_yearly) {
      final ms = ref.watch(monthSpendProvider(month));
      final cf = ref.watch(monthCashFlowProvider(month));
      final series = ref.watch(monthSpendSeriesProvider((month, 6)));
      final approx = ms != null && anyConverted(ms.lines.map((e) => e.subscription), primary);
      final prev = ms?.previousTotalMinor ?? 0;
      final change = ms?.changeMinor;
      final daily = money(ms?.dailyAverageMinor ?? 0, approx: true);
      // First months with nothing paid yet are dropped (png 020: only Oct + Nov), at least 2 kept.
      var cols = series ?? const <MonthSpend>[];
      while (cols.length > 2 && cols.first.totalMinor == 0) {
        cols = cols.sublist(1);
      }
      return CostCard(
        yearly: false,
        onYearlyChanged: (y) => setState(() => _yearly = y),
        total: ms?.total ?? 0,
        format: (v) => l.amount(v, primary),
        approx: approx,
        delta: ms == null || change == null || prev == 0
            ? null
            : DeltaChip(
                change: change,
                amount: money(change.abs()),
                period: _monthShort(l, month.addMonths(-1), lower: true),
              ),
        noComparison: ms != null && prev == 0 ? l.homeFirstMonth : null,
        subline: '${l.homeCostActive(ms?.count ?? 0)} · ${l.homeCostPerDay(daily)}',
        sublineBold: daily,
        onInfo: () => showHowNumbersWorkSheet(context),
        paid: cf == null ? null : money(cf.paidMinor, approx: cf.paid.any((p) => p.period.amount.currency != primary)),
        due: cf == null
            ? null
            : money(cf.remainingMinor, approx: cf.remaining.any((i) => i.subscription.currency != primary)),
        paidValue: cf == null ? 0 : major(cf.paidMinor),
        dueValue: cf == null ? 0 : major(cf.remainingMinor),
        range: l.homeRange(AppDates.short(l, month, today: today), AppDates.short(l, lastOfMonth(month), today: today)),
        columns: [for (final m in cols) column(m, selected: m.month == month, future: false)],
      );
    }

    final ys = ref.watch(yearSpendProvider(today.year));
    var paid = 0;
    var due = 0;
    var paidApprox = false;
    var dueApprox = false;
    for (var m = 1; m <= 12; m++) {
      final cf = ref.watch(monthCashFlowProvider(LocalDate(today.year, m, 1)));
      if (cf == null) continue;
      paid += cf.paidMinor;
      due += cf.remainingMinor;
      paidApprox = paidApprox || cf.paid.any((p) => p.period.amount.currency != primary);
      dueApprox = dueApprox || cf.remaining.any((i) => i.subscription.currency != primary);
    }
    final total = ys?.totalMinor ?? 0;
    final prev = ys?.previousTotalMinor ?? 0;
    final perMonth = money((total / 12).round(), approx: true);
    final approx = ys != null && anyConverted(ys.lines.map((e) => e.subscription), primary);
    return CostCard(
      yearly: true,
      onYearlyChanged: (y) => setState(() => _yearly = y),
      total: major(total),
      format: (v) => l.amount(v, primary),
      approx: approx,
      delta: ys == null || ys.changeMinor == null || prev == 0
          ? null
          : DeltaChip(change: ys.changeMinor!, amount: money(ys.changeMinor!.abs()), period: '${today.year - 1}'),
      subline: l.homeCostYearSub('${today.year}', perMonth),
      sublineBold: perMonth,
      onInfo: () => showHowNumbersWorkSheet(context),
      paid: money(paid, approx: paidApprox),
      due: money(due, approx: dueApprox),
      paidValue: major(paid),
      dueValue: major(due),
      range: l.homeRange(
        AppDates.short(l, LocalDate(today.year, 1, 1), today: today),
        AppDates.full(l, LocalDate(today.year, 12, 31)),
      ),
      columns: [
        for (final m in ys?.months ?? const <MonthSpend>[])
          column(m, selected: m.month == month, future: m.month.isAfter(month)),
      ],
    );
  }

  List<Widget> _awaitingCards(BuildContext context, String primary) {
    final l = context.l10n;
    final awaiting = ref.watch(awaitingPeriodsProvider);
    if (awaiting.isEmpty) return const [];
    final subs = <Subscription>[];
    for (final (s, _) in awaiting) {
      if (!subs.any((x) => x.id == s.id)) subs.add(s);
    }
    final summary = ref.watch(spendingSummaryProvider);
    final sum = l.amount(summary?.awaitingTotal ?? 0, primary, approx: anyConverted(subs, primary));
    return [
      AwaitingCard(
        count: awaiting.length,
        amount: sum,
        subscriptions: subs,
        onTap: () => context.push(AppRoutes.awaiting),
      ),
    ];
  }

  List<Widget> _trialCards(
    BuildContext context,
    List<Subscription> all,
    LocalDate today,
    SpendingCalculator calc,
    String primary,
  ) {
    final l = context.l10n;
    final catalog = ref.watch(catalogByIdProvider);
    final trial = endingTrial(all, today, ref.watch(keptTrialsProvider));
    if (trial == null) return const [];
    final name = shortName(trial, catalog);
    final price = l.money(trial.myShare);
    final yearly = calc.yearlyCost(trial);
    final saving = yearly == null || yearly <= 0 ? null : l.amount(yearly, primary, approx: trial.currency != primary);
    return [
      TrialEndingCard(
        subscription: trial,
        title: l.homeTrialEnds(name, BillingRules.daysUntilDue(trial, today)),
        subtitle: l.homeTrialThenOn(price, AppDates.short(l, trial.dueDate, today: today)),
        subtitleBold: price,
        onTap: () => context.push(AppRoutes.subscriptionDetail(trial.id)),
        savings: saving == null ? null : l.homeTrialSavings(saving),
        savingsBold: saving,
        onView: () => context.push(AppRoutes.subscriptionDetail(trial.id)),
        onHowToCancel: switch (cancelLink(trial, catalog)) {
          final link? => () => _openLink(trial, link),
          null => null,
        },
        onKeep: () {
          ref.read(keptTrialsProvider.notifier).keep(trial.id);
          showAppToast(context, l.homeKept(name, AppDates.weekdayShort(l, trial.dueDate, today: today)));
        },
      ),
    ];
  }

  List<Widget> _noticeCards(BuildContext context, LocalDate today) {
    final l = context.l10n;
    final notices = ref.watch(priceChangeNoticesProvider);
    final catalog = ref.watch(catalogByIdProvider);
    return [
      for (final n in notices.take(3))
        Builder(
          builder: (context) {
            final s = n.subscription;
            final name = shortName(s, catalog);
            String m(int minor) => l.money(Money(minor, n.currency));
            final date = AppDates.short(l, s.dueDate, today: today);
            final note = s.isShared
                ? l.homeNoticeShare(
                    m((n.oldPriceMinor / s.sharedWith).round()),
                    m((n.newPriceMinor / s.sharedWith).round()),
                    date,
                  )
                : l.homeNoticeFrom(date);
            return PriceNoticeCard(
              key: ValueKey('notice-${s.id}'),
              subscription: s,
              title: l.homeNoticeTitle(name),
              oldPrice: m(n.oldPriceMinor),
              newPrice: m(n.newPriceMinor),
              note: note,
              reference: n.isReference ? l.homeNoticeReference : null,
              onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
              onUpdate: () => _updatePrice(n, name, m(n.newPriceMinor), date),
              onKeep: () async {
                await ref.read(priceNoticeActionsProvider).keepOldPrice(n);
                if (mounted) showAppToast(this.context, l.homeNoticeKept(name, m(n.oldPriceMinor)));
              },
            );
          },
        ),
    ];
  }

  Future<void> _updatePrice(PriceChangeNotice n, String name, String price, String date) async {
    final l = context.l10n;
    final ok = await ref.read(priceNoticeActionsProvider).update(n);
    if (!mounted) return;
    showAppToast(context, ok ? l.homeNoticeUpdated(name, price, date) : l.homeNoticeStale);
  }

  Widget _upcoming(BuildContext context, List<Subscription> all, LocalDate today, String primary) {
    final l = context.l10n;
    final awaiting = ref.watch(awaitingPeriodsProvider);
    final items = <UpcomingItem>[];
    final seen = <String>{};
    for (final (s, _) in awaiting) {
      if (!seen.add(s.id)) continue;
      items.add(
        UpcomingItem(
          subscription: s,
          price: l.money(s.myShare),
          when: l.commonStatusAwaiting,
          awaiting: true,
          onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
          onConfirm: () => context.push(AppRoutes.confirm(s.id)),
        ),
      );
    }
    final ahead = ref.watch(forecastCalculatorProvider).items(all, today.addDays(1), today.addDays(30));
    for (final it in ahead.take(12)) {
      final s = it.subscription;
      final n = today.daysUntil(it.date);
      final left = l.homeDaysLeft(n);
      final firstCharge = s.status == SubscriptionStatus.trial && s.trialEndDate == it.date;
      items.add(
        UpcomingItem(
          subscription: s,
          price: l.money(s.myShare),
          when: firstCharge ? l.homeFirstChargeWhen(left.toLowerCase()) : left,
          onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
        ),
      );
    }
    final sumMinor = ahead.fold(0, (a, i) => a + i.amountMinor);
    final sum = l.money(Money(sumMinor, primary), approx: ahead.any((i) => i.subscription.currency != primary));
    return UpcomingSection(
      summary: ahead.isEmpty ? l.homeNext30None : l.homeNext30(sum, ahead.length),
      summaryBold: ahead.isEmpty ? null : sum,
      items: items,
      onSeeAll: () => context.go(AppRoutes.calendar),
    );
  }

  Widget? _budget(BuildContext context, String primary) {
    final l = context.l10n;
    final usage = ref.watch(budgetUsageProvider);
    final total = usage.where((u) => u.budget.isTotal && u.ratio != null).firstOrNull;
    if (total == null) return null;
    final cats = ref.watch(categoryByIdProvider);
    final over = [
      for (final u in usage)
        if (!u.budget.isTotal && u.isOver)
          if (cats[u.budget.categoryId] case final cat?) l.categoryName(cat),
    ];
    final limitMajor = total.limit!;
    final limit = l.amount(limitMajor, primary).replaceAll(RegExp(r'[.,]00(?=\D*$)'), '');
    return BudgetCard(
      ratio: total.ratio!,
      spentOfLimit: l.homeBudgetOf(l.amount(total.spent, primary), limit),
      overLine: over.isEmpty ? null : l.homeBudgetOver(over.length, over.join(', ')),
      onTap: () => context.push(AppRoutes.settingsBudgets),
    );
  }

  List<Widget> _listSection(
    BuildContext context,
    List<Subscription> all,
    LocalDate today,
    String primary,
    SpendingCalculator calc,
  ) {
    final l = context.l10n;
    final c = context.colors;
    Widget pad(Widget w) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      child: w,
    );
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
    // 360dp: counts are dropped from the tabs (design `.s360 .seg4 em`).
    final showCounts = MediaQuery.sizeOf(context).width >= 380;
    int? count(HomeTab t) => showCounts ? counts[t] : null;
    final savings = ref.watch(spendingSummaryProvider)?.savingsYearly ?? 0;
    final savingsText = l.amount(
      savings,
      primary,
      approx: anyConverted(all.where((s) => tabOf(s, today) == HomeTab.cancelled), primary),
    );
    return [
      pad(
        Padding(
          key: _listKey,
          padding: const EdgeInsets.only(top: AppSpace.s5),
          child: ListHeader(
            title: l.homeSubscriptions,
            onSearch: () => setState(() => _searching = true),
            onFilter: () => _openFilter(all, today),
            filterCount: filter.count,
            filterLabel: l.homeFilterButtonLabel(filter.count),
            onSort: () => showSortSheet(context, current: _sort, onChanged: _setSort),
            sortLabel: l.homeSortLabel(sortLabel(l, _sort)),
          ),
        ),
      ),
      pad(
        AppSegmentedControl<HomeTab>(
          selected: _tab,
          onChanged: (t) => setState(() => _tab = t),
          segments: [
            AppSegment(value: HomeTab.active, label: l.homeTabActive, count: count(HomeTab.active)),
            AppSegment(value: HomeTab.trials, label: l.homeTabTrials, count: count(HomeTab.trials)),
            AppSegment(value: HomeTab.paused, label: l.homeTabPaused, count: count(HomeTab.paused)),
            AppSegment(value: HomeTab.cancelled, label: l.homeTabCancelled, count: count(HomeTab.cancelled)),
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
      if (_tab == HomeTab.cancelled && savings > 0)
        pad(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SavingsHead(text: l.homeSavingYear(savingsText), amount: savingsText),
          ),
        ),
      pad(
        list.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s5),
                child: Text(
                  !filter.isEmpty
                      ? l.homeEmptyFiltered
                      : switch (_tab) {
                          HomeTab.active => l.homeEmptyActive,
                          HomeTab.trials => l.homeEmptyTrials,
                          HomeTab.paused => l.homeEmptyPaused,
                          HomeTab.cancelled => l.homeEmptyCancelled,
                        },
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
              )
            : AppGroup(children: [for (final s in list) _row(context, s, today, primary, calc)]),
      ),
      if (_tab == HomeTab.trials && list.isNotEmpty)
        pad(
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s2, AppSpace.s1, 0),
            child: Text(l.homeTrialsNote, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        ),
    ];
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
    final labels = ref.watch(labelsProvider).value ?? const <Label>[];
    final methods = {for (final x in ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[]) x.id: x};
    final rose = ref.watch(recentlyIncreasedIdsProvider).contains(s.id);
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
      meta: rowMeta(l, s, today, categories: ref.watch(categoryByIdProvider), methods: methods),
      serviceId: s.serviceId,
      customLogoFile: s.customLogoFile,
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
      cycle: s.cycle,
      priceRiseLabel: rose && state != SubscriptionRowState.cancelled ? l.homeRise : null,
      onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
      onConfirm: () => context.push(AppRoutes.confirm(s.id)),
      onCancel: state == SubscriptionRowState.cancelled ? null : () => markCancelledFlow(context, ref, s),
    );
  }

  // ---- Search (png 029) ----------------------------------------------------------------------

  Widget _searchBody(BuildContext context, List<Subscription> all, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final region = ref.watch(catalogRegionProvider);
    final q = _query.text.trim();
    final results = search(all, q);
    final nq = normalizeForSearch(q);
    final owned = {for (final s in all) ?s.serviceId};
    final library = nq.isEmpty
        ? const <CatalogService>[]
        : (ref.watch(catalogProvider).value ?? const <CatalogService>[])
              .where((s) => !owned.contains(s.id) && normalizeForSearch(s.name).contains(nq))
              .take(3)
              .toList();
    Widget eyebrow(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s4, AppSpace.s1, AppSpace.s2),
      child: Semantics(
        header: true,
        child: Text(text.toUpperCase(), style: AppType.caption.copyWith(color: c.inkMuted)),
      ),
    );
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
                  prefixIcon: Icon(AppIcons.search, size: 18, color: c.inkMuted),
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
            Semantics(
              label: l.homeSearchClose,
              excludeSemantics: true,
              button: true,
              onTap: _closeSearch,
              child: TextButton(onPressed: _closeSearch, child: Text(l.homeSearchCancel)),
            ),
          ],
        ),
        if (q.isNotEmpty && results.isEmpty && library.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s6),
            child: Text(
              l.homeSearchEmpty(q),
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: c.inkMuted),
            ),
          ),
        if (results.isNotEmpty) ...[
          eyebrow(l.homeSearchYours),
          AppGroup(children: [for (final s in results) _row(context, s, today, primary, calc)]),
        ],
        if (library.isNotEmpty) ...[
          eyebrow(l.homeSearchLibrary),
          AppGroup(
            children: [
              for (final s in library)
                _LibraryRow(
                  service: s,
                  meta: CatalogView.rowMeta(l, s, region),
                  onTap: () => context.push(AppRoutes.subscriptionNew(serviceId: s.id)),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// A library service in the search results (`libRow`): logo, name, "from $17.99/month · 4 plans", +.
class _LibraryRow extends StatelessWidget {
  const _LibraryRow({required this.service, required this.meta, required this.onTap});

  final CatalogService service;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSize.rowH),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 12),
              child: Row(
                children: [
                  ServiceTile(
                    name: service.name,
                    colorValue: service.colorValue,
                    iconText: service.monogram,
                    serviceId: service.id,
                  ),
                  const SizedBox(width: AppSpace.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          service.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.titleSm.copyWith(color: c.ink),
                        ),
                        const SizedBox(height: 2),
                        Text(meta, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpace.s2),
                  Icon(AppIcons.add, size: 20, color: c.brand),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
