import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

// S4 v13 groups (png 26, 36, 37): Labels, Payment method, Remind me (several offsets), Worth it?.
// Kept in the feature for now; [DotChip] and [WorthItPicker] are candidates for core/widgets
// (S5 Detail and S10 Settings show the same pieces).

/// Label chip (design `.chip` with a colour dot): `surface-2` pill with the label's dot at rest;
/// selected = `brand` with a check. [dashed] = the "+ New label" chip (`line-strong` ring).
/// 36px pill inside a 48dp touch target (S-50).
class DotChip extends StatelessWidget {
  const DotChip({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.dotColor,
    this.dashed = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? dotColor;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onBrand : (dashed ? c.inkMuted : c.ink);
    final Widget lead = selected
        ? Icon(AppIcons.check, size: 16, color: fg)
        : dashed
        ? Icon(AppIcons.add, size: 16, color: fg)
        : Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: dotColor ?? c.inkMuted, shape: BoxShape.circle),
          );
    final pill = AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.ease,
      constraints: const BoxConstraints(minHeight: 36, minWidth: 44),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: ShapeDecoration(
        color: selected ? c.brand : (dashed ? Colors.transparent : c.surface2),
        shape: StadiumBorder(side: dashed ? BorderSide(color: c.lineStrong, width: 1.5) : BorderSide.none),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          lead,
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: AppType.label.copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: fg),
            ),
          ),
        ],
      ),
    );
    return Semantics(
      button: true,
      selected: dashed ? null : selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: AppTouch.min),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: (AppTouch.min - 36) / 2),
            child: Center(widthFactor: 1, child: pill),
          ),
        ),
      ),
    );
  }
}

/// "Worth it?" picker (design `.worth`): four equal cells — Not rated · Worth it · Unsure ·
/// Not worth — icon over a 12/600 label. Selected: Worth it = `brand-soft` + `brand` ring,
/// Unsure = `warning-soft`, Not worth = `danger-soft`. ≥ 150% text: 2 × 2 grid.
class WorthItPicker extends StatelessWidget {
  const WorthItPicker({super.key, required this.value, required this.onChanged});

  final WorthIt? value;
  final ValueChanged<WorthIt?> onChanged;

