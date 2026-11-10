import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'chip_badge.dart';
import 'cycle_progress.dart';
import 'service_tile.dart';

export 'cycle_progress.dart';

/// Visual state of a [SubscriptionRow].
enum SubscriptionRowState {
  /// Active, nothing pending: meta line "in 3 days · AI".
  normal,

  /// A period is awaiting confirmation: warning dot on the tile + "To confirm" badge (+ "×N").
  /// Never shows a date beside the badge (VI/360 rule).
  awaiting,

  /// Free trial: neutral hourglass "Trial" badge + "ends in 2 days".
  trial,

  /// Cancelled: greyed tile, muted name, "Cancelled 04/11/2026".
  cancelled,

  /// Paused: greyed tile, muted name, neutral pause "Paused" badge + "since 1 Nov" ([meta]).
  /// Still swipeable to Cancel. Progress bar (if any) defaults to the `off` tone.
  paused,
}

/// Subscription list row (design Components › SubscriptionRow): ≥ 68px, 40px [ServiceTile],
/// name (`title-sm`, ellipsizes) + optional shared mark "÷4", second line by [state], amount
/// column (`title-sm` + meta, tabular, never truncates). When the amounts would leave too little
/// room for the name and badge (narrow screen, VI, large text — always at ≥ 150%), the amounts
/// move under the second line instead of squeezing it.
///
/// Swipe left reveals **Confirm** (`brand`, only while [state] is awaiting and [onConfirm] is set)
/// and **Cancel** (`surface-2`, when [onCancel] is set). A full swipe triggers the first action
/// with a haptic tick at the threshold. Both are also exposed as accessibility actions.
///
/// Optional extras (off by default — rows without them look exactly as before):
/// * [serviceId] / [subscriptionId] → bundled or custom logo on the tile, see [ServiceTile.logo].
/// * [progress] → a [CycleProgressBar] under the second line (how much of the billing period
///   has passed). Its colour follows [state] (trial / awaiting / cancelled = off) unless
///   [progressTone] is given (e.g. `off` for a paused subscription).
/// * [nameBadge] (e.g. "Auto") after the name, [metaExtras] (label chip, "+2") after the second line.
///
/// Put rows in an `AppGroup(dividerIndent: 68)`. Strings for meta lines come from the caller —
/// build them with `AppDates.relative`, `l10n.category`, `perCycle`, `l10n.corePlanPrice`.
class SubscriptionRow extends StatelessWidget {
  const SubscriptionRow({
    super.key,
    required this.name,
    required this.colorValue,
    this.iconText,
    this.state = SubscriptionRowState.normal,
    this.meta,
    this.awaitingCount = 1,
    this.badgeLabel,
    this.sharedCount,
    required this.amount,
    this.amountMeta,
    this.onTap,
    this.onConfirm,
    this.onCancel,
    this.highlight = false,
    this.queued = false,
    this.serviceId,
    this.subscriptionId,
    this.progress,
    this.progressTone,
    this.nameBadge,
    this.metaExtras = const [],
  });

  final String name;
  final int colorValue;
  final String? iconText;
  final SubscriptionRowState state;

  /// Second-line text (normal: "in 3 days · AI"; trial: "ends in 2 days"; cancelled:
  /// "Cancelled 04/11/2026"). Ignored for awaiting.
  final String? meta;

  /// Periods awaiting (> 1 shows "×N" beside the badge).
  final int awaitingCount;

  /// Overrides the badge text (defaults: "To confirm" / "Free trial" from common l10n).
  final String? badgeLabel;

  /// Members sharing the plan (≥ 2 shows "÷N").
  final int? sharedCount;

  /// Main amount (already formatted, e.g. "₫65,000" — My share).
  final String amount;

  /// Secondary amount line: "/month", "plan ₫260,000", "≈ ₫508,000".
  final String? amountMeta;

  final VoidCallback? onTap;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  /// Flash `brand-soft` once (a row that was just added).
  final bool highlight;

  /// Queued period (S7): dims the tile.
  final bool queued;

  /// `Subscription.serviceId` → bundled logo on the tile ([ServiceTile.serviceId]).
  final String? serviceId;

  /// `Subscription.id` → the user's Custom logo on the tile ([ServiceTile.subscriptionId]).
  final String? subscriptionId;

  /// Current billing period → [CycleProgressBar] under the second line; `null` = no bar.
  /// Build it with `CycleProgress.forSubscription(sub, today: today)`.
  final CycleProgress? progress;

  /// Bar colour; defaults from [state] (normal → brand, trial, awaiting, cancelled/paused → off).
  final CycleProgressTone? progressTone;

  /// Small badge after the name (and share mark), e.g. the "Auto" badge of an auto-detected
  /// subscription. `null` = nothing.
  final Widget? nameBadge;

  /// Extra pieces at the end of the second line (label chip, "+2"…); they wrap with it.
  final List<Widget> metaExtras;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final cancelled = state == SubscriptionRowState.cancelled;
    final off = cancelled || state == SubscriptionRowState.paused;

