import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../calendar/widgets/calendar_labels.dart';
import 'widgets/insights_format.dart';

/// Mockup 084 — "View as list": every expected charge of the next 12 months by month, from real
/// Due dates (periods awaiting confirmation first), each with its amount and cycle chip.
class ForecastListScreen extends StatelessWidget {
  const ForecastListScreen({super.key, required this.forecast});

  final YearForecast forecast;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final f = forecast;
    final byMonth = <LocalDate, List<ForecastItem>>{};
    for (final i in f.items) {
      final key = (i.isAwaiting(f.today) ? f.today : i.date).firstOfMonth;
      byMonth.putIfAbsent(key, () => []).add(i);
    }
    final months = byMonth.keys.toList()..sort();
    final total = l.minor(f.nextMinor, f.currency, approx: true);
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppTopBar(title: l.insightsNext12),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s6),
        children: [
          MergeSemantics(
            child: Column(
              children: [
                Text(
                  total,
                  semanticsLabel: l.spokenLabel(total),
                  style: AppType.title.copyWith(fontSize: 28, height: 34 / 28, color: c.ink).tabular,
                ),
                const SizedBox(height: 4),
                Text(
                  l.insightsForecastCount(f.items.length),
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
              ],
            ),
          ),
          for (final m in months) ...[
            _MonthHeader(
              title: l.statsMonthYear(m),
              total: l.minor(byMonth[m]!.fold(0, (a, i) => a + i.amountMinor), f.currency),
            ),
            AppGroup(
              dividerIndent: 100,
              children: [for (final i in byMonth[m]!) _ItemRow(item: i, today: f.today)],
            ),
          ],
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.title, required this.total});

  final String title;
  final String total;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = AppType.caption.copyWith(color: c.inkMuted);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s6, AppSpace.s1, AppSpace.s2),
      child: Semantics(
        header: true,
        child: Row(
          children: [
            Expanded(child: Text(title.toUpperCase(), style: style)),
            Text(total, style: style.copyWith(color: c.ink).tabular),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.today});

  final ForecastItem item;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = item.subscription;
    final awaiting = item.isAwaiting(today);
    final amount = l.minor(item.amountMinor, item.currency);
    return InkWell(
      onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSize.rowH),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Text(
                      '${item.date.day}',
                      style: AppType.titleSm.copyWith(fontWeight: FontWeight.w700, height: 1.1, color: c.ink).tabular,
                    ),
                    Text(
                      l.calWeekday(DateTime.utc(item.date.year, item.date.month, item.date.day).weekday),
                      style: AppType.caption.copyWith(color: c.inkMuted, letterSpacing: 0, height: 1.2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              ServiceTile(
                name: s.name,
                colorValue: s.colorValue,
                iconText: s.iconText,
                size: 32,
                awaiting: awaiting,
                serviceId: s.serviceId,
                customLogoFile: s.customLogoFile,
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.titleSm.copyWith(color: c.ink),
                    ),
                    const SizedBox(height: 3),
                    if (awaiting)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: StatusBadge.awaiting(label: l.commonStatusAwaiting),
                      )
                    else
                      Text(
                        AppDates.relative(l, item.date, today: today),
                        style: AppType.meta.copyWith(color: c.inkMuted),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    amount,
                    semanticsLabel: l.spokenLabel(amount),
                    style: AppType.titleSm.copyWith(color: c.ink).tabular,
                  ),
                  const SizedBox(height: 2),
                  CycleChip(cycle: s.cycle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
