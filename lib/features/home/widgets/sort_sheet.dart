import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../home_list.dart';

String sortLabel(AppLocalizations l, HomeSort s) => switch (s) {
  HomeSort.dueDate => l.homeSortDue,
  HomeSort.price => l.homeSortPrice,
  HomeSort.name => l.homeSortName,
  HomeSort.recent => l.homeSortRecent,
};

IconData _sortIcon(HomeSort s) => switch (s) {
  HomeSort.dueDate => LucideIcons.calendarDays,
  HomeSort.price => LucideIcons.coins,
  HomeSort.name => LucideIcons.arrowDownAZ,
  HomeSort.recent => LucideIcons.clock,
};

/// S2 sort sheet (mockup v14 png 023, `sortSheet()`): "Sort by", flat radio rows — Next payment ·
/// Price · Name · Recently added — each with its icon. A tap applies ([onChanged]) and closes.
Future<void> showSortSheet(
  BuildContext context, {
  required HomeSort current,
  required ValueChanged<HomeSort> onChanged,
}) {
  final l = context.l10n;
  return showAppSheet<void>(
    context,
    builder: (ctx) => AppSheet(
      title: l.homeSortTitle,
      child: SingleChildScrollView(
        child: RadioRowGroup<HomeSort>(
          style: RadioRowStyle.flat,
          value: current,
          onChanged: (v) {
            onChanged(v);
            Navigator.pop(ctx);
          },
          options: [
            for (final s in HomeSort.values)
              RadioOption(
                value: s,
                title: sortLabel(l, s),
                trailing: Icon(_sortIcon(s), size: 20, color: ctx.colors.inkMuted),
              ),
          ],
        ),
      ),
    ),
    bare: true,
  );
}