    Widget second;
    switch (state) {
      case SubscriptionRowState.awaiting:
        second = Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusBadge.awaiting(label: badgeLabel ?? l.commonStatusAwaiting),
            if (awaitingCount > 1)
              Text(
                '×$awaitingCount',
                style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: c.warningInk),
              ),
            ...metaExtras,
          ],
        );
      case SubscriptionRowState.trial:
        second = Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusBadge.trial(label: badgeLabel ?? l.commonStatusTrial),
            if (meta != null) Text(meta!, style: AppType.meta.copyWith(color: c.inkMuted)),
            ...metaExtras,
          ],
        );
      case SubscriptionRowState.paused:
        second = Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusBadge(label: badgeLabel ?? l.commonStatusPaused, icon: LucideIcons.pause),
            if (meta != null) Text(meta!, style: AppType.meta.copyWith(color: c.inkMuted)),
            ...metaExtras,
          ],
        );
      case SubscriptionRowState.normal || SubscriptionRowState.cancelled:
        final text = Text(
          meta ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppType.meta.copyWith(color: c.inkMuted),
        );
        second = metaExtras.isEmpty
            ? text
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [if (meta != null && meta!.isNotEmpty) text, ...metaExtras],
              );
    }

    final amountStyle = AppType.titleSm.copyWith(color: c.ink).tabular;
    final amountMetaStyle = AppType.meta.copyWith(color: c.inkMuted).tabular;

    Widget layout(bool stacked) => ConstrainedBox(
      constraints: const BoxConstraints(minHeight: AppSize.rowH),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 12),
        child: Row(
          children: [
            ServiceTile(
              name: name,
              colorValue: colorValue,
              iconText: iconText,
              awaiting: state == SubscriptionRowState.awaiting,
              off: off,
              faded: queued,
              serviceId: serviceId,
              subscriptionId: subscriptionId,
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.titleSm.copyWith(color: off ? c.inkMuted : c.ink),
                        ),
                      ),
                      if ((sharedCount ?? 0) > 1) ...[
                        const SizedBox(width: 6),
                        ShareMark(count: sharedCount!, semanticLabel: l.coreSharedWith(sharedCount!)),
                      ],
                      if (nameBadge != null) ...[const SizedBox(width: 6), nameBadge!],
                    ],
                  ),
                  const SizedBox(height: 3),
                  second,
                  if (progress != null) ...[
                    const SizedBox(height: 6),
                    CycleProgressBar(
                      progress: progress!,
                      tone:
                          progressTone ??
                          switch (state) {
                            SubscriptionRowState.normal => CycleProgressTone.normal,
                            SubscriptionRowState.trial => CycleProgressTone.trial,
                            SubscriptionRowState.awaiting => CycleProgressTone.awaiting,
                            SubscriptionRowState.cancelled || SubscriptionRowState.paused => CycleProgressTone.off,
                          },
                    ),
                  ],
                  if (stacked) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(amount, style: amountStyle),
                        if (amountMeta != null)
                          Text(
                            amountMeta!,
                            semanticsLabel: context.l10n.spokenLabel(amountMeta!),
                            style: amountMetaStyle,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!stacked) ...[
              const SizedBox(width: AppSpace.s3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(amount, maxLines: 1, softWrap: false, style: amountStyle),
                  if (amountMeta != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      amountMeta!,
                      semanticsLabel: context.l10n.spokenLabel(amountMeta!),
                      maxLines: 1,
                      softWrap: false,
                      style: amountMetaStyle,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );

    final row = LayoutBuilder(
      builder: (context, box) {
        final scaler = MediaQuery.textScalerOf(context);
        double width(String text, TextStyle style) {
          final tp = TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: Directionality.of(context),
            textScaler: scaler,
            maxLines: 1,
          )..layout();
          final w = tp.width;
          tp.dispose();
          return w;
        }

        final amountW = [
          width(amount, amountStyle),
          if (amountMeta != null) width(amountMeta!, amountMetaStyle),
        ].reduce((a, b) => a > b ? a : b);
        // Room for the name column if the amounts stay on the right.
        final room = box.maxWidth - AppSpace.s4 * 2 - 40 - AppSpace.s3 * 2 - amountW;
        // What the second line needs: the badge (+ "×N") — never truncated.
        var need = 112.0;
        if (state == SubscriptionRowState.awaiting ||
            state == SubscriptionRowState.trial ||
            state == SubscriptionRowState.paused) {
          final label =
              badgeLabel ??
              switch (state) {
                SubscriptionRowState.awaiting => l.commonStatusAwaiting,
                SubscriptionRowState.paused => l.commonStatusPaused,
                _ => l.commonStatusTrial,
              };
          need = width(label, AppType.caption.copyWith(letterSpacing: 0)) + 6 + 13 + 4 + 8 + 4;
          if (state == SubscriptionRowState.awaiting && awaitingCount > 1) {
            need += 6 + width('×$awaitingCount', AppType.meta.copyWith(fontWeight: FontWeight.w600));
          }
        }
        final stacked = scaler.scale(10) >= 15 || room < need;
        return layout(stacked);
      },
    );

    final actions = <SwipeAction>[
      if (state == SubscriptionRowState.awaiting && onConfirm != null)
        SwipeAction(
          label: l.coreSwipeConfirm,
          icon: AppIcons.check,
          background: c.brand,
          foreground: c.onBrand,
          onPressed: onConfirm!,
        ),
      if (!cancelled && onCancel != null)
        SwipeAction(
          label: l.coreSwipeCancel,
          icon: AppIcons.cancelled,
          background: c.surface2,
          foreground: c.ink,
          onPressed: onCancel!,
        ),
    ];

    return SwipeActions(actions: actions, onTap: onTap, highlight: highlight, child: row);
  }
}

