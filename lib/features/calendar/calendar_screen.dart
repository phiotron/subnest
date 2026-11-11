import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../domain/stats/calendar_month.dart';
import 'widgets/calendar_labels.dart';
import 'widgets/entry_row.dart';
import 'widgets/month_grid.dart';

/// Month grid or Agenda list (S8 toggle).
enum CalendarView { month, agenda }

/// S8 Calendar (mockup v14: 071 month, 072 list, 073 past month).
///
/// Header: month navigator + Month/List toggle (drops under the month name when there is no
/// room), the month's real money ([MonthCashFlow]: Paid + Still to pay). Month view: [MonthGrid]
/// with mini logos + the selected day's rows (price + cycle chip). List: what is still ahead —
/// To confirm · This week · Later this month · next month. Entries come from [CalendarMonth].
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key, this.initialView = CalendarView.month, this.initialMonthOffset = 0});

  /// For tests / deep links; the tab opens on the current month grid.
  final CalendarView initialView;
  final int initialMonthOffset;

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late int _offset = widget.initialMonthOffset; // months from today's month
  late CalendarView _view = widget.initialView;
  int? _selectedDay; // null = default for the month

  void _goMonth(int delta) => setState(() {
    _offset += delta;
    _selectedDay = null;
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final today = ref.watch(todayProvider);
    final subs = ref.watch(subscriptionsProvider).value ?? const <Subscription>[];
    final periods = ref.watch(periodsProvider).value ?? const <ConfirmedPeriod>[];
    final calc = ref.watch(spendingCalculatorProvider);

    CalendarMonth build(LocalDate m) => CalendarMonth.build(
      subscriptions: subs,
      periods: periods,
      month: m,
      today: today,
      rates: calc.rates,
      primaryCurrency: calc.primaryCurrency,
    );

    final month = build(today.firstOfMonth.addMonths(_offset));
    final selected = _selectedDay ?? _defaultDay(month);

    // Keep every day cell ≥ 48dp wide (S-50): below 380dp the grid card narrows its gutter
    // (6dp at 360) instead of shrinking the cells.
    final width = MediaQuery.sizeOf(context).width;
    final gridGutter = ((width - 12 - 7 * 48) / 2).clamp(4.0, AppSpace.s4);
    Widget pad(Widget w) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
      child: w,
    );

    return Scaffold(
      backgroundColor: c.bg,
      floatingActionButton: AppFab(onPressed: () => context.push(AppRoutes.catalog), tooltip: l.coreAddSubscription),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpace.s4 + AppSize.fabSize + AppSpace.s6),
          children: [
            pad(LargeTitle(title: l.commonTabCalendar)),
            const SizedBox(height: AppSpace.s3),
            // The arrows' 44dp hit box hangs 10dp into the left gutter (design `.cal-nav { margin-left: -10px }`).
            Padding(
              padding: const EdgeInsets.only(left: AppSpace.s4 - 10, right: AppSpace.s4),
              child: _Toolbar(
                month: month.month,
                view: _view,
                onPrev: () => _goMonth(-1),
                onNext: () => _goMonth(1),
                onView: (v) => setState(() => _view = v),
              ),
            ),
            pad(_MonthTotal(month: month, cash: ref.watch(monthCashFlowProvider(month.month)))),
            if (_view == CalendarView.month) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: gridGutter),
                child: MonthGrid(
                  month: month,
                  selectedDay: selected,
                  onSelect: (d) => setState(() => _selectedDay = d),
                ),
              ),
              ..._dayList(context, month, selected).map(pad),
            ] else
              ..._agenda(context, month, month.isCurrent ? build(month.month.addMonths(1)) : null).map(pad),
          ],
        ),
      ),
    );
  }

  static int _defaultDay(CalendarMonth m) {
    if (m.isCurrent) return m.today.day;
    return m.entries.isEmpty ? 1 : m.entries.first.date.day;
  }

  void _open(CalendarEntry e) => context.push(AppRoutes.subscriptionDetail(e.subscription.id));

  List<Widget> _dayList(BuildContext context, CalendarMonth month, int day) {
    final l = context.l10n;
    final date = LocalDate(month.month.year, month.month.month, day);
    final when = AppDates.weekdayShort(l, date, today: month.today);
    final entries = month.onDay(day);
    return [
      SectionHeader(label: date == month.today ? l.calendarTodayPrefix(when) : when),
      if (entries.isEmpty)
        _EmptyCard(text: l.calendarNothingDue)
      else
        AppGroup(
          children: [for (final e in entries) CalendarEntryRow(entry: e, today: month.today, onTap: () => _open(e))],
        ),
    ];
  }

  List<Widget> _agenda(BuildContext context, CalendarMonth month, CalendarMonth? next) {
    final l = context.l10n;
    // The list is a timeline of what is still ahead: this month's Payments stay in the grid.
    final groups = month.agenda(next: next).where((g) => g.kind != AgendaGroupKind.earlier).toList();
    if (groups.isEmpty) return [const SizedBox(height: AppSpace.s3), _EmptyCard(text: l.calendarEmpty)];
    String title(AgendaGroupKind k) => switch (k) {
      AgendaGroupKind.toConfirm => l.commonStatusAwaiting,
      AgendaGroupKind.thisWeek => l.calendarGroupThisWeek,
      AgendaGroupKind.later => l.calGroupLater(month.month),
      AgendaGroupKind.earlier => l.calGroupEarlier(month.month),
      AgendaGroupKind.nextMonth => l.calMonthName(month.month.addMonths(1)),
      AgendaGroupKind.month => l.calMonthName(month.month),
    };
    return [
      for (final (i, g) in groups.indexed) ...[
        SectionHeader(
          label: title(g.kind),
          padding: i == 0 ? const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s3, AppSpace.s1, AppSpace.s2) : null,
        ),
        AppGroup(
          children: [
            for (final e in g.entries)
              CalendarEntryRow(entry: e, today: month.today, showDate: true, onTap: () => _open(e)),
          ],
        ),
      ],
    ];
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.month,
    required this.view,
    required this.onPrev,
    required this.onNext,
    required this.onView,
  });

  final LocalDate month;
  final CalendarView view;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<CalendarView> onView;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    // Month name + arrows, then the toggle; the toggle wraps under when there's no room
    // (design README › Content fundamentals).
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpace.s2,
      runSpacing: AppSpace.s1,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(icon: AppIcons.back, tooltip: l.corePrevMonth, size: 22, onPressed: onPrev),
            Flexible(
              child: Semantics(
                liveRegion: true,
                header: true,
                child: Text(l.calMonthYear(month), style: AppType.titleSm.copyWith(color: c.ink)),
              ),
            ),
            AppIconButton(icon: AppIcons.next, tooltip: l.coreNextMonth, size: 22, onPressed: onNext),
          ],
        ),
        AppSegmentedControl<CalendarView>(
          mini: true,
          segments: [
            AppSegment(value: CalendarView.month, label: l.calendarViewMonth),
            AppSegment(value: CalendarView.agenda, label: l.calendarViewAgenda),
          ],
          selected: view,
          onChanged: onView,
        ),
      ],
    );
  }
}

