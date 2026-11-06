import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// S3 library row (design `lrow`, png 22/34/35): 40px tile (Logo.dev logo via `logoDomain`,
/// monogram fallback) · name (`title-sm`) + meta "from $7.99/month · ≈ ₫202,946 · 4 plans" (wraps,
/// never truncates) · optional [ReferencePriceChip] · round `brand-soft` plus. Whole row = target.
class LibraryRow extends StatelessWidget {
  const LibraryRow({super.key, required this.service, required this.meta, required this.onTap, this.reference = false});

  final CatalogService service;
  final String meta;
  final VoidCallback onTap;

  /// The shown price is a Reference price (unverified).
  final bool reference;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = service;
    return Semantics(
      button: true,
      label: [
        context.l10n.catalogAddService(s.name),
        meta,
        if (reference) context.l10n.commonReferencePrice,
      ].join(', '),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
            child: Row(
              children: [
                ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram, logoDomain: s.logoDomain),
                const SizedBox(width: AppSpace.s4),
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
                      Text(meta, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                      if (reference) ...[const SizedBox(height: AppSpace.s1), const ReferencePriceChip()],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                Container(
                  width: 36,
                  height: 36,
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

/// "+ Create a custom service" row (design `lrow custom`): ghost tile · `brand` title + meta ·
/// chevron. Also the "Not seeing it? Create “abc”" suggestion.
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
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
            child: Row(
              children: [
                const GhostTile(),
                const SizedBox(width: AppSpace.s4),
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

/// "ⓘ Reference price" chip (design `.ref-chip`): 20px pill, `warning-soft` / `warning-ink`, 11/600.
/// Marks a Catalog price that is not verified from the provider's page (glossary: Reference price).
class ReferencePriceChip extends StatelessWidget {
  const ReferencePriceChip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsets.fromLTRB(5, 2, 7, 2),
      decoration: ShapeDecoration(color: c.warningSoft, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.info, size: 12, color: c.warningInk),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              context.l10n.commonReferencePrice,
              style: AppType.meta.copyWith(
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w600,
                color: c.warningInk,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