/// One revealed action behind a swiped row (84px wide, icon 20 + caption 12/600).
class SwipeAction {
  const SwipeAction({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
}

/// Swipe-left container used by [SubscriptionRow]; reusable for any list row.
/// The child is painted on `surface` so the actions stay hidden until swiped.
class SwipeActions extends StatefulWidget {
  const SwipeActions({super.key, required this.child, required this.actions, this.onTap, this.highlight = false});

  final Widget child;
  final List<SwipeAction> actions;
  final VoidCallback? onTap;
  final bool highlight;

  static const actionWidth = 84.0;

  @override
  State<SwipeActions> createState() => _SwipeActionsState();
}

class _SwipeActionsState extends State<SwipeActions> with TickerProviderStateMixin {
  late final AnimationController _offset = AnimationController.unbounded(vsync: this);
  late final AnimationController _flash = AnimationController(vsync: this, duration: AppMotion.newRowFlash);
  double _width = 0;
  bool _pastThreshold = false;

  double get _open => SwipeActions.actionWidth * widget.actions.length;
  double get _threshold => _width * .6;

  @override
  void initState() {
    super.initState();
    if (widget.highlight) _flash.forward();
  }

  @override
  void didUpdateWidget(SwipeActions old) {
    super.didUpdateWidget(old);
    if (widget.highlight && !old.highlight) _flash.forward(from: 0);
    if (widget.actions.isEmpty && _offset.value != 0) _offset.value = 0;
  }

  @override
  void dispose() {
    _offset.dispose();
    _flash.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final d = AppMotion.of(context, AppMotion.sheet);
    if (d == Duration.zero) {
      _offset.value = target;
    } else {
      _offset.animateTo(target, duration: d, curve: AppMotion.ease);
    }
  }

  void close() => _animateTo(0);

  void _onUpdate(DragUpdateDetails d) {
    if (widget.actions.isEmpty) return;
    final next = (_offset.value - d.delta.dx).clamp(0.0, _width);
    _offset.value = next;
    final past = next >= _threshold;
    if (past != _pastThreshold) {
      _pastThreshold = past;
      HapticFeedback.selectionClick();
    }
  }

  void _onEnd(DragEndDetails d) {
    if (widget.actions.isEmpty) return;
    final v = d.primaryVelocity ?? 0;
    if (_offset.value >= _threshold) {
      _pastThreshold = false;
      _animateTo(0);
      HapticFeedback.lightImpact();
      widget.actions.first.onPressed();
    } else if (v < -300 || (_offset.value > _open / 2 && v <= 300)) {
      _animateTo(_open);
    } else {
      _animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, box) {
        _width = box.maxWidth;
        return Semantics(
          customSemanticsActions: {
            for (final a in widget.actions)
              CustomSemanticsAction(label: a.label): () {
                close();
                a.onPressed();
              },
          },
          child: GestureDetector(
            onHorizontalDragUpdate: widget.actions.isEmpty ? null : _onUpdate,
            onHorizontalDragEnd: widget.actions.isEmpty ? null : _onEnd,
            child: ClipRect(
              child: AnimatedBuilder(
                animation: Listenable.merge([_offset, _flash]),
                builder: (context, child) {
                  final x = _offset.value;
                  final extra = (x - _open).clamp(0.0, double.infinity);
                  final t = _flash.value;
                  final flashColor = !_flash.isAnimating && t == 0
                      ? c.surface
                      : Color.lerp(c.brandSoft, c.surface, t < .4 ? 0 : (t - .4) / .6)!;
                  return Stack(
                    children: [
                      if (x > 0)
                        Positioned.fill(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              for (var i = 0; i < widget.actions.length; i++)
                                _action(widget.actions[i], SwipeActions.actionWidth + (i == 0 ? extra : 0)),
                            ],
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(-x, 0),
                        child: Material(
                          color: flashColor,
                          child: InkWell(onTap: x > 0 ? close : widget.onTap, child: child),
                        ),
                      ),
                    ],
                  );
                },
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _action(SwipeAction a, double width) => SizedBox(
    width: width,
    child: Material(
      color: a.background,
      child: InkWell(
        onTap: () {
          close();
          a.onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(a.icon, size: 20, color: a.foreground),
            const SizedBox(height: 4),
            Text(
              a.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption.copyWith(letterSpacing: 0, color: a.foreground),
            ),
          ],
        ),
      ),
    ),
  );
}
