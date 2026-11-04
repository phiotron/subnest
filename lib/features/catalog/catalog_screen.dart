import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/service_tile.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// S3 Choose a service — PLACEHOLDER UI. Owned by the Add & onboarding session (H).
class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  String _query = '';
  SubscriptionCategory? _category;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final region = ref.watch(catalogRegionProvider);
    final catalog = ref.watch(catalogProvider).value ?? const <CatalogService>[];
    final results = catalog
        .where((s) => (_category == null || s.category == _category) && s.matches(_query))
        .toList()
      ..sort((a, b) => (region == 'VN' && a.isVietnamese != b.isVietnamese) ? (a.isVietnamese ? -1 : 1) : 0);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: l.catalogSearchHint, border: InputBorder.none),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(l.commonCategoryAll),
                    selected: _category == null,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                ),
                for (final c in SubscriptionCategory.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(l.category(c)),
                      selected: _category == c,
                      onSelected: (_) => setState(() => _category = c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.add_circle_outline),
                  title: Text(_query.trim().isEmpty ? l.catalogCustom : l.catalogCustomNamed(_query.trim())),
                  onTap: () => context.push(
                    AppRoutes.subscriptionNew(name: _query.trim().isEmpty ? null : _query.trim()),
                  ),
                ),
                for (final s in results)
                  ListTile(
                    leading: ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram),
                    title: Text(s.name),
                    subtitle: Text(_fromLabel(context, s, region)),
                    onTap: () => _pick(context, s, region),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fromLabel(BuildContext context, CatalogService s, String region) {
    final l = context.l10n;
    final from = s.fromPerMonth(region);
    if (from == null) return l.category(s.category);
    return '${l.category(s.category)} · ${l.catalogFromPerMonth(l.amount(from.$2, from.$1))}';
  }

  Future<void> _pick(BuildContext context, CatalogService s, String region) async {
    var plan = s.plans.first;
    if (s.plans.length > 1) {
      final chosen = await showModalBottomSheet<CatalogPlan>(
        context: context,
        showDragHandle: true,
        builder: (ctx) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(title: Text(ctx.l10n.catalogChoosePlan(s.name))),
              for (final p in s.plans)
                ListTile(
                  title: Text(p.name),
                  subtitle: Text(ctx.l10n.cycle(p.cycle)),
                  trailing: p.priceFor(region) == null
                      ? null
                      : Text(ctx.l10n.amount(p.priceFor(region)!.amount, p.priceFor(region)!.currency)),
                  onTap: () => Navigator.pop(ctx, p),
                ),
            ],
          ),
        ),
      );
      if (chosen == null) return;
      plan = chosen;
    }
    if (context.mounted) context.push(AppRoutes.subscriptionNew(serviceId: s.id, planId: plan.id));
  }
}
