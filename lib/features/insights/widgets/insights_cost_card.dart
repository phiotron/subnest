import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'insights_format.dart';
import 'stats_parts.dart';

/// The cost card of S9 (design `.costcard.ins-c`, mockup 074 / 079–081): "Cost of November" + change
/// chip, the ≈ total with (i), "10 subscriptions · ≈ $4.83 a day", then Paid / Still to pay (past
/// month: Paid / Not paid) with the solid-vs-hatched bar.
class InsightsCostCard extends StatelessWidget {
  const InsightsCostCard({
    super.key,
    required this.title,
    required this.totalMinor,
    required this.currency,
    required this.count,
    required this.perText,
    required this.perAmount,
    required this.paidMinor,
    required this.dueMinor,
    required this.past,
    required this.onInfo,
    this.changeMinor,
    this.vs = '',
    this.same = '',
    this.emptyText,
    this.missingRates = const {},
  });

  final String title;
  final int totalMinor;
  final String currency;
  final int count;

  /// "≈ $4.83 a day" / "≈ $134.20 a month".
  final String perText;

  /// The amount inside [perText], drawn bold ("$4.83").
  final String perAmount;
  final int paidMinor;

  /// Still to pay, or — for a past month — what was not paid.
  final int dueMinor;
  final bool past;
  final VoidCallback onInfo;

  /// `null` = no comparison (first month with data).
  final int? changeMinor;
  final String vs;
  final String same;

  /// Shown instead of the count line when nothing was being paid.
  final String? emptyText;
  final Set<String> missingRates;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final zero = totalMinor == 0;
    final total = l.minor(totalMinor, currency);
    final big = AppType.display.copyWith(color: zero ? c.inkMuted : c.ink).tabular;
    // display grows less than body text (design README: to 44px at 200%).
    final scaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.1);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s3),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, 14, AppSpace.s4, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpace.s2,
              runSpacing: AppSpace.s1,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: AppType.label.copyWith(color: c.ink)),
                ),
                if (changeMinor != null) ChangeChip(changeMinor: changeMinor!, currency: currency, vs: vs, same: same),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '≈ ',
                            style: AppType.display.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: c.inkMuted,
                            ),
                          ),
                          TextSpan(text: total, style: big),
                        ],
                      ),
                      textScaler: scaler,
                      maxLines: 1,
                      semanticsLabel: l.spoken('≈ $total'),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                StatsInfoButton(onPressed: onInfo),
              ],
            ),
            BoldText(emptyText ?? '${l.insightsCount(count)} · $perText', bold: [if (emptyText == null) perAmount]),
            if (missingRates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  l.insightsMissingRates((missingRates.toList()..sort()).join(', ')),
                  style: AppType.meta.copyWith(color: c.inkMuted),
                ),
              ),
            const SizedBox(height: 14),
            CashBlock(paidMinor: paidMinor, dueMinor: dueMinor, currency: currency, past: past),
          ],
        ),
      ),
    );
  }
}

/// Paid / Still to pay rows and the 10px bar (design `cashBar()`): `brand` solid vs 135° hatch.
class CashBlock extends StatelessWidget {
  const CashBlock({
    super.key,
    required this.paidMinor,
    required this.dueMinor,
    required this.currency,
    this.past = false,
  });

  final int paidMinor;
  final int dueMinor;
  final String currency;
  final bool past;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final paid = l.minor(paidMinor, currency), due = l.minor(dueMinor, currency);
    final dueLabel = past ? l.insightsNotPaid : l.insightsStillToPay;

    Widget row(Widget dot, String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          dot,
          const SizedBox(width: AppSpace.s2),
          Expanded(
            child: Text(
              label,
              style: AppType.body.copyWith(fontSize: 14, height: 20 / 14, color: c.inkMuted),
            ),
          ),
          const SizedBox(width: AppSpace.s2),
          Text(
            value,
            style: AppType.label.copyWith(fontWeight: FontWeight.w700, color: c.ink).tabular,
          ),
        ],
      ),
    );

    final total = paidMinor + dueMinor;
    return Semantics(
      container: true,
      label: past ? l.insightsCashLabelPast(paid, due) : l.insightsCashLabel(paid, due),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          row(LegendSquare(color: c.brand), l.insightsPaid, paid),
          row(past ? LegendSquare(color: c.surface2) : const LegendSquare(), dueLabel, due),
          const SizedBox(height: 4),
          SizedBox(
            height: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: total == 0
                  ? ColoredBox(color: c.surface2)
                  : Row(
                      children: [
                        if (paidMinor > 0)
                          Expanded(
                            flex: paidMinor,
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 4),
                              decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                        if (paidMinor > 0 && dueMinor > 0) const SizedBox(width: 3),
                        if (dueMinor > 0)
                          Expanded(
                            flex: dueMinor,
                            child: past
                                ? DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: c.surface2,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  )
                                : ClipRRect(borderRadius: BorderRadius.circular(2), child: const Hatch()),
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
