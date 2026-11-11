import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'overview_cards.dart' show boldIn;

/// One card of the upcoming strip.
class UpcomingItem {
  const UpcomingItem({
    required this.subscription,
    required this.price,
    required this.when,
    required this.onTap,
    this.awaiting = false,
    this.today = false,
    this.onConfirm,
  });

  final Subscription subscription;

  /// My share in the subscription's own currency ("$17.99").
  final String price;

  /// "To confirm" / "3 days left" / "First charge · 3 days left".
  final String when;
  final bool awaiting;
  final bool today;
  final VoidCallback onTap;

  /// ✓ (awaiting or due today) → confirm sheet.
  final VoidCallback? onConfirm;
}

/// S2 "Upcoming payments" (png 013, `upcoming()`): heading + "See all", "Next 30 days: ≈ $116.57
/// in 7 charges", then a horizontal strip of 118px cards (logo, name, price, cycle chip, when) —
/// awaiting ones first in amber with a ✓, today's ringed in `brand`.
class UpcomingSection extends StatelessWidget {
  const UpcomingSection({
    super.key,
    required this.summary,
    required this.summaryBold,
    required this.items,
    required this.onSeeAll,
  });

  final String summary;
  final String? summaryBold;
  final List<UpcomingItem> items;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final scale = MediaQuery.textScalerOf(context).scale(10) / 10;
    final double cardW = 118 * math.min(math.max(scale, 1.0), 1.42);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(l.homeUpcomingTitle, style: AppType.titleSm.copyWith(color: c.ink)),
                ),
              ),
              TextButton(onPressed: onSeeAll, child: Text(l.homeSeeAll)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, 10),
          child: boldIn(
            summary,
            summaryBold,
            AppType.meta.copyWith(color: c.inkMuted),
            boldColor: c.ink,
            semanticsLabel: l.spokenLabel(summary),
          ),
        ),
        if (items.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(AppSpace.s4, 2, AppSpace.s4, 6),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    SizedBox(
                      width: cardW,
                      child: _UpcomingCard(item: items[i]),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.item});
  final UpcomingItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final s = item.subscription;
    final wait = item.awaiting;
    final radius = BorderRadius.circular(16);
    final border = wait
        ? Border.all(color: c.warning.withValues(alpha: 0.5))
        : item.today
        ? Border.all(color: c.brand, width: 2)
        : null;
    final card = Container(
      decoration: BoxDecoration(
        color: wait ? c.warningSoft : c.surface,
        borderRadius: radius,
        border: border,
        boxShadow: wait ? null : context.elevation.card,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ServiceTile(
                  name: s.name,
                  colorValue: s.colorValue,
                  iconText: s.iconText,
                  awaiting: wait,
                  trial: !wait && s.status == SubscriptionStatus.trial,
                  badgeRingColor: wait ? c.warningSoft : null,
                  serviceId: s.serviceId,
                  customLogoFile: s.customLogoFile,
                ),
                const SizedBox(height: 8),
                Text(
                  s.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppType.label.copyWith(color: c.ink, height: 18 / 14),
                ),
                const SizedBox(height: 4),
                Text(
                  item.price,
                  maxLines: 1,
                  softWrap: false,
                  style: AppType.titleSm.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: c.ink).tabular,
                ),
                const SizedBox(height: 4),
                CycleChip(cycle: s.cycle),
                const Spacer(),
                const SizedBox(height: 6),
                Text(
                  item.when,
                  style: AppType.caption.copyWith(
                    letterSpacing: 0,
                    fontWeight: wait ? FontWeight.w700 : FontWeight.w500,
                    color: wait ? c.warningInk : c.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (item.onConfirm == null) return card;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        card,
        PositionedDirectional(
          top: 2,
          end: 2,
          child: Semantics(
            button: true,
            label: l.homeMarkPaid(s.name),
            excludeSemantics: true,
            onTap: item.onConfirm,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: item.onConfirm,
              child: SizedBox(
                width: AppTouch.min,
                height: AppTouch.min,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
                    child: Icon(AppIcons.check, size: 18, color: c.onBrand),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// S2 budget card (png 013, `budgetBar()`): "Budget  $144.89 of $150  97% ›", an 8px bar (`brand`,
/// `warning` above 85%, `danger` over), and "1 category over budget: AI". Opens Budgets.
class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key, required this.ratio, required this.spentOfLimit, required this.onTap, this.overLine});

  final double ratio;

  /// "$144.89 of $150".
  final String spentOfLimit;
  final String? overLine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final over = ratio > 1;
    final near = !over && ratio > 0.85;
    final tone = over
        ? c.danger
        : near
        ? c.warningInk
        : c.ink;
    final fill = over
        ? c.danger
        : near
        ? c.warning
        : c.brand;
    final pct = '${(ratio * 100).round()}%';
    return Semantics(
      button: true,
      label: [l.homeBudgetTitle, l.spoken(spentOfLimit), l.homeBudgetUsed((ratio * 100).round()), ?overLine].join(', '),
      excludeSemantics: true,
      onTap: onTap,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, 12, AppSpace.s4, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpace.s2,
                    children: [
                      Text(l.homeBudgetTitle, style: AppType.label.copyWith(color: c.ink)),
                      Wrap(
                        spacing: AppSpace.s2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(spentOfLimit, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                          Text(
                            pct,
                            style: AppType.label.copyWith(fontWeight: FontWeight.w800, color: tone).tabular,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(AppIcons.next, size: 18, color: c.inkMuted),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 8,
                  child: Stack(
                    children: [
                      Positioned.fill(child: ColoredBox(color: c.surface2)),
                      FractionallySizedBox(
                        widthFactor: ratio.clamp(0.0, 1.0),
                        heightFactor: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (overLine != null) Text(overLine!, style: AppType.meta.copyWith(color: c.inkMuted)),
          ],
        ),
      ),
    );
  }
}
