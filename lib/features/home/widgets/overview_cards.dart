import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// [text] with the first occurrence of [bold] in w700/800 (mockup `<b>` inside meta lines).
/// [semanticsLabel]: what a screen reader says instead (e.g. `l10n.spokenLabel(text)` for "≈").
Widget boldIn(
  String text,
  String? bold,
  TextStyle style, {
  Color? boldColor,
  FontWeight weight = FontWeight.w700,
  String? semanticsLabel,
}) {
  final i = bold == null || bold.isEmpty ? -1 : text.indexOf(bold);
  if (i < 0) return Text(text, style: style, semanticsLabel: semanticsLabel);
  final b = style.copyWith(color: boldColor, fontWeight: weight).tabular;
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: text.substring(0, i)),
        TextSpan(text: bold, style: b),
        TextSpan(text: text.substring(i + bold!.length)),
      ],
    ),
    style: style,
    semanticsLabel: semanticsLabel,
  );
}

/// Logo stack (`avs`): 24px tiles overlapping by 6px, each ringed in [ring].
class LogoStack extends StatelessWidget {
  const LogoStack({super.key, required this.subscriptions, required this.ring, this.max = 4});

  final List<Subscription> subscriptions;
  final Color ring;
  final int max;

  @override
  Widget build(BuildContext context) {
    final shown = subscriptions.take(max).toList();
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < shown.length; i++)
            Transform.translate(
              offset: Offset(-6.0 * i, 0),
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(color: ring, borderRadius: BorderRadius.circular(AppRadius.tile24 + 2)),
                child: ServiceTile(
                  name: shown[i].name,
                  colorValue: shown[i].colorValue,
                  iconText: shown[i].iconText,
                  size: 24,
                  serviceId: shown[i].serviceId,
                  customLogoFile: shown[i].customLogoFile,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// S2 "1 payment to confirm" card (png 012/018, `pendingCard()`): `warning-soft`, clock in a
/// `surface` circle, logos of the waiting subscriptions + the amount in `warning-ink`, "Review"
/// pill. The whole card is one button (≥ 48dp). At ≥ 150% text the pill goes under the text.
class AwaitingCard extends StatelessWidget {
  const AwaitingCard({
    super.key,
    required this.count,
    required this.amount,
    required this.subscriptions,
    required this.onTap,
  });

  final int count;

  /// "$20.00" / "≈ $35.40".
  final String amount;

  /// Subscriptions waiting (their logos, oldest first).
  final List<Subscription> subscriptions;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
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
    final names = subscriptions.map((s) => s.name).toSet().join(', ');
    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l.homeAwaitingTitle(count), style: AppType.titleSm.copyWith(color: c.ink)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 2,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            LogoStack(subscriptions: subscriptions, ring: c.warningSoft),
            Text(
              amount,
              semanticsLabel: '${l.spoken(amount)} · $names',
              style: AppType.meta.copyWith(color: c.warningInk, fontWeight: FontWeight.w600).tabular,
            ),
          ],
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

/// 36px rounded-square icon on a soft fill (`tr-ic`).
class _SoftIcon extends StatelessWidget {
  const _SoftIcon({required this.icon, required this.bg, required this.fg});
  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
    child: Icon(icon, size: 20, color: fg),
  );
}

/// S2 trial card with 3 buttons (png 012, `trialCard()`, decision 2026-11-10 (2) #6): hourglass,
/// "Spotify trial ends in 3 days", "Then $11.99 on 13 Nov" + cycle chip, the logo on the right, a
/// `success-soft` "Cancel before it charges to save $143.88 a year" strip, then **Keep it**
/// (primary) · **View** (tonal) · **How to cancel ↗** (text; hidden without a link).
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
    this.subtitleBold,
    this.savings,
    this.savingsBold,
  });

  final Subscription subscription;
  final String title;

  /// "Then $11.99 on 13 Nov" ([subtitleBold] = "$11.99").
  final String subtitle;
  final String? subtitleBold;
  final VoidCallback onTap;
  final VoidCallback? onHowToCancel;
  final VoidCallback onKeep;
  final VoidCallback onView;

  /// "Cancel before it charges to save $143.88 a year" (null when the yearly cost is unknown).
  final String? savings;
  final String? savingsBold;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final s = subscription;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SoftIcon(icon: AppIcons.trial, bg: c.warningSoft, fg: c.warningInk),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        boldIn(
                          subtitle,
                          subtitleBold,
                          AppType.meta.copyWith(color: c.inkMuted),
                          boldColor: c.ink,
                          semanticsLabel: l.spokenLabel(subtitle),
                        ),
                        CycleChip(cycle: s.cycle),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              ServiceTile(
                name: s.name,
                colorValue: s.colorValue,
                iconText: s.iconText,
                serviceId: s.serviceId,
                customLogoFile: s.customLogoFile,
              ),
            ],
          ),
          if (savings != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(color: c.successSoft, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Icon(AppIcons.savings, size: 16, color: c.success),
                  const SizedBox(width: AppSpace.s2),
                  Expanded(
                    child: boldIn(
                      savings!,
                      savingsBold,
                      AppType.meta.copyWith(color: c.success, fontWeight: FontWeight.w600),
                      boldColor: c.success,
                      weight: FontWeight.w800,
                      semanticsLabel: l.spokenLabel(savings!),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton.primary(label: l.homeKeepIt, small: true, onPressed: onKeep),
              AppButton.tonal(label: l.homeViewSubscription, small: true, onPressed: onView),
              if (onHowToCancel != null)
                AppButton.text(
                  label: l.homeHowToCancel,
                  trailingIcon: AppIcons.external,
                  small: true,
                  onPressed: onHowToCancel,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// S2 library price notice (png 017, `noticeCard()`, glossary: Price change notice): logo, "YouTube
/// Premium changed its price", "$22.99 → $25.99" + cycle chip, a note ("Your share goes from … from
/// the 18 Nov renewal."), then **Update** (tonal) · **Keep old price** (text).
class PriceNoticeCard extends StatelessWidget {
  const PriceNoticeCard({
    super.key,
    required this.subscription,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
    required this.note,
    required this.onUpdate,
    required this.onKeep,
    this.reference,
    this.onTap,
  });

  final Subscription subscription;
  final String title;
  final String oldPrice;
  final String newPrice;
  final String note;

  /// "Reference price — check it" chip (the new price isn't verified yet).
  final String? reference;
  final VoidCallback onUpdate;
  final VoidCallback onKeep;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final s = subscription;
    const indent = 40.0 + AppSpace.s3;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceTile(
                name: s.name,
                colorValue: s.colorValue,
                iconText: s.iconText,
                serviceId: s.serviceId,
                customLogoFile: s.customLogoFile,
              ),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
                    const SizedBox(height: 3),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        boldIn(
                          '$oldPrice → $newPrice',
                          newPrice,
                          AppType.meta.copyWith(color: c.inkMuted).tabular,
                          boldColor: c.ink,
                        ),
                        CycleChip(cycle: s.cycle),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: indent, top: 8),
            child: Text(note, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
          if (reference != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: indent, top: 6),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: StatusBadge(label: reference!, icon: AppIcons.info),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: indent - 4, top: 6),
            child: Wrap(
              spacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton.tonal(label: l.homeNoticeUpdate, small: true, onPressed: onUpdate),
                AppButton.text(label: l.homeNoticeKeep, small: true, onPressed: onKeep),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "You're saving $191.87 a year" on the Cancelled tab (png 026, `save-head`): `success-soft`,
/// piggy-bank, amount in 800.
class SavingsHead extends StatelessWidget {
  const SavingsHead({super.key, required this.text, required this.amount});

  final String text;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: c.successSoft, borderRadius: BorderRadius.circular(14)),
        child: Row(
          children: [
            Icon(AppIcons.savings, size: 20, color: c.success),
            const SizedBox(width: 10),
            Expanded(
              child: boldIn(
                text,
                amount,
                AppType.label.copyWith(color: c.success),
                boldColor: c.success,
                weight: FontWeight.w800,
                semanticsLabel: context.l10n.spokenLabel(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "You're saving ₫1,479,000/year" (`save-card`): `success-soft`, piggy-bank in a `surface` circle.
/// Used by the cancellation celebration screen.
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

/// Header of the list section (png 014, `sec-h` + `sec-tools`): "Subscriptions", search (40px),
/// filter (40px; `brand-soft` with a count when active) and the "↕ Sort" pill. 48dp hit areas.
class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.title,
    required this.onSearch,
    required this.onFilter,
    required this.filterCount,
    required this.filterLabel,
    required this.onSort,
    required this.sortLabel,
  });

  final String title;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  final int filterCount;

  /// Spoken: "Filter, 1 selected".
  final String filterLabel;
  final VoidCallback onSort;

  /// Spoken: "Sort by Next payment".
  final String sortLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final active = filterCount > 0;
    Widget iconButton({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool on = false,
      int count = 0,
    }) => Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: AppTouch.min,
          height: AppTouch.min,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: on ? c.brandSoft : null, shape: BoxShape.circle),
                  child: Icon(icon, size: 20, color: on ? c.brand : c.ink),
                ),
                if (count > 0)
                  PositionedDirectional(
                    top: 0,
                    end: 0,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(9)),
                      child: Text(
                        '$count',
                        style: AppType.caption.copyWith(letterSpacing: 0, fontSize: 11, color: c.onBrand),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    final sort = Semantics(
      container: true,
      button: true,
      label: sortLabel,
      excludeSemantics: true,
      onTap: onSort,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSort,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.min, minWidth: AppTouch.min),
          child: Center(
            widthFactor: 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 32),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: ShapeDecoration(color: c.surface2, shape: const StadiumBorder()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcons.sort, size: 16, color: c.ink),
                  const SizedBox(width: 4),
                  Text(
                    l.homeSortButton,
                    maxLines: 1,
                    softWrap: false,
                    style: AppType.caption.copyWith(letterSpacing: 0, color: c.ink),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpace.s2,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconButton(icon: AppIcons.search, label: l.homeSearch, onTap: onSearch),
            iconButton(
              icon: LucideIcons.slidersHorizontal,
              label: filterLabel,
              onTap: onFilter,
              on: active,
              count: filterCount,
            ),
            const SizedBox(width: 2),
            sort,
          ],
        ),
      ],
    );
  }
}