  static const _options = <(WorthIt?, IconData)>[
    (null, LucideIcons.circleEllipsis),
    (WorthIt.worth, LucideIcons.thumbsUp),
    (WorthIt.unsure, LucideIcons.circleQuestionMark),
    (WorthIt.notWorth, LucideIcons.thumbsDown),
  ];

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5;
    final rows = large
        ? const [
            [0, 1],
            [2, 3],
          ]
        : const [
            [0, 1, 2, 3],
          ];
    return Semantics(
      container: true,
      label: context.l10n.subscriptionFormWorthIt,
      child: Column(
        children: [
          for (final row in rows) ...[
            if (row.first > 0) const SizedBox(height: 6),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final i in row) ...[
                    if (i != row.first) const SizedBox(width: 6),
                    Expanded(child: _cell(context, _options[i])),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, (WorthIt?, IconData) o) {
    final c = context.colors;
    final l = context.l10n;
    final on = value == o.$1;
    final (Color bg, Color fg, Color? ring) = !on
        ? (c.surface2, c.inkMuted, null)
        : switch (o.$1) {
            WorthIt.notWorth => (c.dangerSoft, c.danger, c.danger),
            WorthIt.unsure => (c.warningSoft, c.warningInk, c.warning),
            _ => (c.brandSoft, c.onBrandSoft, c.brand),
          };
    final label = o.$1 == null ? l.subscriptionFormWorthNotRated : l.worthIt(o.$1);
    return Semantics(
      button: true,
      selected: on,
      label: label,
      excludeSemantics: true,
      onTap: () => onChanged(o.$1),
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: ring == null ? BorderSide.none : BorderSide(color: ring, width: 2),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () => onChanged(o.$1),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(o.$2, size: 18, color: fg),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppType.meta.copyWith(fontSize: 12, height: 15 / 12, fontWeight: FontWeight.w600, color: fg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Result of the payment-method sheet: a method from the list, or [none] to clear it.
class PaymentMethodChoice {
  const PaymentMethodChoice(this.method);
  const PaymentMethodChoice.none() : method = null;

  final PaymentMethod? method;
}

/// S4 payment-method sheet (png 37): "Payment method" title, radio rows from the user's list
/// (managed in Settings) with how many subscriptions use each, "None", and an inline quick add
/// ([onAdd] creates the method and the sheet returns it). Names only — no bank connection.
Future<PaymentMethodChoice?> showPaymentMethodSheet(
  BuildContext context, {
  required List<PaymentMethod> methods,
  required Map<String, int> usage,
  required String? selectedId,
  required Future<PaymentMethod> Function(String name) onAdd,
}) => showAppSheet<PaymentMethodChoice>(
  context,
  builder: (_) => _PaymentMethodSheet(methods: methods, usage: usage, selectedId: selectedId, onAdd: onAdd),
);

class _PaymentMethodSheet extends StatefulWidget {
  const _PaymentMethodSheet({
    required this.methods,
    required this.usage,
    required this.selectedId,
    required this.onAdd,
  });

  final List<PaymentMethod> methods;
  final Map<String, int> usage;
  final String? selectedId;
  final Future<PaymentMethod> Function(String name) onAdd;

  @override
  State<_PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<_PaymentMethodSheet> {
  static const _none = '';
  final _name = TextEditingController();
  bool _adding = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text.trim();
    if (name.isEmpty || _adding) return;
    final existing = widget.methods
        .where((m) => PaymentMethod.normalizeName(m.name) == PaymentMethod.normalizeName(name))
        .firstOrNull;
    setState(() => _adding = true);
    final m = existing ?? await widget.onAdd(name);
    if (mounted) Navigator.pop(context, PaymentMethodChoice(m));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l.subscriptionFormPaymentMethod, style: AppType.title.copyWith(color: c.ink)),
        ),
        const SizedBox(height: AppSpace.s4),
        Flexible(
          child: SingleChildScrollView(
            child: RadioRowGroup<String>(
              style: RadioRowStyle.flat,
              value: widget.selectedId ?? _none,
              onChanged: (id) {
                final m = widget.methods.where((m) => m.id == id).firstOrNull;
                Navigator.pop(context, m == null ? const PaymentMethodChoice.none() : PaymentMethodChoice(m));
              },
              options: [
                for (final m in widget.methods)
                  RadioOption(
                    value: m.id,
                    title: m.name,
                    subtitle: l.subscriptionFormMethodUsage(widget.usage[m.id] ?? 0),
                  ),
                RadioOption(value: _none, title: l.subscriptionFormMethodNone),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _add(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: l.subscriptionFormMethodAddHint,
                  prefixIcon: Icon(AppIcons.add, size: 18, color: c.inkMuted),
                ),
              ),
            ),
            const SizedBox(width: AppSpace.s2),
            AppButton.primary(
              label: l.subscriptionFormAdd,
              small: true,
              loading: _adding,
              onPressed: _name.text.trim().isEmpty ? null : _add,
            ),
          ],
        ),
        const SizedBox(height: AppSpace.s3),
        Text(l.subscriptionFormMethodNote, style: AppType.meta.copyWith(color: c.inkMuted)),
      ],
    );
  }
}

/// "+ New label" sheet: one name field and Add. Returns the trimmed name, or `null`.
Future<String?> showNewLabelSheet(BuildContext context) =>
    showAppSheet<String>(context, builder: (_) => const _NewLabelSheet());

class _NewLabelSheet extends StatefulWidget {
  const _NewLabelSheet();

  @override
  State<_NewLabelSheet> createState() => _NewLabelSheetState();
}

class _NewLabelSheetState extends State<_NewLabelSheet> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _done() {
    final v = _name.text.trim();
    if (v.isNotEmpty) Navigator.pop(context, v);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(l.subscriptionFormNewLabel, style: AppType.title.copyWith(color: c.ink)),
        ),
        const SizedBox(height: AppSpace.s4),
        TextField(
          controller: _name,
          autofocus: true,
          maxLength: 24,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _done(),
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(hintText: l.subscriptionFormNewLabelHint),
        ),
        const SizedBox(height: AppSpace.s3),
        AppButton.primary(
          label: l.subscriptionFormAdd,
          expand: true,
          onPressed: _name.text.trim().isEmpty ? null : _done,
        ),
      ],
    );
  }
}
