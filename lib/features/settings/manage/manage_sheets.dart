import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import 'manage_widgets.dart';

/// New / edit a Category (mockup 107): preview tile + name, Colour, Icon, Save, Delete category
/// (→ 108). A built-in category left with its translated name keeps following the language.
Future<void> showCategorySheet(BuildContext context, {Category? category}) =>
    showAppSheet<void>(context, builder: (_) => _CategorySheet(category: category));

/// New / edit a Label (mockup 109): name + colour, Save, Delete label.
Future<void> showLabelSheet(BuildContext context, {Label? label}) =>
    showAppSheet<void>(context, builder: (_) => _LabelSheet(label: label));

/// New / edit a Payment method (mockup 110): name, Save, Delete payment method.
Future<void> showPaymentMethodSheet(BuildContext context, {PaymentMethod? method}) =>
    showAppSheet<void>(context, builder: (_) => _MethodSheet(method: method));

/// Set / change / remove a budget — the monthly total ([category] null) or one category's (111).
Future<void> showBudgetSheet(BuildContext context, {Budget? budget, Category? category}) => showAppSheet<void>(
  context,
  builder: (_) => _BudgetSheet(budget: budget, category: category),
);

Widget _head(BuildContext context, String text) =>
    SectionHeader(label: text, padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s4, AppSpace.s1, AppSpace.s2));

class _CategorySheet extends ConsumerStatefulWidget {
  const _CategorySheet({this.category});

  final Category? category;

  @override
  ConsumerState<_CategorySheet> createState() => _CategorySheetState();
}