/// "November:" · "≈ $116.57" — the real money leaving in the month (Paid + Still to pay, product.md
/// §4.8, the same [MonthCashFlow] as Insights) · "2 paid · 5 to come" (past months: "5 paid").
class _MonthTotal extends StatelessWidget {
  const _MonthTotal({required this.month, required this.cash});

  final CalendarMonth month;
  final MonthCashFlow? cash;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final muted = AppType.meta.copyWith(color: c.inkMuted);
    final parts = <String>[];
    if (month.entries.isEmpty) {
      parts.add(l.calendarCountPayments(0));
    } else {
      parts.add(l.calendarCountPaid(month.paidCount));
      if (month.skippedCount > 0) parts.add(l.calendarCountSkipped(month.skippedCount));
      final ahead = month.awaitingCount + month.upcomingCount;
      if (ahead > 0) parts.add(l.calendarToCome(ahead));
    }
    final cash = this.cash;
    final total = cash == null
        ? l.amount(month.total, month.currency, approx: true)
        : l.money(Money(cash.totalMinor, cash.currency), approx: true);
    final missing = {...month.missingRates, ...?cash?.missingRates}.toList()..sort();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s2, bottom: AppSpace.s3),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.calMonthColon(month.month), style: muted),
            Text(
              total,
              semanticsLabel: l.spokenLabel(total),
              style: AppType.title.copyWith(color: c.ink).tabular,
            ),
            Text(parts.join(' · '), style: muted),
            if (missing.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(l.calendarMissingRates(missing.join(', ')), style: muted),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s5),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppType.meta.copyWith(color: context.colors.inkMuted),
    ),
  );
}
