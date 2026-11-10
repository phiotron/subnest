import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'catalog_helpers.dart';
import 'widgets/library_rows.dart';
import 'widgets/plan_sheet.dart';

/// S3 Choose a service (mockup v13 png 22–25, 34–35): search (focused on open, name + aliases,
/// accent-insensitive), General / Vietnam tabs (General opens first, on every device — S-90),
/// category chips, "+ Create a custom service", services with "from" prices (General: US prices ≈
/// Primary currency; Vietnam: VND), a "Reference price" chip on unverified prices, and a plan sheet
/// (plans on sale only) for services with several plans. Picking opens S4 pre-filled with the price
/// the row showed.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _search = TextEditingController();
  String _query = '';
  SubscriptionCategory? _category;

  /// `null` until the first build: General (global prices) on every device; Vietnam is a tab.
  LibraryTab? _tab;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _setQuery(String v) => setState(() => _query = v);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tab = _tab ??= LibraryTab.general;
    final region = CatalogView.regionFor(tab);
    final catalog = ref.watch(catalogProvider).value ?? const <CatalogService>[];
    final ordered = CatalogView.forTab(catalog, tab);
    final query = _query.trim();
    final searching = query.isNotEmpty;

    return Scaffold(
      appBar: AppTopBar(title: l.catalogTitle, close: true),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s3),
              child: _SearchField(controller: _search, hint: l.catalogSearchHint, onChanged: _setQuery),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s2),
              child: AppSegmentedControl<LibraryTab>(
                segments: [
                  AppSegment(value: LibraryTab.general, label: l.catalogTabGeneral),
                  AppSegment(value: LibraryTab.vietnam, label: l.catalogTabVietnam),
                ],
                selected: tab,
                onChanged: (t) => setState(() => _tab = t),
              ),
            ),
            if (!searching) _chips(context),
            Expanded(
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
                children: searching
                    ? _searchResults(context, ordered, query, region)
                    : _browse(context, ordered, region),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chips(BuildContext context) {
    final l = context.l10n;
    Widget chip(String label, SubscriptionCategory? value) => Padding(
      padding: const EdgeInsets.only(right: AppSpace.s2),
      child: AppChip(
        label: label,
        selected: _category == value,
        showCheck: false,
        onTap: () => setState(() => _category = value),
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s2, AppSpace.s2),
      child: Row(
        children: [
          chip(l.commonCategoryAll, null),
          for (final c in SubscriptionCategory.values) chip(l.category(c), c),
        ],
      ),
    );
  }

  List<Widget> _browse(BuildContext context, List<CatalogService> ordered, String region) {
    final l = context.l10n;
    final custom = CustomServiceRow(
      title: l.catalogCustom,
      subtitle: l.catalogCustomSub,
      onTap: () => context.push(AppRoutes.subscriptionNew()),
    );
    if (_category != null) {
      return [custom, ..._rows(context, ordered.where((s) => s.category == _category), region)];
    }
    final popular = ordered.take(CatalogView.popularCount).toList();
    final rest = ordered.skip(CatalogView.popularCount);
    return [
      custom,
      SectionHeader(
        label: region == 'VN' ? l.catalogPopularVietnam : l.catalogPopular,
        padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s1),
      ),
      ..._rows(context, popular, region),
      if (rest.isNotEmpty) ...[
        SectionHeader(
          label: l.catalogMore,
          padding: const EdgeInsets.only(top: AppSpace.s6, bottom: AppSpace.s1),
        ),
        ..._rows(context, rest, region),
      ],
    ];
  }

  List<Widget> _searchResults(BuildContext context, List<CatalogService> ordered, String query, String region) {
    final l = context.l10n;
    final c = context.colors;
    final hits = CatalogView.search(ordered, query);
    void create() => context.push(AppRoutes.subscriptionNew(name: query));
    if (hits.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.s2, AppSpace.s8, AppSpace.s2, AppSpace.s5),
          child: Column(
            children: [
              ExcludeSemantics(child: Icon(AppIcons.search, size: 28, color: c.inkMuted)),
              const SizedBox(height: AppSpace.s3),
              Text(
                l.catalogNoResultTitle(query),
                textAlign: TextAlign.center,
                style: AppType.titleSm.copyWith(color: c.ink),
              ),
              const SizedBox(height: AppSpace.s1),
              Text(
                l.catalogNoResultBody,
                textAlign: TextAlign.center,
                style: AppType.meta.copyWith(color: c.inkMuted),
              ),
            ],
          ),
        ),
        CustomServiceRow(title: l.catalogCreateNamed(query), subtitle: l.catalogCustomService, onTap: create),
      ];
    }
    return [
      Semantics(
        liveRegion: true,
        child: SectionHeader(
          label: l.catalogResults(hits.length),
          padding: const EdgeInsets.only(top: AppSpace.s2, bottom: AppSpace.s1),
        ),
      ),
      ..._rows(context, hits, region),
      Divider(height: 1, thickness: 1, color: context.colors.line),
      CustomServiceRow(title: l.catalogCustomNamed(query), subtitle: l.catalogCustomService, onTap: create),
    ];
  }

  Iterable<Widget> _rows(BuildContext context, Iterable<CatalogService> services, String region) sync* {
    final l = context.l10n;
    final primary = ref.watch(primaryCurrencyProvider);
    final rates = ref.watch(spendingCalculatorProvider).rates;
    String? approx(CatalogPrice p) {
      if (p.currency == primary) return null;
      final v = rates.convert(p.amount, p.currency, primary);
      return v == null ? null : l.amount(v, primary, approx: true);
    }

    var first = true;
    for (final s in services) {
      if (!first) yield Divider(height: 1, thickness: 1, color: context.colors.line);
      first = false;
      yield LibraryRow(
        service: s,
        meta: CatalogView.rowMeta(l, s, region, approx: approx),
        reference: CatalogView.rowIsReference(s, region),
        onTap: () => _pick(s, region),
      );
    }
  }

  Future<void> _pick(CatalogService s, String region) async {
    FocusScope.of(context).unfocus();
    final plans = CatalogView.plans(s, region);
    CatalogPlan? plan = plans.firstOrNull;
    if (plans.length > 1) {
      plan = await showPlanSheet(context, service: s, region: region);
      if (plan == null) return;
    }
    if (!mounted) return;
    ref.read(libraryPickRegionProvider.notifier).set(region);
    await context.push(AppRoutes.subscriptionNew(serviceId: s.id, planId: plan?.id));
  }
}

/// Search box (design `.search.focus`): `surface` field, search icon, clear button when filled.
/// Focused on open so the keyboard is up (S3 spec).
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.hint, required this.onChanged});

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) => TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: AppType.body.copyWith(color: c.ink),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(AppIcons.search, size: 20, color: c.inkMuted),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  tooltip: l.catalogClearSearch,
                  icon: Icon(AppIcons.clear, size: 20, color: c.inkMuted),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
