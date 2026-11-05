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
/// "Then ₫59,000/month from Fri, 6 Nov", actions "How to cancel" (tonal, external) and "Keep it".
class TrialEndingCard extends StatelessWidget {
  const TrialEndingCard({
    super.key,
    required this.subscription,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onHowToCancel,
    required this.onKeep,
  });

  final Subscription subscription;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onHowToCancel;
  final VoidCallback onKeep;

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
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, trial: true),
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
          const SizedBox(height: AppSpace.s1),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 40 + AppSpace.s3 - 4),
            child: Wrap(
              spacing: AppSpace.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton.tonal(label: l.homeHowToCancel, icon: AppIcons.external, small: true, onPressed: onHowToCancel),
                AppButton.text(label: l.homeKeepIt, small: true, onPressed: onKeep),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One "Upcoming · 7 days" card: tile, name, "Fri, 6 Nov · in 2 days", amount + sub-line.
class UpcomingCard extends StatelessWidget {
  const UpcomingCard({
    super.key,
    required this.subscription,
    required this.when,
    required this.amount,
    required this.amountMeta,
    required this.onTap,
  });

  final Subscription subscription;
  final String when;
  final String amount;
  final String amountMeta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = subscription;
    return MergeSemantics(
      child: Semantics(
        button: true,
        child: AppCard(
          onTap: onTap,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText),
              const SizedBox(height: 10),
              Text(s.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppType.titleSm.copyWith(color: c.ink)),
              Text(when, style: AppType.meta.copyWith(color: c.inkMuted)),
              const SizedBox(height: 10),
              // Amounts never wrap between digits: they shrink to fit instead.
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(amount, maxLines: 1, softWrap: false, style: AppType.titleSm.copyWith(color: c.ink).tabular),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(amountMeta, semanticsLabel: context.l10n.spokenLabel(amountMeta), maxLines: 1, softWrap: false, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal strip of [UpcomingCard]s, two per screen width, equal heights.
class UpcomingStrip extends StatelessWidget {
  const UpcomingStrip({super.key, required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    // ≥ 150% text: wider cards (one and a bit per screen, scrolls) so names and amounts fit.
    final large = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    return LayoutBuilder(
      builder: (context, box) {
        final w = large ? box.maxWidth * .78 : (box.maxWidth - AppSpace.s3) / 2;
        final row = IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpace.s3),
                SizedBox(width: w, child: cards[i]),
              ],
            ],
          ),
        );
        if (cards.length <= (large ? 1 : 2)) return Align(alignment: AlignmentDirectional.centerStart, child: row);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: row,
        );
      },
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

/// "↑↓ Due date" sort button (label `ink-muted`, ≥ 48dp).
class SortButton extends StatelessWidget {
  const SortButton({super.key, required this.label, required this.semanticLabel, required this.onPressed});

  final String label;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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
                Icon(AppIcons.sort, size: 16, color: c.inkMuted),
                const SizedBox(width: 6),
                Text(label, maxLines: 1, softWrap: false, style: AppType.label.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
