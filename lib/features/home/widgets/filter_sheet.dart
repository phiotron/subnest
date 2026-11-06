import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../home_list.dart';

String statusLabel(AppLocalizations l, HomeStatus s) => switch (s) {
  HomeStatus.active => l.homeTabActive,
  HomeStatus.trial => l.homeTrialBadge,
  HomeStatus.paused => l.commonStatusPaused,
  HomeStatus.cancelled => l.homeTabCancelled,
};

/// S2 filter sheet (png 16): "Filter" + Reset, then Status · Category · Labels · Payment method,
/// all multi-select chips; a note that the choice is remembered; "Show N subscriptions" applies.
/// Empty groups (no labels / payment methods yet) are left out. Categories list only the ones in
/// use (plus any already picked). Returns the new filter, or `null` when dismissed.
Future<HomeFilter?> showFilterSheet(
  BuildContext context, {
  required HomeFilter current,
  required List<Category> categories,
  required List<Label> labels,
  required List<PaymentMethod> paymentMethods,
  required int Function(HomeFilter) countFor,
}) {
  var value = current;
  return showAppSheet<HomeFilter>(
    context,
    bare: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final l = ctx.l10n;
        final c = ctx.colors;
        Set<T> toggle<T>(Set<T> set, T v) => set.contains(v) ? ({...set}..remove(v)) : {...set, v};
        Widget group(String title, List<Widget> chips) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s5, AppSpace.s1, AppSpace.s1),
              child: Semantics(
                header: true,
                child: Text(title.toUpperCase(), style: AppType.caption.copyWith(color: c.inkMuted)),
              ),
            ),
            Wrap(spacing: AppSpace.s2, children: chips),
          ],
        );
        final n = countFor(value);
        return AppSheet(
          actions: [
            AppButton.primary(
              label: l.homeFilterShow(n),
              expand: true,
              onPressed: n == 0 ? null : () => Navigator.pop(ctx, value),
            ),
          ],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(l.homeFilter, style: AppType.title.copyWith(color: c.ink)),
                      ),
                    ),
                    TextButton(
                      onPressed: value.isEmpty ? null : () => setState(() => value = HomeFilter.none),
                      child: Text(l.homeFilterReset),
                    ),
                  ],
                ),
                group(l.homeFilterStatus, [
                  for (final s in HomeStatus.values)
                    AppChip(
                      label: statusLabel(l, s),
                      selected: value.statuses.contains(s),
                      onTap: () => setState(() => value = value.copyWith(statuses: toggle(value.statuses, s))),
                    ),
                ]),
                if (categories.isNotEmpty)
                  group(l.homeFilterCategory, [
                    for (final cat in categories)
                      AppChip(
                        label: l.categoryName(cat),
                        selected: value.categoryIds.contains(cat.id),
                        onTap: () =>
                            setState(() => value = value.copyWith(categoryIds: toggle(value.categoryIds, cat.id))),
                      ),
                  ]),
                if (labels.isNotEmpty)
                  group(l.homeFilterLabels, [
                    for (final lb in labels)
                      AppChip(
                        label: lb.name,
                        selected: value.labelIds.contains(lb.id),
                        icon: LucideIcons.tag,
                        onTap: () => setState(() => value = value.copyWith(labelIds: toggle(value.labelIds, lb.id))),
                      ),
                  ]),
                if (paymentMethods.isNotEmpty)
                  group(l.homeFilterPayment, [
                    for (final m in paymentMethods)
                      AppChip(
                        label: m.name,
                        selected: value.paymentMethodIds.contains(m.id),
                        onTap: () => setState(
                          () => value = value.copyWith(paymentMethodIds: toggle(value.paymentMethodIds, m.id)),
                        ),
                      ),
                  ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(AppIcons.info, size: 14, color: c.inkMuted),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(l.homeFilterRemember, style: AppType.meta.copyWith(color: c.inkMuted)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
