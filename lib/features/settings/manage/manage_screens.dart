import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../data/providers.dart';
import '../../../domain/domain.dart';
import '../settings_format.dart';
import '../widgets/settings_bits.dart';
import 'manage_sheets.dart';
import 'manage_widgets.dart';

// Settings › Organize (mockup v14 106–111, product.md §4.10 item 4). Class names + constructors are
// fixed by the router.

/// Shared frame: top bar, intro, content, optional tonal "+ New…" button under it.
class _ManageFrame extends StatelessWidget {
  const _ManageFrame({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.bg,
    appBar: AppTopBar(title: title),
    body: SafeArea(
      top: false,
      child: ListView(padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6), children: children),
    ),
  );
}

Map<String, int> _countBy(List<Subscription> subs, Iterable<String?> Function(Subscription) keys) {
  final out = <String, int>{};
  for (final s in subs) {
    for (final k in keys(s)) {
      if (k != null) out[k] = (out[k] ?? 0) + 1;
    }
  }
  return out;
}

/// Categories (mockup 106): drag the grip to reorder, tap to edit (107), "New category".
class ManageCategoriesScreen extends ConsumerWidget {
  const ManageCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final counts = _countBy(ref.watch(subscriptionsProvider).value ?? const [], (s) => [s.categoryId]);
    final repo = ref.read(organizeRepositoryProvider);
    return _ManageFrame(
      title: l.manageCategoriesTitle,
      children: [
        ManageIntro(l.manageCategoriesIntro),
        AppCard(
          padding: EdgeInsets.zero,
          child: ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: (from, to) {
              final ids = [for (final x in cats) x.id];
              ids.insert(to, ids.removeAt(from));
              repo.reorderCategories(ids);
            },
            children: [
              for (final (i, cat) in cats.indexed)
                Column(
                  key: ValueKey(cat.id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (i > 0) Divider(height: 1, thickness: 1, indent: 52, color: c.line),
                    ManageRow(
                      leading: CategoryTile(cat),
                      title: l.categoryName(cat),
                      subtitle: subCount(l, counts[cat.id] ?? 0),
                      onTap: () => showCategorySheet(context, category: cat),
                      trailing: ReorderableDragStartListener(
                        index: i,
                        child: Semantics(
                          label: l.manageReorderHint,
                          child: SizedBox(
                            width: AppTouch.min,
                            height: AppTouch.min,
                            child: Icon(LucideIcons.gripVertical, size: 18, color: c.inkMuted),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.s4),
        AppButton.tonal(
          label: l.manageNewCategory,
          icon: LucideIcons.plus,
          expand: true,
          onPressed: () => showCategorySheet(context),
        ),
      ],
    );
  }
}

/// Labels (mockup 109): coloured tag tile, name, how many subscriptions, pencil → edit sheet.
class ManageLabelsScreen extends ConsumerWidget {
  const ManageLabelsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final labels = ref.watch(labelsProvider).value ?? const <Label>[];
    final counts = _countBy(ref.watch(subscriptionsProvider).value ?? const [], (s) => s.labelIds);
    return _ManageFrame(
      title: l.manageLabelsTitle,
      children: [
        ManageIntro(l.manageLabelsIntro),
        if (labels.isNotEmpty)
          AppGroup(
            dividerIndent: 52,
            children: [
              for (final label in labels)
                ManageRow(
                  leading: ColorTile(color: Color(label.colorValue ?? c.brand.toARGB32()), icon: LucideIcons.tag),
                  title: label.name,
                  subtitle: subCount(l, counts[label.id] ?? 0),
                  trailing: Icon(LucideIcons.pencil, size: 16, color: c.inkMuted),
                  onTap: () => showLabelSheet(context, label: label),
                ),
            ],
          ),
        const SizedBox(height: AppSpace.s4),
        AppButton.tonal(
          label: l.manageNewLabel,
          icon: LucideIcons.plus,
          expand: true,
          onPressed: () => showLabelSheet(context),
        ),
      ],
    );
  }
}

/// Payment methods (mockup 110): names only; icon guessed from the name; pencil → edit sheet.
class ManagePaymentMethodsScreen extends ConsumerWidget {
  const ManagePaymentMethodsScreen({super.key});

  static IconData iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('apple pay') || n.contains('google pay') || n.contains('samsung')) return LucideIcons.smartphone;
    if (n.contains('play') || n.contains('app store') || n.contains('store')) return LucideIcons.store;
    if (n.contains('paypal') || n.contains('momo') || n.contains('zalo') || n.contains('wallet') || n.contains('ví')) {
      return LucideIcons.wallet;
    }
    if (n.contains('bank') || n.contains('ngân hàng') || n.contains('chuyển khoản')) return LucideIcons.landmark;
    return LucideIcons.creditCard;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final methods = ref.watch(paymentMethodsProvider).value ?? const <PaymentMethod>[];
    final counts = _countBy(ref.watch(subscriptionsProvider).value ?? const [], (s) => [s.paymentMethodId]);
    return _ManageFrame(
      title: l.managePaymentMethodsTitle,
      children: [
        ManageIntro(l.managePaymentMethodsIntro),
        if (methods.isNotEmpty)
          AppGroup(
            dividerIndent: 52,
            children: [
              for (final m in methods)
                ManageRow(
                  leading: SizedBox(width: 24, child: Icon(iconFor(m.name), size: 20, color: c.inkMuted)),
                  title: m.name,
                  subtitle: subCount(l, counts[m.id] ?? 0),
                  trailing: Icon(LucideIcons.pencil, size: 16, color: c.inkMuted),
                  onTap: () => showPaymentMethodSheet(context, method: m),
                ),
            ],
          ),
        const SizedBox(height: AppSpace.s4),
        AppButton.tonal(
          label: l.manageAddPaymentMethod,
          icon: LucideIcons.plus,
          expand: true,
          onPressed: () => showPaymentMethodSheet(context),
        ),
      ],
    );
  }
}

/// Budget (mockup 111): the monthly total for all subscriptions (bar + "% used this month"), then
/// optional per-category budgets — categories with a budget or with subscriptions — and the note.
class ManageBudgetsScreen extends ConsumerWidget {
  const ManageBudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final primary = ref.watch(primaryCurrencyProvider);
    final budgets = ref.watch(budgetsProvider).value ?? const <Budget>[];
    final usage = {for (final u in ref.watch(budgetUsageProvider)) u.budget.categoryId: u};
    final cats = ref.watch(categoriesProvider).value ?? const <Category>[];
    final used = {for (final s in ref.watch(subscriptionsProvider).value ?? const <Subscription>[]) s.categoryId};
    final byCat = {for (final b in budgets) b.categoryId: b};
    final total = byCat[null];
    final totalUse = usage[null];
    String fmt(int minor, String currency) => SettingsFormat.moneyWhole(Money(minor, currency), l.localeName);
    String fmtMajor(double v) => l.money(Money.major(v, primary));

    final ratio = totalUse?.ratio;
    final barColor = ratio == null ? c.brand : (ratio > 1 ? c.danger : (ratio > .85 ? c.warning : c.brand));

    return _ManageFrame(
      title: l.manageBudgetsTitle,
      children: [
        const SizedBox(height: AppSpace.s2),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
          onTap: () => showBudgetSheet(context, budget: total),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.manageBudgetTotal, style: AppType.meta.copyWith(color: c.inkMuted)),
              const SizedBox(height: AppSpace.s1),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      total == null ? '—' : fmt(total.amountMinor, total.currency),
                      style: AppType.amountLg.tabular.copyWith(color: total == null ? c.inkMuted : c.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpace.s3),
                  Container(
                    constraints: const BoxConstraints(minHeight: 40),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text(
                      total?.currency ?? primary,
                      style: AppType.body.copyWith(fontWeight: FontWeight.w600, color: c.ink),
                    ),
                  ),
                ],
              ),
              if (total != null && ratio != null) ...[
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: ratio.clamp(0, 1).toDouble(),
                    minHeight: 4,
                    backgroundColor: c.surface2,
                    color: barColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l.manageBudgetUsed((ratio * 100).round(), fmtMajor(totalUse!.spent)),
                  style: AppType.meta.copyWith(color: ratio > 1 ? c.danger : c.inkMuted),
                ),
              ] else if (total == null) ...[
                const SizedBox(height: AppSpace.s1),
                Text(l.manageBudgetTotalNone, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ],
          ),
        ),
        SectionHeader(label: l.manageBudgetPerCategory),
        AppGroup(
          dividerIndent: 56,
          children: [
            for (final cat in cats)
              if (byCat.containsKey(cat.id) || used.contains(cat.id))
                Builder(
                  builder: (context) {
                    final b = byCat[cat.id];
                    final u = usage[cat.id];
                    final over = u?.isOver ?? false;
                    return ManageRow(
                      leading: CategoryTile(cat),
                      title: l.categoryName(cat),
                      subtitle: u == null ? null : l.manageBudgetThisMonth(fmtMajor(u.spent)),
                      subtitleColor: over ? c.danger : null,
                      onTap: () => showBudgetSheet(context, budget: b, category: cat),
                      trailing: b == null
                          ? Text(l.manageBudgetSet, style: AppType.label.copyWith(color: c.brand))
                          : Container(
                              constraints: const BoxConstraints(minHeight: 36),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: c.surface2,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                fmt(b.amountMinor, b.currency),
                                style: AppType.body.tabular.copyWith(fontWeight: FontWeight.w600, color: c.ink),
                              ),
                            ),
                    );
                  },
                ),
          ],
        ),
        ListNote(l.manageBudgetNote),
      ],
    );
  }
}
