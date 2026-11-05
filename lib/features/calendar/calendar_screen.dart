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

/// S8 Calendar (design png 41 month, 42 past month, 43 agenda).
///
/// Header: month navigator + Month/Agenda toggle (drops under the month name when there is no
/// room), month total — past months total the Payments made, the current and later months add the
/// periods still expected. Month view: [MonthGrid] + the selected day's entries. Agenda: the
/// month's entries in sections. Numbers come from [CalendarMonth] (lib/domain/stats).
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
            pad(_MonthTotal(month: month, primary: calc.primaryCurrency)),
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
          children: [
            for (final e in entries)
              CalendarEntryRow(
                entry: e,
                today: month.today,
                onTap: () => _open(e),
                onConfirm: () => context.push(AppRoutes.confirm(e.subscription.id)),
              ),
          ],
        ),
    ];
  }

  List<Widget> _agenda(BuildContext context, CalendarMonth month, CalendarMonth? next) {
    final l = context.l10n;
    final groups = month.agenda(next: next);
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

class _MonthTotal extends StatelessWidget {
  const _MonthTotal({required this.month, required this.primary});

  final CalendarMonth month;
  final String primary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final muted = AppType.meta.copyWith(color: c.inkMuted);
    final parts = <String>[];
    if (month.entries.isEmpty) {
      parts.add(l.calendarCountPayments(0));
    } else if (month.isPast) {
      parts.add(l.calendarCountPaid(month.paidCount));
      if (month.skippedCount > 0) parts.add(l.calendarCountSkipped(month.skippedCount));
      if (month.awaitingCount > 0) parts.add(l.calendarCountToConfirm(month.awaitingCount));
    } else {
      parts.add(l.calendarCountPayments(month.paymentCount));
      if (month.awaitingCount > 0) parts.add(l.calendarCountToConfirm(month.awaitingCount));
    }
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s2, bottom: AppSpace.s3),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(month.isPast ? l.calPaidIn(month.month) : l.calMonthTotal(month.month), style: muted),
            Text(
              l.amount(month.total, primary, approx: month.approx),
              semanticsLabel: l.spokenLabel(l.amount(month.total, primary, approx: month.approx)),
              style: AppType.title.copyWith(color: c.ink).tabular,
            ),
            Text(parts.join(' · '), style: muted),
            if (month.missingRates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(l.calendarMissingRates((month.missingRates.toList()..sort()).join(', ')), style: muted),
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
