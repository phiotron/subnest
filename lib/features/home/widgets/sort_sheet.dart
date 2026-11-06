import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../home_list.dart';

String sortLabel(AppLocalizations l, HomeSort s) => switch (s) {
  HomeSort.dueDate => l.homeSortDue,
  HomeSort.price => l.homeSortPrice,
  HomeSort.name => l.homeSortName,
};

/// S2 sort sheet (png 15): flat radio rows in a group + "Done". Each tap applies at once
/// ([onChanged]); "Done", a scrim tap or a drag closes it.
Future<void> showSortSheet(
  BuildContext context, {
  required HomeSort current,
  required ValueChanged<HomeSort> onChanged,
}) {
  final l = context.l10n;
  var value = current;
  return showAppSheet<void>(
    context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AppSheet(
        title: l.homeSortTitle,
        actions: [AppButton.tonal(label: l.homeSortDone, expand: true, onPressed: () => Navigator.pop(ctx))],
        child: SingleChildScrollView(
          child: RadioRowGroup<HomeSort>(
            style: RadioRowStyle.flat,
            value: value,
            onChanged: (v) {
              setState(() => value = v);
              onChanged(v);
            },
            options: [
              RadioOption(value: HomeSort.dueDate, title: l.homeSortDue, subtitle: l.homeSortDueHint),
              RadioOption(value: HomeSort.price, title: l.homeSortPrice, subtitle: l.homeSortPriceHint),
              RadioOption(value: HomeSort.name, title: l.homeSortName, subtitle: l.homeSortNameHint),
            ],
          ),
        ),
      ),
    ),
    bare: true,
  );
}
