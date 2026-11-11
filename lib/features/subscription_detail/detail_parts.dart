import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../domain/domain.dart';

/// Building blocks of S5 Detail (mockup v14, `design/system/bundle.js` › SCR.detail): info rows,
/// the selected cycle chip, label chips, the Price history timeline and Payment history rows.
/// Kept in the feature (wave-2 rule: new components live with their screen).

/// `cyc.on`: the cycle chip on the Billing cycle row — `brand` ring and text, 24px high, 13/600.
class SelectedCycleChip extends StatelessWidget {
  const SelectedCycleChip({super.key, required this.cycle});

  final BillingCycle cycle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: c.brand),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        context.l10n.cycle(cycle),
        maxLines: 1,
        softWrap: false,
        style: AppType.label.copyWith(fontSize: 13, height: 18 / 13, color: c.brand),
      ),
    );
  }
}

/// `lbl`: 20px pill on `surface-2`, 8px colour dot, 12/600 `ink`. Never truncates.
class DetailLabelChip extends StatelessWidget {
  const DetailLabelChip({super.key, required this.label});

  final Label label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(color: c.surface2, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.colorValue != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: Color(label.colorValue!), shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label.name,
            style: AppType.caption.copyWith(color: c.ink, letterSpacing: 0, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Info-card row (design `srow` with a value): 24px icon slot, label (+ meta sub-line), value on the
/// right — a string ([value]) or a widget ([trailing]: chip, labels). The value keeps its natural
/// width (≤ 60%); at ≥ 150% text it goes under the label so words never break mid-word (320dp × 200%).
class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.value,
    this.valueColor,
    this.strong = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? value;
  final Color? valueColor;

  /// Bold `ink` value (Total paid) / 600 weight for a coloured value (Worth it?).
  final bool strong;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stacked = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    final valueStyle = strong
        ? AppType.body
              .copyWith(color: valueColor ?? c.ink, fontWeight: valueColor == null ? FontWeight.w700 : FontWeight.w600)
              .tabular
        : AppType.body.copyWith(color: valueColor ?? c.inkMuted).tabular;
    final right =
        trailing ??
        (value == null
            ? null
            : Text(
                value!,
                textAlign: stacked ? TextAlign.start : TextAlign.end,
                maxLines: stacked ? null : 2,
                overflow: stacked ? null : TextOverflow.ellipsis,
                style: valueStyle,
              ));
    return MergeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: LayoutBuilder(
            builder: (context, box) => Row(
              crossAxisAlignment: stacked ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                SizedBox(width: 24, child: Icon(icon, size: 20, color: c.inkMuted)),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: AppType.body.copyWith(fontWeight: FontWeight.w500, height: 20 / 15, color: c.ink),
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle!, style: AppType.meta.copyWith(color: c.inkMuted)),
                        ),
                      if (stacked && right != null)
                        Padding(
                          key: const ValueKey('info-value-below'),
                          padding: const EdgeInsets.only(top: 4),
                          child: right,
                        ),
                    ],
                  ),
                ),
                if (!stacked && right != null) ...[
                  const SizedBox(width: AppSpace.s3),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: box.maxWidth * .6),
                    child: right,
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

/// Section header + card (`group(rows, title)`): uppercase caption eyebrow, then an [AppGroup].
class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.children, this.dividerIndent = AppSpace.s4});

  final String title;
  final List<Widget> children;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      SectionHeader(label: title, padding: const EdgeInsets.fromLTRB(AppSpace.s1, 0, AppSpace.s1, AppSpace.s2)),
      AppGroup(dividerIndent: dividerIndent, children: children),
    ],
  );
}

/// Centered muted line inside a card (empty Price / Payment history).
class DetailEmptyLine extends StatelessWidget {
  const DetailEmptyLine({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s5),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppType.meta.copyWith(color: context.colors.inkMuted),
    ),
  );
}

// ---- Price history (§4.5.5, png 045–046) ----------------------------------------------------

/// The Price history timeline: newest first, increases `warning-ink` ↑ +, decreases `success` ↓ −
/// (never colour alone), a change that applies from a later date drawn with an amber ring and
/// "From 18 Nov · … · next payment", then "Started at $15.49" with the start date. Rows are joined by
/// a 2px `line` rail through the 32px icons. Empty: "The price has never changed."
class PriceHistoryList extends StatelessWidget {
  const PriceHistoryList({super.key, required this.subscription, required this.changes, required this.today});

