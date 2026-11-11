import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'stats_parts.dart';

/// Month | Year (design `picker()`): the segment, `‹ November 2026 ›` (or `‹ 2026 ›`) and a
/// "Projected" tag for a period still ahead. Wraps under the segment when there is no room.
class StatsPicker extends StatelessWidget {
  const StatsPicker({
    super.key,
    required this.year,
    required this.title,
    required this.projected,
    required this.onMode,
    required this.onPrevious,
    required this.onNext,
  });

  final bool year;
  final String title;
  final bool projected;
  final ValueChanged<bool> onMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final mode = year ? 'year' : 'month';
    final nav = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(icon: AppIcons.back, tooltip: l.insightsPrevious(mode), size: 22, onPressed: onPrevious),
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 112),
            child: Semantics(
              liveRegion: true,
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppType.titleSm.copyWith(color: c.ink),
              ),
            ),
          ),
        ),
        AppIconButton(icon: AppIcons.next, tooltip: l.insightsNext(mode), size: 22, onPressed: onNext),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.s1),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpace.s2,
        runSpacing: AppSpace.s1,
        children: [
          AppSegmentedControl<bool>(
            mini: true,
            segments: [
              AppSegment(value: false, label: l.insightsModeMonth),
              AppSegment(value: true, label: l.insightsModeYear),
            ],
            selected: year,
            onChanged: onMode,
          ),
          if (projected) const ProjectedTag(),
          nav,
        ],
      ),
    );
  }
}

/// "How the numbers work" (design `infoSheet()`, mockup 016): Monthly cost · Paid / Still to pay ·
/// why ≈, and the note that the two can differ.
Future<void> showStatsInfoSheet(BuildContext context) => showAppSheet<void>(
  context,
  builder: (context) {
    final l = context.l10n;
    final c = context.colors;
    Widget item(IconData icon, String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s4),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 20, color: c.onBrandSoft),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppType.label.copyWith(color: c.ink)),
                  const SizedBox(height: 2),
                  Text(body, style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return AppSheet(
      title: l.insightsInfoTitle,
      actions: [AppButton.tonal(label: l.insightsInfoOk, expand: true, onPressed: () => Navigator.of(context).pop())],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          item(LucideIcons.calendarRange, l.insightsInfoMonthlyTitle, l.insightsInfoMonthlyBody),
          item(AppIcons.wallet, l.insightsInfoCashTitle, l.insightsInfoCashBody),
          item(LucideIcons.equalApproximately, l.insightsInfoApproxTitle, l.insightsInfoApproxBody),
          Container(
            padding: const EdgeInsets.all(AppSpace.s3),
            decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(AppIcons.info, size: 16, color: c.inkMuted),
                const SizedBox(width: AppSpace.s2),
                Expanded(
                  child: Text(l.insightsInfoNote, style: AppType.meta.copyWith(color: c.ink)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
  bare: true,
);
