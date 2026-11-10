import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// S2 "2 payments to confirm" card: `warning-soft`, clock in a `surface` circle, amber sub-line
/// "₫215,000 · Viettel, Netflix", "Review" pill. The whole card is one button (≥ 48dp).
class AwaitingCard extends StatelessWidget {
  const AwaitingCard({super.key, required this.count, required this.subtitle, required this.onTap});

  final int count;

  /// "₫215,000 · Viettel, Netflix".
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    // ≥ 150% text: the "Review" pill goes under the text (real phone, 320dp at 200%: the title
    // wrapped one word per line and the amount broke between digits).
    final stacked = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    final pill = Container(
      key: const ValueKey('awaiting-review'),
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.center,
      decoration: ShapeDecoration(color: c.surface, shape: const StadiumBorder()),
      child: Text(
        l.homeAwaitingReview,
        maxLines: 1,
        softWrap: false,
        style: AppType.label.copyWith(color: c.warningInk),
      ),
    );
    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l.homeAwaitingTitle(count), style: AppType.titleSm.copyWith(color: c.ink)),
        const SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: stacked ? 3 : 2,
          overflow: TextOverflow.ellipsis,
          style: AppType.meta.copyWith(color: c.warningInk).tabular,
        ),
        if (stacked) ...[const SizedBox(height: AppSpace.s2), pill],
      ],
    );
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: AppCard(
          color: c.warningSoft,
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
          child: Row(
            crossAxisAlignment: stacked ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
                child: Icon(AppIcons.awaiting, size: 20, color: c.warningInk),
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(child: texts),
              if (!stacked) ...[const SizedBox(width: AppSpace.s3), pill],
            ],
          ),
        ),
      ),
    );
  }
}

/// S2 "Spotify trial ends in 2 days" card (`card-trial`): tile with hourglass badge, title +
/// "Then ₫59,000/month from Fri, 6 Nov", optional savings line ("Cancel before the first charge to
/// save ₫708,000 a year"), actions "Keep it" (primary), "View subscription" and "How to cancel"
/// (external; hidden without a link) — decision 2026-11-10 (2) #6.
class TrialEndingCard extends StatelessWidget {
  const TrialEndingCard({
    super.key,
    required this.subscription,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onHowToCancel,
    required this.onKeep,
    required this.onView,
    this.savings,
  });

  final Subscription subscription;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback? onHowToCancel;
  final VoidCallback onKeep;
  final VoidCallback onView;

  /// "Cancel before the first charge to save … a year" (null when the yearly cost is unknown).
  final String? savings;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final s = subscription;
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, trial: true, serviceId: s.serviceId, subscriptionId: s.id),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                  ],
                ),
              ),
            ],
          ),
          if (savings != null) ...[
            const SizedBox(height: AppSpace.s2),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 40 + AppSpace.s3),
              child: Text(
                savings!,
                style: AppType.meta.copyWith(color: c.warningInk, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const SizedBox(height: AppSpace.s1),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 40 + AppSpace.s3 - 4),
            child: Wrap(
              spacing: AppSpace.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton.primary(label: l.homeKeepIt, small: true, onPressed: onKeep),
                AppButton.text(label: l.homeViewSubscription, small: true, onPressed: onView),
                if (onHowToCancel != null)
                  AppButton.text(
                    label: l.homeHowToCancel,
                    icon: AppIcons.external,
                    small: true,
                    onPressed: onHowToCancel,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "You're saving ₫1,479,000/year" (`save-card`): `success-soft`, piggy-bank in a `surface` circle.
class SavingsCard extends StatelessWidget {
  const SavingsCard({super.key, required this.label, required this.amount});

  final String label;

  /// "₫1,479,000/year".
  final String amount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: AppCard(
        color: c.successSoft,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
              child: Icon(AppIcons.savings, size: 22, color: c.success),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label, style: AppType.meta.copyWith(color: c.success)),
                  Text(amount, style: AppType.title.copyWith(color: c.ink).tabular),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "↑↓ Due date" sort button / "⚙ Filter" button (label `ink-muted`, ≥ 48dp). With [active] the
/// label turns `brand` and [count] (> 0) shows as a small `brand` pill (png 17).
class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.onPressed,
    this.icon = AppIcons.sort,
    this.active = false,
    this.count = 0,
  });

  final String label;
  final String semanticLabel;
  final VoidCallback onPressed;
  final IconData icon;
  final bool active;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = active ? c.brand : c.inkMuted;
    return Semantics(
      // Own node: without it the button merges into the "Your subscriptions" heading next to it.
      container: true,
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      onTap: onPressed,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.min, minWidth: AppTouch.min),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: fg),
                const SizedBox(width: 6),
                Text(label, maxLines: 1, softWrap: false, style: AppType.label.copyWith(color: fg)),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(9)),
                    child: Text(
                      '$count',
                      style: AppType.caption.copyWith(letterSpacing: 0, fontSize: 11, color: c.onBrand),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