  final Subscription subscription;

  /// Newest first (`subscriptionPriceHistoryProvider`).
  final List<PriceChange> changes;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (changes.isEmpty) return DetailEmptyLine(text: l.subscriptionDetailPriceNeverChanged);
    final oldest = changes.last;
    final rows = <Widget>[
      for (final ch in changes) _PriceChangeRow(change: ch, today: today),
      _TimelineRow(
        icon: Icon(LucideIcons.flag, size: 16, color: context.colors.inkMuted),
        title: l.subscriptionDetailPriceStarted(
          l.money(Money(oldest.oldPriceMinor, oldest.oldCurrency ?? oldest.currency)),
        ),
        meta: AppDates.full(l, subscription.startDate),
        sourceIcon: oldest.source == PriceChangeSource.backfill ? _sourceIcon(PriceChangeSource.backfill) : null,
        source: oldest.source == PriceChangeSource.backfill ? l.subscriptionDetailPriceSourceBackfill : null,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        children: [
          // The rail behind the icons, from the first icon's centre to the last one's.
          PositionedDirectional(
            start: AppSpace.s4 + 15,
            top: 34,
            bottom: 34,
            child: Container(width: 2, color: context.colors.line),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows),
        ],
      ),
    );
  }
}

IconData _sourceIcon(PriceChangeSource s) => switch (s) {
  PriceChangeSource.manual => LucideIcons.pencil,
  PriceChangeSource.catalog => LucideIcons.bookOpen,
  PriceChangeSource.backfill => LucideIcons.receipt,
};

String _sourceText(AppLocalizations l, PriceChangeSource s) => switch (s) {
  PriceChangeSource.manual => l.subscriptionDetailPriceSourceManual,
  PriceChangeSource.catalog => l.subscriptionDetailPriceSourceCatalog,
  PriceChangeSource.backfill => l.subscriptionDetailPriceSourceBackfill,
};

class _PriceChangeRow extends StatelessWidget {
  const _PriceChangeRow({required this.change, required this.today});

  final PriceChange change;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final ch = change;
    final oldMoney = Money(ch.oldPriceMinor, ch.oldCurrency ?? ch.currency);
    final newMoney = Money(ch.newPriceMinor, ch.currency);
    final comparable = ch.oldCurrency == null || ch.oldCurrency == ch.currency;
    final diff = ch.newPriceMinor - ch.oldPriceMinor;
    final up = comparable && diff > 0;
    final down = comparable && diff < 0;
    final future = ch.effectiveFrom.isAfter(today);
    final (bg, fg) = up
        ? (c.warningSoft, c.warningInk)
        : down
        ? (c.successSoft, c.success)
        : (c.surface2, c.inkMuted);
    final date = AppDates.full(l, ch.effectiveFrom);
    final delta = Money(diff.abs(), ch.currency);
    return _TimelineRow(
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: future ? c.surface : bg,
          shape: BoxShape.circle,
          border: future ? Border.all(color: c.warning, width: 1.5) : null,
        ),
        child: Icon(
          up
              ? LucideIcons.trendingUp
              : down
              ? LucideIcons.trendingDown
              : LucideIcons.arrowRightLeft,
          size: 18,
          color: fg,
        ),
      ),
      bare: true,
      title: '${l.money(oldMoney)} → ${l.money(newMoney)}',
      meta: future ? l.subscriptionDetailPriceFrom(date) : date,
      sourceIcon: _sourceIcon(ch.source),
      source: _sourceText(l, ch.source),
      trailingMeta: future ? l.subscriptionDetailPriceNext : null,
      delta: comparable && diff != 0
          ? Text(
              '${up ? '+' : '−'}${l.money(delta)}',
              semanticsLabel: up
                  ? l.subscriptionDetailPriceRose(l.money(delta))
                  : l.subscriptionDetailPriceFell(l.money(delta)),
              maxLines: 1,
              softWrap: false,
              style: AppType.label.copyWith(fontWeight: FontWeight.w800, color: fg).tabular,
            )
          : null,
    );
  }
}

