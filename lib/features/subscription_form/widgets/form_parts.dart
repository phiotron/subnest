import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// Form card (design `.group`): `surface` card with 16px-indented hairlines between [FormFieldPad]s.
/// [error] draws the 2px `danger` ring of an invalid field (png 21).
class FormCard extends StatelessWidget {
  const FormCard({super.key, required this.children, this.error = false});

  final List<Widget> children;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final group = AppGroup(dividerIndent: AppSpace.s4, children: children);
    if (!error) return group;
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: context.colors.danger, width: 2),
      ),
      child: group,
    );
  }
}

/// Padding of one field inside a [FormCard] (design `.field`: 16px).
class FormFieldPad extends StatelessWidget {
  const FormFieldPad({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(AppSpace.s4), child: child);
}

/// Inline validation message: `danger` alert icon + text (design `.f-err`).
class FieldError extends StatelessWidget {
  const FieldError(this.text, {super.key, this.alignEnd = false});

  final String text;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpace.s2),
        child: Row(
          mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(AppIcons.alert, size: 14, color: c.danger),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(text, style: AppType.meta.copyWith(color: c.danger)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Label on the left, control on the right; drops the control under the label when the line is
/// too narrow (VI, 200% text) instead of squeezing either.
class LabelledRow extends StatelessWidget {
  const LabelledRow({super.key, required this.label, required this.trailing});

  final Widget label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceBetween,
    crossAxisAlignment: WrapCrossAlignment.center,
    spacing: AppSpace.s3,
    runSpacing: AppSpace.s2,
    children: [label, trailing],
  );
}

/// Title + meta on the left, [AppToggle] on the right (Free trial, Split with others).
class ToggleField extends StatelessWidget {
  const ToggleField({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return MergeSemantics(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppType.label.copyWith(color: c.ink)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.s3),
            AppToggle(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

/// `surface-2` value button (design `.mini-field`): date "Fri, 4 Dec 2026 📅", "month ⌄".
/// [error] = `danger` text + ring. ≥ 48dp tall.
class MiniFieldButton extends StatelessWidget {
  const MiniFieldButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.error = false,
    this.semanticLabel,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool error;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = error ? c.danger : c.ink;
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: Material(
        color: c.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: error ? BorderSide(color: c.danger, width: 2) : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s3, vertical: AppSpace.s2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(label, style: AppType.titleSm.copyWith(color: fg).tabular),
                  ),
                  const SizedBox(width: AppSpace.s2),
                  Icon(icon, size: 18, color: fg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The "N" of "Every [N] [month]": a small `surface-2` number field, 1–999.
class EveryCountField extends StatelessWidget {
  const EveryCountField({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: context.l10n.subscriptionFormEveryCount,
      child: SizedBox(
        width: 56,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
          style: AppType.titleSm.copyWith(color: c.ink).tabular,
          decoration: const InputDecoration(
            isDense: true,
            hintText: '1',
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpace.s1, vertical: 14),
            constraints: BoxConstraints(minHeight: 48),
          ),
          onChanged: (v) {
            final n = int.tryParse(v);
            if (n != null && n >= 1) onChanged(n);
          },
        ),
      ),
    );
  }
}

/// "month ⌄" menu for the cycle unit.
class CycleUnitButton extends StatelessWidget {
  const CycleUnitButton({super.key, required this.unit, required this.every, required this.onChanged});

  final CycleUnit unit;
  final int every;
  final ValueChanged<CycleUnit> onChanged;

  static String label(AppLocalizations l, CycleUnit u, int n) => switch (u) {
    CycleUnit.day => l.subscriptionFormUnitDay(n),
    CycleUnit.week => l.subscriptionFormUnitWeek(n),
    CycleUnit.month => l.subscriptionFormUnitMonth(n),
    CycleUnit.year => l.subscriptionFormUnitYear(n),
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return PopupMenuButton<CycleUnit>(
      initialValue: unit,
      onSelected: onChanged,
      tooltip: l.subscriptionFormUnitLabel(label(l, unit, every)),
      color: c.surfaceSheet,
      itemBuilder: (_) => [
        for (final u in CycleUnit.values)
          PopupMenuItem(
            value: u,
            child: Text(label(l, u, every), style: AppType.body.copyWith(color: c.ink)),
          ),
      ],
      child: IgnorePointer(
        child: ExcludeSemantics(
          child: MiniFieldButton(label: label(l, unit, every), icon: AppIcons.expand, onTap: () {}),
        ),
      ),
    );
  }
}
