import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S2 Home — PLACEHOLDER UI (functional, unstyled). Owned by the Home & confirm session (G).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

enum _Sort { dueDate, price, name }

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _yearly = false;
  SubscriptionStatus _tab = SubscriptionStatus.active;
  _Sort _sort = _Sort.dueDate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final subs = ref.watch(subscriptionsProvider);
    final summary = ref.watch(spendingSummaryProvider);
    final today = ref.watch(todayProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final rates = ref.watch(ratesProvider).value;
    final notificationsOn = ref.watch(notificationsEnabledProvider).value ?? true;

    return Scaffold(
      appBar: AppBar(title: Text(l.commonAppName)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.homeAdd,
        onPressed: () => context.push(AppRoutes.catalog),
        child: const Icon(Icons.add),
      ),
      body: subs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (all) {
          if (all.isEmpty) return _Empty();
          final list = all.where((s) => BillingRules.effectiveStatus(s, today) == _tab).toList()
            ..sort(switch (_sort) {
              _Sort.dueDate => (a, b) => a.dueDate.compareTo(b.dueDate),
              _Sort.price => (a, b) => (calc.monthlyCost(b) ?? 0).compareTo(calc.monthlyCost(a) ?? 0),
              _Sort.name => (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            });
          final trialsEnding = all.where((s) {
            if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.trial) return false;
            return BillingRules.daysUntilDue(s, today) <= 7;
          }).toList();
          final upcoming = CalendarBuilder.upcoming(subscriptions: all, today: today);

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              // 1. Total header
              if (summary != null)
                InkWell(
                  onTap: () => setState(() => _yearly = !_yearly),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.amount(_yearly ? summary.yearly : summary.monthly, primary, approx: true),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(_yearly ? l.commonPerYear : l.commonPerMonth),
                        const SizedBox(height: 4),
                        Text(l.homeCounts(summary.activeCount, summary.trialCount)),
                        if (summary.trialMonthly > 0)
                          Text(l.homeTrialSoon(l.amount(summary.trialMonthly, primary, approx: true))),
                        if (rates != null) Text(_ratesLine(context, rates), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              // Reminders disabled banner
              if (!notificationsOn)
                MaterialBanner(
                  content: Text(l.homeNotificationsOff),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await ref.read(notificationServiceProvider).requestPermission();
                        ref.invalidate(notificationsEnabledProvider);
                      },
                      child: Text(l.homeEnable),
                    ),
                  ],
                ),
              // 2. Awaiting confirmation card
              if (summary != null && summary.awaitingCount > 0)
                Card(
                  color: AppTheme.warning.withValues(alpha: 0.15),
                  child: ListTile(
                    leading: const Icon(Icons.pending_actions),
                    title: Text(l.homeAwaiting(summary.awaitingCount)),
                    trailing: TextButton(onPressed: () => context.push(AppRoutes.awaiting), child: Text(l.homeView)),
                  ),
                ),
              // 3. Trials ending soon
              for (final t in trialsEnding)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.hourglass_bottom),
                    title: Text(l.homeTrialEnding(t.name, BillingRules.daysUntilDue(t, today))),
                    trailing: TextButton(
                      onPressed: () => context.push(AppRoutes.subscriptionDetail(t.id)),
                      child: Text(l.homeHowToCancel),
                    ),
                  ),
                ),
              // 4. Upcoming 7 days
              if (upcoming.isNotEmpty) ...[
                _Header(l.homeUpcoming),
                for (final e in upcoming)
                  ListTile(
                    dense: true,
                    leading: ServiceTile(
                      name: e.subscription.name,
                      colorValue: e.subscription.colorValue,
                      iconText: e.subscription.iconText,
                      size: 24,
                    ),
                    title: Text(e.subscription.name),
                    subtitle: Text(l.commonDaysLeft(today.daysUntil(e.date))),
                    trailing: Text(l.money(e.subscription.myShare)),
                    onTap: () => context.push(AppRoutes.subscriptionDetail(e.subscription.id)),
                  ),
              ],
              // 5. List with tabs + sort
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<SubscriptionStatus>(
                        segments: [
                          ButtonSegment(value: SubscriptionStatus.active, label: Text(l.homeTabActive)),
                          ButtonSegment(value: SubscriptionStatus.trial, label: Text(l.homeTabTrial)),
                          ButtonSegment(value: SubscriptionStatus.cancelled, label: Text(l.homeTabCancelled)),
                        ],
                        selected: {_tab},
                        onSelectionChanged: (s) => setState(() => _tab = s.first),
                      ),
                    ),
                    PopupMenuButton<_Sort>(
                      icon: const Icon(Icons.sort),
                      tooltip: l.homeSort,
                      onSelected: (s) => setState(() => _sort = s),
                      itemBuilder: (_) => [
                        PopupMenuItem(value: _Sort.dueDate, child: Text(l.homeSortDueDate)),
                        PopupMenuItem(value: _Sort.price, child: Text(l.homeSortPrice)),
                        PopupMenuItem(value: _Sort.name, child: Text(l.homeSortName)),
                      ],
                    ),
                  ],
                ),
              ),
              if (_tab == SubscriptionStatus.cancelled && summary != null && summary.savingsYearly > 0)
                Card(
                  color: AppTheme.success.withValues(alpha: 0.12),
                  child: ListTile(
                    leading: const Icon(Icons.savings_outlined),
                    title: Text(l.homeSavings(l.amount(summary.savingsYearly, primary, approx: true))),
                  ),
                ),
              if (list.isEmpty) Padding(padding: const EdgeInsets.all(24), child: Text(l.homeTabEmpty)),
              for (final s in list) _Row(sub: s, today: today, primary: primary, calc: calc),
            ],
          );
        },
      ),
    );
  }

  String _ratesLine(BuildContext context, ExchangeRates rates) {
    final l = context.l10n;
    final at = rates.fetchedAt;
    if (at == null) return l.homeRatesOffline;
    final days = DateTime.now().difference(at).inDays;
    return days >= 1 ? l.homeRatesStale(days) : l.homeRatesFresh;
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.sub, required this.today, required this.primary, required this.calc});

  final Subscription sub;
  final LocalDate today;
  final String primary;
  final SpendingCalculator calc;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final awaiting = BillingRules.isAwaitingConfirmation(sub, today);
    final cancelled = sub.status == SubscriptionStatus.cancelled;
    final converted = sub.currency == primary ? null : calc.periodCost(sub);
    final subtitle = [
      l.cycle(sub.cycle),
      l.category(sub.category),
      if (sub.isShared) l.commonSharedWith(sub.sharedWith),
      if (cancelled && sub.cancelledOn != null) l.homeCancelledOn(l.date(sub.cancelledOn!)),
    ].join(' · ');
    final days = BillingRules.daysUntilDue(sub, today);
    return Opacity(
      opacity: cancelled ? 0.6 : 1,
      child: ListTile(
        leading: ServiceTile(name: sub.name, colorValue: sub.colorValue, iconText: sub.iconText),
        title: Row(
          children: [
            Flexible(child: Text(sub.name, overflow: TextOverflow.ellipsis)),
            if (awaiting) ...[
              const SizedBox(width: 6),
              Chip(
                label: Text(l.commonStatusAwaiting),
                avatar: const Icon(Icons.priority_high, size: 16),
                backgroundColor: AppTheme.warning.withValues(alpha: 0.2),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
        subtitle: Text(subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(l.money(sub.myShare)),
            if (converted != null) Text(l.amount(converted, primary, approx: true), style: Theme.of(context).textTheme.bodySmall),
            if (!cancelled)
              Text(
                days < 0 ? l.commonDaysOverdue(-days) : l.commonDaysLeft(days),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        onTap: () => context.push(AppRoutes.subscriptionDetail(sub.id)),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 64),
            const SizedBox(height: 12),
            Text(l.homeEmpty, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: () => context.push(AppRoutes.catalog), child: Text(l.homeAddFirst)),
          ],
        ),
      ),
    );
  }
}