/// One timeline row: 32px icon (in the rail), label + "date · ⓘ source" meta, optional delta.
class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.icon,
    required this.title,
    required this.meta,
    this.sourceIcon,
    this.source,
    this.trailingMeta,
    this.delta,
    this.bare = false,
  });

  final Widget icon;
  final String title;
  final String meta;
  final IconData? sourceIcon;
  final String? source;
  final String? trailingMeta;
  final Widget? delta;

  /// [icon] is already the 32px disc.
  final bool bare;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final metaStyle = AppType.meta.copyWith(color: c.inkMuted);
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
        child: Row(
          children: [
            bare
                ? icon
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
                    child: Center(child: icon),
                  ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppType.label.copyWith(color: c.ink).tabular),
                  const SizedBox(height: 2),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: meta),
                        if (source != null) ...[
                          const TextSpan(text: ' · '),
                          if (sourceIcon != null)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(end: 3),
                                child: Icon(sourceIcon, size: 12, color: c.inkMuted),
                              ),
                            ),
                          TextSpan(text: source),
                        ],
                        if (trailingMeta != null) TextSpan(text: ' · $trailingMeta'),
                      ],
                    ),
                    style: metaStyle.tabular,
                  ),
                ],
              ),
            ),
            if (delta != null) ...[const SizedBox(width: AppSpace.s2), delta!],
          ],
        ),
      ),
    );
  }
}

// ---- Payment history (§4.5.6) ----------------------------------------------------------------

/// "✓ Paid" (success) / "⊘ Didn't pay" (muted), 13/600 with a 16px icon.
class PaymentStatusLine extends StatelessWidget {
  const PaymentStatusLine({super.key, required this.paid, required this.label});

  final bool paid;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = paid ? c.success : c.inkMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(paid ? AppIcons.paid : AppIcons.cancelled, size: 16, color: fg),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: fg),
          ),
        ),
      ],
    );
  }
}

/// One payment-history row: date, status line (+ "🖼 From screenshot · Undo" for an automatic
/// confirmation), amount, and a pencil (editable Payment) or a small Confirm button (waiting).
class PaymentHistoryRow extends StatelessWidget {
  const PaymentHistoryRow({
    super.key,
    required this.date,
    required this.status,
    required this.amount,
    this.editable = false,
    this.semanticHint,
    this.onTap,
    this.sourceLabel,
    this.undoLabel,
    this.onUndo,
    this.action,
  });

  final String date;
  final Widget status;
  final String amount;
  final bool editable;
  final String? semanticHint;
  final VoidCallback? onTap;

  /// "From screenshot" (auto-confirmed Payment) with an inline [undoLabel] link.
  final String? sourceLabel;
  final String? undoLabel;
  final VoidCallback? onUndo;

  /// Trailing button instead of the pencil (waiting period: Confirm).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final meta = AppType.meta.copyWith(color: c.inkMuted, fontWeight: FontWeight.w500);
    final stacked = MediaQuery.textScalerOf(context).scale(10) >= 13;
    final amountText = Text(
      amount,
      maxLines: 1,
      softWrap: false,
      style: AppType.body.copyWith(color: c.inkMuted).tabular,
    );
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 64),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(AppSpace.s4, 10, AppSpace.s3, 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    date,
                    style: AppType.body.copyWith(fontWeight: FontWeight.w500, color: c.ink),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: AppSpace.s2,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      status,
                      if (sourceLabel != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.image, size: 13, color: c.inkMuted),
                            const SizedBox(width: 4),
                            Flexible(child: Text(sourceLabel!, style: meta)),
                            if (undoLabel != null) ...[
                              Text(' · ', style: meta),
                              Semantics(
                                button: true,
                                child: InkWell(
                                  onTap: onUndo,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(minHeight: AppTouch.min, minWidth: AppTouch.min),
                                    child: Center(
                                      child: Text(
                                        undoLabel!,
                                        style: meta.copyWith(color: c.brand, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),
                  // Large text: amount and button go under the status (they never shrink).
                  if (stacked) ...[
                    const SizedBox(height: 4),
                    amountText,
                    if (action != null) ...[const SizedBox(height: AppSpace.s2), action!],
                  ],
                ],
              ),
            ),
            if (!stacked) ...[
              const SizedBox(width: AppSpace.s3),
              amountText,
              if (action != null) ...[const SizedBox(width: AppSpace.s2), action!],
            ],
            if (editable && action == null) ...[
              const SizedBox(width: AppSpace.s3),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpace.s1),
                child: Icon(AppIcons.edit, size: 18, color: c.inkMuted),
              ),
            ],
          ],
        ),
      ),
    );
    if (onTap == null) return sourceLabel == null ? MergeSemantics(child: row) : row;
    return Semantics(
      button: true,
      hint: semanticHint,
      child: InkWell(onTap: onTap, child: row),
    );
  }
}
