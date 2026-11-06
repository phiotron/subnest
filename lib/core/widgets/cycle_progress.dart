import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'formatters.dart';

/// Where [today] sits in the current billing period: from the previous Due date ([from]) to the
/// current one ([due]). Pure maths on whole days — no clock, no domain changes.
@immutable
class CycleProgress {
  const CycleProgress({required this.from, required this.due, required this.today});

  /// The period that ends on `cycle.occurrence(anchorDate, periodIndex)`.
  ///
  /// It starts at the previous occurrence (`periodIndex - 1`). For the first period
  /// (`periodIndex == 0`) it starts at [startDate] when that falls inside the cycle before the
  /// Due date; otherwise (re-anchored after an edit, or no sensible start) one cycle before it —
  /// so a subscription started a year ago and re-anchored today does not show a full bar.
  factory CycleProgress.of({
    required BillingCycle cycle,
    required LocalDate anchorDate,
    required int periodIndex,
    required LocalDate startDate,
    required LocalDate today,
  }) {
    final due = cycle.occurrence(anchorDate, periodIndex);
    final LocalDate from;
    if (periodIndex > 0) {
      from = cycle.occurrence(anchorDate, periodIndex - 1);
    } else {
      final before = cycleBefore(cycle, due);
      from = startDate.isAfter(before) && startDate.isBefore(due) ? startDate : before;
    }
    return CycleProgress(from: from, due: due, today: today);
  }

  /// Shortcut for a stored [Subscription].
  factory CycleProgress.forSubscription(Subscription s, {required LocalDate today}) => CycleProgress.of(
    cycle: s.cycle,
    anchorDate: s.anchorDate,
    periodIndex: s.periodIndex,
    startDate: s.startDate,
    today: today,
  );

  /// One [cycle] before [date] (month ends clamp: 31 Mar → 28/29 Feb).
  static LocalDate cycleBefore(BillingCycle cycle, LocalDate date) => switch (cycle.unit) {
    CycleUnit.day => date.addDays(-cycle.every),
    CycleUnit.week => date.addDays(-7 * cycle.every),
    CycleUnit.month => date.addMonths(-cycle.every),
    CycleUnit.year => date.addMonths(-12 * cycle.every),
  };

  final LocalDate from;
  final LocalDate due;
  final LocalDate today;

  /// Share of the period already gone, 0…1 (1 on or after the Due date — e.g. awaiting).
  double get fraction {
    final total = from.daysUntil(due);
    if (total <= 0) return 1;
    return (from.daysUntil(today) / total).clamp(0.0, 1.0);
  }

  /// Days until the Due date (negative once it has passed).
  int get daysLeft => today.daysUntil(due);

  @override
  bool operator ==(Object other) =>
      other is CycleProgress && other.from == from && other.due == due && other.today == today;

  @override
  int get hashCode => Object.hash(from, due, today);

  @override
  String toString() => 'CycleProgress($from → $due, today $today)';
}

/// Colour of a [CycleProgressBar] (fill on a `surface-2` track).
enum CycleProgressTone {
  /// Active: `brand`.
  normal,

  /// Free trial: neutral `ink-muted` (like the Trial badge).
  trial,

  /// Awaiting confirmation: `warning` amber on `warning-soft` (never red).
  awaiting,

  /// Cancelled / paused: `line-strong` grey.
  off,
}

/// Thin (4px, pill) bar showing how much of the billing period has passed — the SubFox-style
/// "in 23 days" bar under a [SubscriptionRow]'s second line.
///
/// Read by screen readers as the days left ("in 23 days" / "còn 23 ngày", "Today", "2 days
/// ago") plus the percentage. Changes animate over `AppMotion.sheet`; with reduced motion they
/// jump. Purely visual: not tappable (the row is).
class CycleProgressBar extends StatelessWidget {
  const CycleProgressBar({
    super.key,
    required this.progress,
    this.tone = CycleProgressTone.normal,
    this.semanticsLabel,
  });

  final CycleProgress progress;
  final CycleProgressTone tone;

  /// Overrides the spoken text (defaults to `AppDates.relative` of the Due date).
  final String? semanticsLabel;

  static const height = 4.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (fill, track) = switch (tone) {
      CycleProgressTone.normal => (c.brand, c.surface2),
      CycleProgressTone.trial => (c.inkMuted, c.surface2),
      CycleProgressTone.awaiting => (c.warning, c.warningSoft),
      CycleProgressTone.off => (c.lineStrong, c.surface2),
    };
    final fraction = progress.fraction;
    final label = semanticsLabel ?? AppDates.relative(context.l10n, progress.due, today: progress.today);
    return Semantics(
      container: true,
      label: label,
      value: '${(fraction * 100).round()}%',
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: fraction, end: fraction),
          duration: AppMotion.of(context, AppMotion.sheet),
          curve: AppMotion.ease,
          builder: (context, value, _) => SizedBox(
            height: height,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarPainter(
                value: value,
                fill: fill,
                track: track,
                rtl: Directionality.of(context) == TextDirection.rtl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({required this.value, required this.fill, required this.track, required this.rtl});

  final double value;
  final bool rtl;
  final Color fill;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Radius.circular(size.height / 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, r), Paint()..color = track);
    if (value <= 0) return;
    // At least a dot (the bar's height) so "just started" is still visible.
    final w = (size.width * value).clamp(size.height, size.width);
    final rect = rtl ? Rect.fromLTWH(size.width - w, 0, w, size.height) : Rect.fromLTWH(0, 0, w, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, r), Paint()..color = fill);
  }

  @override
  bool shouldRepaint(_BarPainter old) => old.value != value || old.fill != fill || old.track != track || old.rtl != rtl;
}
