import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S9 Insights — PLACEHOLDER UI (numbers as text; charts with fl_chart come with the
/// Calendar & insights session (I)). All maths is in [SpendingCalculator].
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final subs = ref.watch(subscriptionsProvider).value ?? const <Subscription>[];
    final periods = ref.watch(periodsProvider).value ?? const <ConfirmedPeriod>[];
    final today = ref.watch(todayProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final primary = ref.watch(primaryCurrencyProvider);
    final summary = ref.watch(spendingSummaryProvider);
    String money(double v) => l.amount(v, primary, approx: true);

    if (subs.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.commonTabInsights)),
        body: Center(child: Text(l.insightsEmpty)),
      );
    }

    final thisMonth = today.firstOfMonth;
    final actual = calc.actualInMonth(periods, thisMonth);
    final projected = calc.projectedInMonth(subs, thisMonth);
    final lastMonthActual = calc.actualInMonth(periods, thisMonth.addMonths(-1));
    final series = calc.monthlySeries(subs, periods, thisMonth);
    final categories = calc.byCategory(subs, today);
    final catTotal = categories.fold<double>(0, (a, e) => a + e.value);
    final top = calc.top(subs, today);

    return Scaffold(
      appBar: AppBar(title: Text(l.commonTabInsights)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(l.insightsThisMonth),
          Text(l.insightsActualVsProjected(money(actual), money(projected))),
          Text(l.insightsLastMonth(money(lastMonthActual))),
          _Section(l.insightsTwelveMonths),
          for (final m in series)
            Text('${m.month.month.toString().padLeft(2, '0')}/${m.month.year}: ${money(m.actual)} · ${money(m.projected)}'),
          _Section(l.insightsByCategory),
          for (final e in categories)
            Text('${l.category(e.key)}: ${money(e.value)} (${catTotal == 0 ? 0 : (e.value / catTotal * 100).round()}%)'),
          _Section(l.insightsTop),
          for (final (s, cost) in top) Text('${s.name}: ${money(cost)}/${l.commonUnitMonth}'),
          if (summary != null && summary.cancelledCount > 0) ...[
            _Section(l.insightsSavingsTitle),
            Text(l.insightsSavings(money(summary.savingsYearly), summary.cancelledCount)),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 6),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
