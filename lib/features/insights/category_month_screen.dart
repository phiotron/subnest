import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import 'widgets/insights_cards.dart';
import 'widgets/insights_format.dart';

/// Mockup 083 — a donut slice tapped: the category's subscriptions in the selected month (or year),
/// with what each adds, "3 subscriptions · 22% of November", and a note when a pause starts later
/// in the month (it still counts).
class CategoryMonthScreen extends StatelessWidget {
  const CategoryMonthScreen({
    super.key,
    required this.categoryId,
    required this.categoryLabel,
    required this.color,
    required this.period,
    required this.periodInline,
    required this.lines,
    required this.periodTotalMinor,
    required this.currency,
    this.periodStart,
    this.periodEnd,
  });

  final String categoryId;
  final String categoryLabel;
  final Color color;

  /// "November" / "Tháng 11" / "2026".
  final String period;

  /// "November" / "tháng 11" / "2026" (inside a sentence).
  final String periodInline;

  /// This category's lines, biggest first.
  final List<SpendLine> lines;
  final int periodTotalMinor;
  final String currency;

  /// Pause notes are shown for pauses starting inside this span.
  final LocalDate? periodStart;
  final LocalDate? periodEnd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final total = lines.fold(0, (a, x) => a + x.amountMinor);
    final percent = periodTotalMinor == 0 ? 0 : (total / periodTotalMinor * 100).round();
    final pauses = [
      for (final x in lines)
        if (x.subscription.status == SubscriptionStatus.paused &&
            x.subscription.pausedFrom != null &&
            periodStart != null &&
            periodEnd != null &&
            !x.subscription.pausedFrom!.isBefore(periodStart!) &&
            !x.subscription.pausedFrom!.isAfter(periodEnd!))
          x.subscription,
    ];
    final totalText = l.minor(total, currency, approx: true);
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppTopBar(title: l.insightsCategoryTitle(categoryLabel, period)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s6),
        children: [
          MergeSemantics(
            child: Column(
              children: [
                CategoryIconTile(id: categoryId, color: color, size: 48),
                const SizedBox(height: 6),
                Text(
                  totalText,
                  semanticsLabel: l.spokenLabel(totalText),
                  style: AppType.title.copyWith(fontSize: 28, height: 34 / 28, color: c.ink).tabular,
                ),
                const SizedBox(height: 4),
                Text(
                  l.insightsCategoryShare(lines.length, percent, periodInline),
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s4),
          AppGroup(
            dividerIndent: 68,
            children: [
              for (final x in lines)
                () {
                  final s = x.subscription;
                  final amount = l.minor(x.amountMinor, currency);
                  return StatsRow(
                    onTap: () => context.push(AppRoutes.subscriptionDetail(s.id)),
                    label: l.spoken('${s.name}, ${l.money(s.myShare)} ${l.cycle(s.cycle)}, $amount'),
                    children: [
                      statsTile(s, size: 40),
                      const SizedBox(width: AppSpace.s3),
                      Expanded(
                        child: NameAndPrice(
                          name: s.name,
                          price: l.money(s.myShare),
                          cycle: s.cycle,
                          trailing: Text(amount, style: AppType.titleSm.copyWith(color: c.ink).tabular),
                        ),
                      ),
                    ],
                  );
                }(),
            ],
          ),
          for (final s in pauses)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s1),
              child: Text(
                l.insightsPauseNote(s.name, periodInline, l.date(s.pausedFrom!)),
                style: AppType.meta.copyWith(color: c.inkMuted),
              ),
            ),
        ],
      ),
    );
  }
}
