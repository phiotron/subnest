import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../catalog/catalog_helpers.dart';
import '../quick_pick.dart';
import 'onboarding_parts.dart';

/// S1.3 "What do you pay for?" (png 05): search, multi-select grid of service tiles (✓ when
/// picked), a quick-edit card for the last pick (price · cycle · Edit), and the bottom bar
/// "5 selected · ≈ ₫965,000/month" with Later / Continue.
class PickStep extends StatefulWidget {
  const PickStep({
    super.key,
    required this.services,
    required this.picks,
    required this.lastPicked,
    required this.monthlyTotal,
    required this.totalCurrency,
    required this.onToggle,
    required this.onEdit,
    required this.onLater,
    required this.onNext,
  });

  /// Catalog in display order (popular first).
  final List<CatalogService> services;

  /// Picked service id → pick.
  final Map<String, QuickPick> picks;
  final String? lastPicked;

  /// ≈ Monthly cost of all picks in the main currency (`null` when nothing is picked).
  final double? monthlyTotal;
  final String totalCurrency;
  final ValueChanged<CatalogService> onToggle;
  final ValueChanged<String> onEdit;
  final VoidCallback onLater;
  final VoidCallback onNext;

  @override
  State<PickStep> createState() => _PickStepState();
}

class _PickStepState extends State<PickStep> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final shown = CatalogView.search(widget.services, _query);
    final last = widget.lastPicked == null ? null : widget.picks[widget.lastPicked];
    final scale = MediaQuery.textScalerOf(context).scale(1);
    // Fewer columns as text grows so names never break mid-word (130% → 3, 200% → 2).
    final columns = scale > 1.6 ? 2 : (scale > 1.15 ? 3 : 4);
    final rows = <List<CatalogService>>[
      for (var i = 0; i < shown.length; i += columns) shown.sublist(i, (i + columns).clamp(0, shown.length)),
    ];

    return OnboardingStepScaffold(
      step: 3,
      scrollBody: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s6, AppSpace.s5, AppSpace.s4),
            child: OnboardingTitle(l.onboardingPickTitle),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s5),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              textInputAction: TextInputAction.search,
              style: AppType.body.copyWith(color: c.ink),
              decoration: InputDecoration(
                hintText: l.onboardingPickSearch,
                prefixIcon: Icon(AppIcons.search, size: 20, color: c.inkMuted),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          Expanded(
            child: Stack(
              children: [
                if (shown.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(AppSpace.s6),
                    child: Text(
                      l.onboardingPickNoMatch(_query.trim()),
                      textAlign: TextAlign.center,
                      style: AppType.body.copyWith(color: c.inkMuted),
                    ),
                  )
                else
                  ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, last == null ? AppSpace.s4 : 112),
                    itemCount: rows.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.s2),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var j = 0; j < columns; j++) ...[
                              if (j > 0) const SizedBox(width: AppSpace.s2),
                              Expanded(
                                child: j < rows[i].length
                                    ? _PickCell(
                                        service: rows[i][j],
                                        selected: widget.picks.containsKey(rows[i][j].id),
                                        onTap: () => widget.onToggle(rows[i][j]),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                if (last != null)
                  Positioned(
                    left: AppSpace.s4,
                    right: AppSpace.s4,
                    bottom: AppSpace.s3,
                    child: _QuickCard(pick: last, onEdit: () => widget.onEdit(last.service.id)),
                  ),
              ],
            ),
          ),
        ],
      ),
      footer: _PickBar(
        count: widget.picks.length,
        total: widget.monthlyTotal == null
            ? null
            : '${l.amount(widget.monthlyTotal!, widget.totalCurrency, approx: true)}'
                  '${perCycle(l, const BillingCycle.monthly())}',
        onLater: widget.onLater,
        onNext: widget.onNext,
      ),
    );
  }
}

/// Grid cell (design `.pick`): 56px tile (+ ✓ badge when picked) over the name; picked cells
/// sit on `brand-soft`.
class _PickCell extends StatelessWidget {
  const _PickCell({required this.service, required this.selected, required this.onTap});

  final CatalogService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = service;
    return Semantics(
      button: true,
      selected: selected,
      label: s.name,
      excludeSemantics: true,
      child: Material(
        color: selected ? c.brandSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s3, AppSpace.s1, AppSpace.s3),
            child: Column(
              children: [
                SizedBox(
                  width: 64,
                  height: 60,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 4,
                        top: 4,
                        child: ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram, size: 56),
                      ),
                      if (selected)
                        Positioned(
                          right: -4,
                          top: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: c.brand,
                              shape: BoxShape.circle,
                              border: Border.all(color: c.brandSoft, width: 2),
                            ),
                            child: Icon(AppIcons.check, size: 14, color: c.onBrand),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpace.s2),
                Text(
                  s.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppType.meta.copyWith(color: c.ink, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Floating card for the last pick (design `.quick`): tile 24 · name + "₫59,000/month · Monthly"
/// · Edit.
class _QuickCard extends StatelessWidget {
  const _QuickCard({required this.pick, required this.onEdit});

  final QuickPick pick;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = pick.service;
    final price = pick.hasPrice ? '${l.money(Money(pick.priceMinor, pick.currency))}${perCycle(l, pick.cycle)}' : '—';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: context.elevation.float,
        border: Border.all(color: c.line),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.s3, AppSpace.s2, AppSpace.s2, AppSpace.s2),
        child: Row(
          children: [
            ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram, size: 24),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pick.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.label.copyWith(color: c.ink),
                  ),
                  Text(
                    l.onboardingPickMeta(price, l.cycle(pick.cycle)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.meta.copyWith(color: c.inkMuted).tabular,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.s2),
            Semantics(
              label: l.onboardingPickEditLabel(pick.name),
              button: true,
              excludeSemantics: true,
              child: AppButton.tonal(label: l.onboardingPickEdit, icon: AppIcons.edit, small: true, onPressed: onEdit),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom bar (design `.pick-bar`): count + ≈ monthly total, Later, Continue. The buttons move
/// under the text when the line is too narrow (VI, large text).
class _PickBar extends StatelessWidget {
  const _PickBar({required this.count, required this.total, required this.onLater, required this.onNext});

  final int count;
  final String? total;
  final VoidCallback onLater;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s3),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpace.s3,
          runSpacing: AppSpace.s2,
          children: [
            Semantics(
              liveRegion: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.onboardingPickSelected(count), style: AppType.label.copyWith(color: c.ink)),
                  if (total != null) Text(total!, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.text(label: l.onboardingLater, small: true, onPressed: onLater),
                const SizedBox(width: AppSpace.s2),
                AppButton.primary(label: l.commonContinue, small: true, onPressed: onNext),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
