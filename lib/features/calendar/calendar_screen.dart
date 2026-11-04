import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S8 Calendar — PLACEHOLDER UI (agenda list per month). Owned by the Calendar & insights session (I).
/// Data comes from [CalendarBuilder.entries] (paid / skipped / awaiting / upcoming).
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  int _offset = 0; // months from the current month

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final today = ref.watch(todayProvider);
    final subs = ref.watch(subscriptionsProvider).value ?? const <Subscription>[];
    final periods = ref.watch(periodsProvider).value ?? const <ConfirmedPeriod>[];
    final calc = ref.watch(spendingCalculatorProvider);
    final primary = ref.watch(primaryCurrencyProvider);

    final month = today.firstOfMonth.addMonths(_offset);
    final end = month.addMonths(1).addDays(-1);
    final entries = CalendarBuilder.entries(
      subscriptions: subs,
      periods: periods,
      from: month,
      to: end,
      today: today,
    );
    final total = calc.actualInMonth(periods, month) + calc.projectedInMonth(subs, month);

    return Scaffold(
      appBar: AppBar(title: Text(l.commonTabCalendar)),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.chevron_left), onPressed: () => setState(() => _offset--)),
              Expanded(
                child: Column(
                  children: [
                    Text(_monthTitle(context, month), style: Theme.of(context).textTheme.titleMedium),
                    Text(l.calendarMonthTotal(l.amount(total, primary, approx: true))),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => setState(() => _offset++)),
            ],
          ),
          const Divider(),
          Expanded(
            child: entries.isEmpty
                ? Center(child: Text(l.calendarEmpty))
                : ListView(
                    children: [
                      for (final e in entries)
                        ListTile(
                          leading: ServiceTile(
                            name: e.subscription.name,
                            colorValue: e.subscription.colorValue,
                            iconText: e.subscription.iconText,
                            size: 32,
                          ),
                          title: Text(e.subscription.name),
                          subtitle: Text('${l.date(e.date)} · ${_kind(context, e.kind)}'),
                          trailing: Text(
                            e.kind == CalendarEntryKind.skipped
                                ? '—'
                                : l.money(e.period?.amount ?? e.subscription.myShare),
                          ),
                          onTap: () => context.push(AppRoutes.subscriptionDetail(e.subscription.id)),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _monthTitle(BuildContext context, LocalDate month) =>
      MaterialLocalizations.of(context).formatMonthYear(DateTime(month.year, month.month));

  String _kind(BuildContext context, CalendarEntryKind k) {
    final l = context.l10n;
    return switch (k) {
      CalendarEntryKind.paid => l.calendarPaid,
      CalendarEntryKind.skipped => l.calendarSkipped,
      CalendarEntryKind.awaiting => l.commonStatusAwaiting,
      CalendarEntryKind.upcoming => l.calendarUpcoming,
    };
  }
}
