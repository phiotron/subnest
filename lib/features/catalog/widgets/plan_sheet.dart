import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../catalog_helpers.dart';

/// S3 plan sheet (v13 png 25; only plans on sale, Reference prices marked in the subtitle): tile + name + "Choose a plan · suggested prices for Vietnam", one
/// [RadioRow] card per plan with its regional price, a note and "Continue with Premium".
/// Returns the chosen plan, or `null` when dismissed. Also used by S4's plan chip.
Future<CatalogPlan?> showPlanSheet(
  BuildContext context, {
  required CatalogService service,
  required String region,
  CatalogPlan? initial,
}) {
  return showAppSheet<CatalogPlan>(
    context,
    builder: (_) => PlanSheet(service: service, region: region, initial: initial),
  );
}

class PlanSheet extends StatefulWidget {
  const PlanSheet({super.key, required this.service, required this.region, this.initial});

  final CatalogService service;
  final String region;
  final CatalogPlan? initial;

  @override
  State<PlanSheet> createState() => _PlanSheetState();
}

class _PlanSheetState extends State<PlanSheet> {
  late final List<CatalogPlan> _plans = CatalogView.plans(widget.service, widget.region);
  late String? _selected =
      (widget.initial != null && _plans.any((p) => p.id == widget.initial!.id) ? widget.initial : _plans.firstOrNull)
          ?.id;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = widget.service;
    final chosen = _plans.where((p) => p.id == _selected).firstOrNull;
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
                    ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram, size: 56),
                    const SizedBox(width: AppSpace.s4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(s.name, style: AppType.title.copyWith(color: c.ink)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.region == 'VN' ? l.catalogPlanSubVietnam : l.catalogPlanSub,
                            style: AppType.meta.copyWith(color: c.inkMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpace.s5),
                RadioRowGroup<String>(
                  value: _selected,
                  onChanged: (id) => setState(() => _selected = id),
                  options: [
                    for (final p in _plans)
                      RadioOption(
                        value: p.id,
                        title: p.name,
                        subtitle: [
                          CatalogView.planSubtitle(l, p),
                          if (p.priceFor(widget.region)?.isReference ?? false) l.commonReferencePrice,
                        ].join(' · '),
                        trailing: _price(context, p),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpace.s3),
                Text(l.catalogPlanNote, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        AppButton.primary(
          label: chosen == null ? l.commonContinue : l.catalogContinueWith(chosen.name),
          expand: true,
          onPressed: chosen == null ? null : () => Navigator.pop(context, chosen),
        ),
      ],
    );
  }

  Widget? _price(BuildContext context, CatalogPlan p) {
    final l = context.l10n;
    final price = p.priceFor(widget.region);
    if (price == null) return null;
    return RadioRow.price(context, l.amount(price.amount, price.currency), suffix: perCycle(l, p.cycle));
  }
}