class _CategorySheetState extends ConsumerState<_CategorySheet> {
  late final TextEditingController _name;
  late int _color;
  late String _icon;
  String? _error;
  String? _builtInName;

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    _color = cat?.colorValue ?? kManageSwatches[6];
    _icon = cat == null ? 'circle-ellipsis' : categoryIconKey(cat);
    _name = TextEditingController(text: cat?.name ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cat = widget.category;
    if (cat != null && cat.name == null && _builtInName == null) {
      _builtInName = context.l10n.categoryName(cat);
      _name.text = _builtInName!;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final text = _name.text.trim();
    if (text.isEmpty) {
      setState(() => _error = l.manageNameRequired);
      return;
    }
    final repo = ref.read(organizeRepositoryProvider);
    final cat = widget.category;
    if (cat == null) {
      await repo.addCategory(name: text, colorValue: _color, icon: _icon);
    } else {
      // A built-in whose name was not changed stays translated (name null).
      final name = cat.isBuiltIn && text == _builtInName ? null : text;
      await repo.saveCategory(cat.copyWith(name: name, colorValue: _color, icon: _icon));
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final cat = widget.category!;
    final deleted = await showDeleteCategoryDialog(context, ref, cat);
    if (deleted && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cat = widget.category;
    final c = context.colors;
    return AppSheet(
      title: cat == null ? l.manageNewCategory : l.manageEditCategory,
      actions: [
        AppButton.primary(label: l.commonSave, expand: true, onPressed: _save),
        if (cat != null && CategoryRules.canDelete(cat))
          DangerTextButton(label: l.manageDeleteCategory, onPressed: _delete),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColorTile(color: Color(_color), icon: kCategoryIcons[_icon]!, size: 56),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: NameField(
                    controller: _name,
                    hint: l.manageName,
                    errorText: _error,
                    onSubmitted: (_) => _save(),
                  ),
                ),
              ],
            ),
            _head(context, l.manageColour),
            SwatchPicker(selected: _color, onChanged: (v) => setState(() => _color = v)),
            _head(context, l.manageIcon),
            LayoutBuilder(
              builder: (context, box) {
                const gap = 6.0;
                final size = ((box.maxWidth - gap * 7) / 8).clamp(36.0, 56.0);
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final MapEntry(:key, :value) in kCategoryIcons.entries)
                      Semantics(
                        button: true,
                        selected: key == _icon,
                        label: key,
                        child: GestureDetector(
                          onTap: () => setState(() => _icon = key),
                          child: Container(
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: key == _icon ? c.brandSoft : c.surface2,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: key == _icon ? Border.all(color: c.brand, width: 2) : null,
                            ),
                            child: Icon(value, size: 20, color: key == _icon ? c.onBrandSoft : c.ink),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Delete a Category (mockup 108): when subscriptions use it, pick where they move (default
/// "Other"); "Move and delete". True when it was deleted.
Future<bool> showDeleteCategoryDialog(BuildContext context, WidgetRef ref, Category cat) async {
  final subs = ref.read(subscriptionsProvider).value ?? const <Subscription>[];
  final count = subs.where((s) => s.categoryId == cat.id).length;
  final targets = [
    for (final x in ref.read(categoriesProvider).value ?? const <Category>[])
      if (x.id != cat.id) x,
  ]..sort((a, b) => a.id == CategoryRules.fallbackId ? -1 : (b.id == CategoryRules.fallbackId ? 1 : 0));
  final target = await showDialog<String>(
    context: context,
    builder: (_) => _DeleteCategoryDialog(category: cat, count: count, targets: targets),
  );
  if (target == null) return false;
  await ref.read(organizeRepositoryProvider).deleteCategory(cat.id, moveTo: target);
  return true;
}

class _DeleteCategoryDialog extends StatefulWidget {
  const _DeleteCategoryDialog({required this.category, required this.count, required this.targets});

  final Category category;
  final int count;
  final List<Category> targets;

  @override
  State<_DeleteCategoryDialog> createState() => _DeleteCategoryDialogState();
}

class _DeleteCategoryDialogState extends State<_DeleteCategoryDialog> {
  String _target = CategoryRules.fallbackId;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final moving = widget.count > 0;
    return AppDialog(
      title: l.manageDeleteTitle(l.categoryName(widget.category)),
      body: moving ? l.manageDeleteMoveBody(widget.count) : l.manageDeleteUnusedBody,
      content: moving
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final t in widget.targets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpace.s2),
                        child: Semantics(
                          selected: t.id == _target,
                          inMutuallyExclusiveGroup: true,
                          button: true,
                          label: l.manageMoveCategory(l.categoryName(t)),
                          excludeSemantics: true,
                          child: Material(
                            color: t.id == _target ? c.brandSoft : c.surface2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              side: t.id == _target ? BorderSide(color: c.brand, width: 2) : BorderSide.none,
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              onTap: () => setState(() => _target = t.id),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                child: Row(
                                  children: [
                                    RadioMark(
                                      selected: t.id == _target,
                                      gapColor: t.id == _target ? c.brandSoft : c.surface2,
                                    ),
                                    const SizedBox(width: AppSpace.s3),
                                    CategoryTile(t, size: 28),
                                    const SizedBox(width: AppSpace.s3),
                                    Expanded(
                                      child: Text(l.categoryName(t), style: AppType.titleSm.copyWith(color: c.ink)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : null,
      actions: [
        AppButton.danger(
          label: moving ? l.manageMoveAndDelete : l.commonDelete,
          expand: true,
          onPressed: () => Navigator.pop(context, _target),
        ),
        AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}

class _LabelSheet extends ConsumerStatefulWidget {
  const _LabelSheet({this.label});

  final Label? label;

  @override
  ConsumerState<_LabelSheet> createState() => _LabelSheetState();
}

class _LabelSheetState extends ConsumerState<_LabelSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.label?.name ?? '');
  late int _color = widget.label?.colorValue ?? kManageSwatches[7];
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _name.text.trim();
    if (text.isEmpty) {
      setState(() => _error = context.l10n.manageNameRequired);
      return;
    }
    final repo = ref.read(organizeRepositoryProvider);
    final label = widget.label;
    if (label == null) {
      await repo.addLabel(text, colorValue: _color);
    } else {
      await repo.saveLabel(label.copyWith(name: text, colorValue: _color));
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await _confirmDelete(context, l.manageDeleteTitle(widget.label!.name), l.manageDeleteLabelBody);
    if (!ok) return;
    await ref.read(organizeRepositoryProvider).deleteLabel(widget.label!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppSheet(
      title: widget.label == null ? l.manageNewLabel : l.manageEditLabel,
      actions: [
        AppButton.primary(label: l.commonSave, expand: true, onPressed: _save),
        if (widget.label != null) DangerTextButton(label: l.manageDeleteLabel, onPressed: _delete),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColorTile(color: Color(_color), icon: LucideIcons.tag, size: 56),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: NameField(
                    controller: _name,
                    hint: l.manageName,
                    errorText: _error,
                    onSubmitted: (_) => _save(),
                  ),
                ),
              ],
            ),
            _head(context, l.manageColour),
            SwatchPicker(selected: _color, onChanged: (v) => setState(() => _color = v)),
          ],
        ),
      ),
    );
  }
}

class _MethodSheet extends ConsumerStatefulWidget {
  const _MethodSheet({this.method});

  final PaymentMethod? method;

  @override
  ConsumerState<_MethodSheet> createState() => _MethodSheetState();
}

class _MethodSheetState extends ConsumerState<_MethodSheet> {
  late final TextEditingController _name = TextEditingController(text: widget.method?.name ?? '');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _name.text.trim();
    if (text.isEmpty) {
      setState(() => _error = context.l10n.manageNameRequired);
      return;
    }
    final repo = ref.read(organizeRepositoryProvider);
    final m = widget.method;
    if (m == null) {
      await repo.addPaymentMethod(text);
    } else {
      await repo.savePaymentMethod(m.copyWith(name: text));
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await _confirmDelete(context, l.manageDeleteTitle(widget.method!.name), l.manageDeletePaymentMethodBody);
    if (!ok) return;
    await ref.read(organizeRepositoryProvider).deletePaymentMethod(widget.method!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AppSheet(
      title: widget.method == null ? l.manageAddPaymentMethod : l.manageEditPaymentMethod,
      actions: [
        AppButton.primary(label: l.commonSave, expand: true, onPressed: _save),
        if (widget.method != null) DangerTextButton(label: l.manageDeletePaymentMethod, onPressed: _delete),
      ],
      child: NameField(controller: _name, hint: l.manageName, errorText: _error, onSubmitted: (_) => _save()),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context, String title, String body) async {
  final l = context.l10n;
  final ok = await showAppDialog<bool>(
    context,
    title: title,
    body: body,
    actions: [
      Builder(
        builder: (ctx) =>
            AppButton.danger(label: l.commonDelete, expand: true, onPressed: () => Navigator.pop(ctx, true)),
      ),
      Builder(
        builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
      ),
    ],
  );
  return ok == true;
}

class _BudgetSheet extends ConsumerStatefulWidget {
  const _BudgetSheet({this.budget, this.category});

  final Budget? budget;
  final Category? category;

  @override
  ConsumerState<_BudgetSheet> createState() => _BudgetSheetState();
}

class _BudgetSheetState extends ConsumerState<_BudgetSheet> {
  double? _amount;
  String? _error;

  @override
  void initState() {
    super.initState();
    final b = widget.budget;
    if (b != null) _amount = toMajorUnits(b.amountMinor, b.currency);
  }

  String get _currency => widget.budget?.currency ?? ref.read(primaryCurrencyProvider);

  Future<void> _save() async {
    final v = _amount;
    if (v == null || v <= 0) {
      setState(() => _error = context.l10n.manageBudgetInvalid);
      return;
    }
    await ref
        .read(organizeRepositoryProvider)
        .setBudget(categoryId: widget.category?.id, amountMinor: toMinorUnits(v, _currency), currency: _currency);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _remove() async {
    await ref.read(organizeRepositoryProvider).removeBudget(categoryId: widget.category?.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cat = widget.category;
    return AppSheet(
      title: cat == null ? l.manageBudgetTotal : l.manageBudgetFor(l.categoryName(cat)),
      actions: [
        AppButton.primary(label: l.commonSave, expand: true, onPressed: _save),
        if (widget.budget != null) DangerTextButton(label: l.manageBudgetRemove, onPressed: _remove),
      ],
      child: AmountField(
        value: _amount,
        currency: _currency,
        label: l.manageBudgetAmount,
        autofocus: true,
        boxed: true,
        errorText: _error,
        onChanged: (v) => setState(() {
          _amount = v;
          _error = null;
        }),
      ),
    );
  }
}
