import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../domain/stats/insights_stats.dart';

/// Sheet opened from a donut slice (design png 47): colour bar + category, its share and monthly
/// total, the Active subscriptions in it (own price per cycle), a note when some are not billed
/// monthly, Close.
Future<void> showCategorySheet(
  BuildContext context, {
  required CategorySlice slice,
  required LocalDate today,
  required String currency,
  bool approx = false,
}) {
  return showAppSheet<void>(
    context,
    bare: true,
    builder: (ctx) => CategorySheet(slice: slice, today: today, currency: currency, approx: approx),
  );
}

class CategorySheet extends StatelessWidget {
  const CategorySheet({
    super.key,
    required this.slice,
    required this.today,
    required this.currency,
    this.approx = false,
  });

  final CategorySlice slice;
  final LocalDate today;
  final String currency;
  final bool approx;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final subs = [for (final (s, _) in slice.subscriptions) s];
    final notMonthly = subs.where((s) => s.cycle != const BillingCycle.monthly()).toList();
    final note = switch (notMonthly.length) {
      0 => null,
      1 => l.insightsCycleNoteOne(
        notMonthly.single.name,
        '${l.money(notMonthly.single.myShare)}${perCycle(l, notMonthly.single.cycle)}',
      ),
      _ => l.insightsCycleNoteMany,
    };

    void open(Subscription s) {
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push(AppRoutes.subscriptionDetail(s.id));
    }

    return AppSheet(
      actions: [AppButton.tonal(label: l.commonClose, expand: true, onPressed: () => Navigator.of(context).pop())],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MergeSemantics(
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.chartFor(slice.category),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: AppSpace.s3),
                  Expanded(
                    // The amount sits beside the title; it drops under it only when it would take
                    // more than half the line (360dp, large text).
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final title = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Semantics(
                              header: true,
                              child: Text(l.category(slice.category), style: AppType.title.copyWith(color: c.ink)),
                            ),
                            Text(
                              l.insightsCategoryShare((slice.share * 100).round()),
                              style: AppType.meta.copyWith(color: c.inkMuted),
                            ),
                          ],
                        );
                        final amount = Text.rich(
                          TextSpan(
                            text: l.amount(slice.monthly, currency, approx: approx),
                            style: AppType.title.copyWith(color: c.ink).tabular,
                            children: [
                              TextSpan(
                                text: l.insightsPerMonthShort,
                                style: AppType.meta.copyWith(color: c.inkMuted),
                              ),
                            ],
                          ),
                          semanticsLabel: l.spokenLabel(
                            '${l.amount(slice.monthly, currency, approx: approx)}${l.insightsPerMonthShort}',
                          ),
                        );
                        final amountWidth = (TextPainter(
                          text: amount.textSpan,
                          textDirection: TextDirection.ltr,
                          textScaler: MediaQuery.textScalerOf(context),
                        )..layout()).width;
                        if (amountWidth > box.maxWidth * .55) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title,
                              const SizedBox(height: AppSpace.s1),
                              amount,
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: title),
                            const SizedBox(width: AppSpace.s2),
                            amount,
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: Border.all(color: c.line),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, s) in subs.indexed) ...[
                      if (i > 0) Divider(height: 1, thickness: 1, indent: 68, color: c.line),
                      Material(
                        color: c.surfaceSheet,
                        child: SubscriptionRow(
                          name: s.name,
                          colorValue: s.colorValue,
                          iconText: s.iconText,
                          state: BillingRules.isAwaitingConfirmation(s, today)
                              ? SubscriptionRowState.awaiting
                              : SubscriptionRowState.normal,
                          awaitingCount: BillingRules.pendingDueDates(s, today).length,
                          sharedCount: s.sharedWith,
                          meta: '${AppDates.relative(l, s.dueDate, today: today)} · ${l.category(s.category)}',
                          amount: l.money(s.myShare),
                          amountMeta: perCycle(l, s.cycle),
                          onTap: () => open(s),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (note != null) ...[
              const SizedBox(height: AppSpace.s3),
              Text(note, style: AppType.meta.copyWith(color: c.inkMuted)),
            ],
          ],
        ),
      ),
    );
  }
}
