import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/catalog/catalog_providers.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'catalog_helpers.dart';
import 'widgets/library_rows.dart';
import 'widgets/plan_sheet.dart';

/// S3 Choose a service (mockup v14 png 030–034): search (focused on open, name + aliases,
/// accent-insensitive), General / Vietnam tabs (General opens first, on every device — S-90),
/// category chips, "+ Create a custom service", services with real logos and "from" prices + cycle
/// chip (General: US prices ≈ Primary currency; Vietnam: VND), a "Reference price" tag on
/// unverified prices, a plan sheet (plans on sale only) for services with several plans, and
/// "Library updated N days ago" at the end. Searching hides tabs and chips and looks in both
/// sections. Picking opens S4 pre-filled with the price the row showed.
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final _search = TextEditingController();
  String _query = '';
  SubscriptionCategory? _category;

  /// General (global prices) on every device; Vietnam is a tab.
  LibraryTab _tab = LibraryTab.general;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _setQuery(String v) => setState(() => _query = v);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final tab = _tab;
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
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, 0),
              child: _SearchField(controller: _search, hint: l.catalogSearchHint, onChanged: _setQuery),
            ),
            if (!searching) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.s4, 10, AppSpace.s4, 2),
                child: AppSegmentedControl<LibraryTab>(
                  segments: [
                    AppSegment(value: LibraryTab.general, label: l.catalogTabGeneral),
                    AppSegment(value: LibraryTab.vietnam, label: l.catalogTabVietnam),
                  ],
                  selected: tab,
                  onChanged: (t) => setState(() => _tab = t),
                ),
              ),
              _chips(context),
            ],
            Expanded(
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s1, AppSpace.s4, AppSpace.s6),
                children: searching ? _searchResults(context, catalog, query) : _browse(context, ordered, region),
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
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s2, AppSpace.s1),
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
    final footer = _UpdatedFooter(updatedOn: ref.watch(catalogUpdatedOnProvider), today: ref.watch(todayProvider));
    if (_category != null) {
      return [custom, ..._rows(context, ordered.where((s) => s.category == _category), (_) => region), footer];
    }
    final popular = ordered.take(CatalogView.popularCount).toList();
    final rest = ordered.skip(CatalogView.popularCount);
    return [
      custom,
      SectionHeader(
        label: region == 'VN' ? l.catalogPopularVietnam : l.catalogPopular,
        padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s1),
      ),
      ..._rows(context, popular, (_) => region),
      if (rest.isNotEmpty) ...[
        SectionHeader(
          label: l.catalogMore,
          padding: const EdgeInsets.only(top: AppSpace.s6, bottom: AppSpace.s1),
        ),
        ..._rows(context, rest, (_) => region),
      ],
      footer,
    ];
  }

  /// Results from both sections (png 032): the open tab's services first, each with the price of
  /// the section it belongs to; "Not it? Create “abc”" below, or the empty state (png 033).
  List<Widget> _searchResults(BuildContext context, List<CatalogService> catalog, String query) {
    final l = context.l10n;
    final c = context.colors;
    final other = _tab == LibraryTab.general ? LibraryTab.vietnam : LibraryTab.general;
    final regionOf = <String, String>{};
    final hits = <CatalogService>[];
    for (final t in [_tab, other]) {
      for (final s in CatalogView.search(CatalogView.forTab(catalog, t), query)) {
        if (regionOf.containsKey(s.id)) continue;
        regionOf[s.id] = CatalogView.regionFor(t);
        hits.add(s);
      }
    }
    void create() => context.push(AppRoutes.subscriptionNew(name: query));
    if (hits.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s6, AppSpace.s4, AppSpace.s4),
          child: Column(
            children: [
              ExcludeSemantics(child: Icon(LucideIcons.searchX, size: 28, color: c.inkMuted)),
              const SizedBox(height: 6),
              Text(
                l.catalogNoResultTitle(query),
                textAlign: TextAlign.center,
                style: AppType.titleSm.copyWith(color: c.ink),
              ),
              const SizedBox(height: 6),
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
          padding: const EdgeInsets.only(top: AppSpace.s4, bottom: AppSpace.s1),
        ),
      ),
      ..._rows(context, hits, (s) => regionOf[s.id]!),
      Divider(height: 1, thickness: 1, color: context.colors.line),
      CustomServiceRow(title: l.catalogCustomNamed(query), subtitle: l.catalogCustomService, onTap: create),
    ];
  }

  Iterable<Widget> _rows(
    BuildContext context,
    Iterable<CatalogService> services,
    String Function(CatalogService s) regionOf,
  ) sync* {
    final l = context.l10n;
    final primary = ref.watch(primaryCurrencyProvider);
    final rates = ref.watch(spendingCalculatorProvider).rates;

    var first = true;
    for (final s in services) {
      if (!first) yield Divider(height: 1, thickness: 1, color: context.colors.line);
      first = false;
      final region = regionOf(s);
      final offer = CatalogView.rowOffer(s, region);
      String? price;
      String? approx;
      if (offer != null) {
        final p = offer.price;
        final amount = l.amount(p.amount, p.currency);
        price = offer.many ? l.catalogFrom(amount) : amount;
        if (p.currency != primary) {
          final v = rates.convert(p.amount, p.currency, primary);
          if (v != null) approx = l.amount(v, primary, approx: true);
        }
      }
      yield LibraryRow(
        service: s,
        price: price,
        cycle: offer?.plan.cycle,
        approx: approx,
        fallback: l.category(s.category),
        reference: offer?.price.isReference ?? false,
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

/// "↻ Library updated 3 days ago" (design `.lib-foot`): the day the Catalog data last changed
/// (not when it was downloaded). Hidden while the Catalog is loading.
class _UpdatedFooter extends StatelessWidget {
  const _UpdatedFooter({required this.updatedOn, required this.today});

  final LocalDate? updatedOn;
  final LocalDate today;

  @override
  Widget build(BuildContext context) {
    final on = updatedOn;
    if (on == null) return const SizedBox.shrink();
    final c = context.colors;
    final days = on.daysUntil(today).clamp(0, 9999);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, AppSpace.s4, 0, AppSpace.s2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExcludeSemantics(child: Icon(AppIcons.refresh, size: 14, color: c.inkMuted)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              context.l10n.catalogUpdated(days),
              textAlign: TextAlign.center,
              style: AppType.meta.copyWith(color: c.inkMuted),
            ),
          ),
        ],
      ),
    );
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
