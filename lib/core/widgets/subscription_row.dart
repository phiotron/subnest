import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'chip_badge.dart';
import 'service_tile.dart';

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
}

/// Subscription list row (design Components › SubscriptionRow): ≥ 68px, 40px [ServiceTile],
/// name (`title-sm`, ellipsizes) + optional shared mark "÷4", second line by [state], amount
/// column (`title-sm` + meta, tabular, never truncates).
///
/// Swipe left reveals **Confirm** (`brand`, only while [state] is awaiting and [onConfirm] is set)
/// and **Cancel** (`surface-2`, when [onCancel] is set). A full swipe triggers the first action
/// with a haptic tick at the threshold. Both are also exposed as accessibility actions.
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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final off = state == SubscriptionRowState.cancelled;

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
              Text('×$awaitingCount', style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: c.warningInk)),
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
          ],
        );
      case SubscriptionRowState.normal || SubscriptionRowState.cancelled:
        second = Text(meta ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: AppType.meta.copyWith(color: c.inkMuted));
    }

    final row = ConstrainedBox(
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
                    ],
                  ),
                  const SizedBox(height: 3),
                  second,
                ],
              ),
            ),
            const SizedBox(width: AppSpace.s3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(amount, maxLines: 1, softWrap: false, style: AppType.titleSm.copyWith(color: c.ink).tabular),
                if (amountMeta != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    amountMeta!,
                    maxLines: 1,
                    softWrap: false,
                    style: AppType.meta.copyWith(color: c.inkMuted).tabular,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
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
      if (!off && onCancel != null)
        SwipeAction(
          label: l.coreSwipeCancel,
          icon: AppIcons.cancelled,
          background: c.surface2,
          foreground: c.ink,
          onPressed: onCancel!,
        ),
    ];

    return SwipeActions(
      actions: actions,
      onTap: onTap,
      highlight: highlight,
      child: row,
    );
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
                          child: InkWell(
                            onTap: x > 0 ? close : widget.onTap,
                            child: child,
                          ),
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
