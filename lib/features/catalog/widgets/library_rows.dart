import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// S3 library row (design `.lrow`, png 030–032): 40px logo · name (`title-sm`) · "from $7.99" +
/// [CycleChip] (+ [ReferencePriceChip] when unverified) · "≈ ₫202,946" when the price is in another
/// currency than the Primary one · round `brand-soft` plus. Whole row = one target. Without any
/// price, [fallback] (the category) stands in for the price line.
class LibraryRow extends StatelessWidget {
  const LibraryRow({
    super.key,
    required this.service,
    required this.onTap,
    this.price,
    this.cycle,
    this.approx,
    this.fallback = '',
    this.reference = false,
  });

  final CatalogService service;
  final VoidCallback onTap;

  /// "from $7.99" / "$7.99"; `null` = no price.
  final String? price;
  final BillingCycle? cycle;

  /// "≈ ₫202,946" in the Primary currency, `null` when the same currency.
  final String? approx;
  final String fallback;

  /// The shown price is a Reference price (unverified).
  final bool reference;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final s = service;
    final p = price;
    return Semantics(
      button: true,
      label: [
        l.catalogAddService(s.name),
        if (p != null) p else fallback,
        if (p != null && cycle != null) l.cycle(cycle!),
        if (reference) l.commonReferencePrice,
        if (approx != null) l.spoken(approx!), // "≈" read as a word (TalkBack skips the symbol)
      ].join(', '),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s2),
            child: Row(
              children: [
                ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram, serviceId: s.id),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.titleSm.copyWith(color: c.ink),
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(p ?? fallback, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                          if (p != null && cycle != null) CycleChip(cycle: cycle!),
                          if (reference) const ReferencePriceChip(),
                        ],
                      ),
                      if (approx != null) ...[
                        const SizedBox(height: 2),
                        Text(approx!, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: c.brandSoft, shape: BoxShape.circle),
                  child: Icon(AppIcons.add, size: 18, color: c.onBrandSoft),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "+ Create a custom service" row (design `.lrow.custom`): ghost tile · `brand` title + meta ·
/// chevron. Also "Not it? Create “abc”" under search results and "Create “abc”" when nothing matches.
class CustomServiceRow extends StatelessWidget {
  const CustomServiceRow({super.key, required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s2),
            child: Row(
              children: [
                const GhostTile(),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: AppType.titleSm.copyWith(color: c.brand)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s2),
                ExcludeSemantics(child: Icon(AppIcons.next, size: 18, color: c.inkMuted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Reference price" tag (design `.ref`): 18px, radius 6, `warning-soft` / `warning-ink`, 11/700.
/// Marks a Catalog price that is not verified from the provider's page (glossary: Reference price).
class ReferencePriceChip extends StatelessWidget {
  const ReferencePriceChip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(color: c.warningSoft, borderRadius: BorderRadius.circular(6)),
      child: Text(
        context.l10n.commonReferencePrice,
        style: AppType.meta.copyWith(fontSize: 11, height: 16 / 11, fontWeight: FontWeight.w700, color: c.warningInk),
      ),
    );
  }
}
