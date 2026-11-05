import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../catalog/catalog_helpers.dart';
import '../quick_pick.dart';

/// Result of the quick editor: the edited values, or [remove] to untick the service.
class QuickEditResult {
  const QuickEditResult({this.plan, this.priceMinor = 0, this.currency = '', this.cycle, this.remove = false});

  const QuickEditResult.removed() : this(remove: true);

  final CatalogPlan? plan;
  final int priceMinor;
  final String currency;
  final BillingCycle? cycle;
  final bool remove;
}

/// Quick edit of one onboarding pick: plan (when several), price, billing cycle. Everything
/// else is edited later in S4.
Future<QuickEditResult?> showQuickEditSheet(BuildContext context, {required QuickPick pick, required String region}) {
  return showAppSheet<QuickEditResult>(
    context,
    builder: (_) => _QuickEditSheet(pick: pick, region: region),
  );
}

class _QuickEditSheet extends StatefulWidget {
  const _QuickEditSheet({required this.pick, required this.region});

  final QuickPick pick;
  final String region;

  @override
  State<_QuickEditSheet> createState() => _QuickEditSheetState();
}

class _QuickEditSheetState extends State<_QuickEditSheet> {
  late CatalogPlan? _plan = widget.pick.plan;
  late double? _price = widget.pick.hasPrice ? toMajorUnits(widget.pick.priceMinor, widget.pick.currency) : null;
  late String _currency = widget.pick.currency;
  late BillingCycle _cycle = widget.pick.cycle;

  static const _quick = [
    BillingCycle.weekly(),
    BillingCycle.monthly(),
    BillingCycle.quarterly(),
    BillingCycle.yearly(),
  ];

  void _choosePlan(String id) {
    final p = widget.pick.service.plans.firstWhere((x) => x.id == id);
    final price = p.priceFor(widget.region);
    setState(() {
      _plan = p;
      _cycle = p.cycle;
      if (price != null) {
        _price = price.amount;
        _currency = price.currency;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = widget.pick.service;
    final plans = CatalogView.plans(s, widget.region);
    final labels = [
      l.subscriptionFormChipWeekly,
      l.subscriptionFormChipMonthly,
      l.subscriptionFormChipQuarterly,
      l.subscriptionFormChipYearly,
    ];
    final valid = (_price ?? 0) > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram),
                    const SizedBox(width: AppSpace.s3),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(s.name, style: AppType.title.copyWith(color: c.ink)),
                      ),
                    ),
                  ],
                ),
                if (plans.length > 1) ...[
                  SectionHeader(
                    label: l.onboardingQuickPlan,
                    padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
                  ),
                  RadioRowGroup<String>(
                    style: RadioRowStyle.flat,
                    value: _plan?.id,
                    onChanged: _choosePlan,
                    options: [
                      for (final p in plans)
                        RadioOption(value: p.id, title: p.name, subtitle: CatalogView.planPrice(l, p, widget.region)),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpace.s5),
                AmountField(
                  value: _price,
                  currency: _currency,
                  label: l.onboardingQuickPrice,
                  onChanged: (v) => setState(() => _price = v),
                ),
                SectionHeader(
                  label: l.onboardingQuickCycle,
                  padding: const EdgeInsets.only(top: AppSpace.s5, bottom: AppSpace.s2),
                ),
                Row(
                  children: [
                    for (var i = 0; i < _quick.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: AppChip(
                          label: labels[i],
                          selected: _cycle == _quick[i],
                          showCheck: false,
                          fit: true,
                          onTap: () => setState(() => _cycle = _quick[i]),
                        ),
                      ),
                    ],
                  ],
                ),
                if (!_quick.contains(_cycle)) ...[
                  const SizedBox(height: AppSpace.s2),
                  Text(l.cycle(_cycle), style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s5),
        AppButton.primary(
          label: l.commonDone,
          expand: true,
          onPressed: valid
              ? () => Navigator.pop(
                  context,
                  QuickEditResult(
                    plan: _plan,
                    priceMinor: toMinorUnits(_price!, _currency),
                    currency: _currency,
                    cycle: _cycle,
                  ),
                )
              : null,
        ),
        const SizedBox(height: AppSpace.s2),
        AppButton.text(
          label: l.onboardingQuickRemove,
          expand: true,
          onPressed: () => Navigator.pop(context, const QuickEditResult.removed()),
        ),
      ],
    );
  }
}
