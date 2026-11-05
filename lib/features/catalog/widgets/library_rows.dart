import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

/// S3 library row (design `lrow`): 40px tile · name (`title-sm`) + meta "from ₫74,000/month · 4
/// plans" · round `brand-soft` plus. The whole row is the touch target (≥ 64dp).
class LibraryRow extends StatelessWidget {
  const LibraryRow({super.key, required this.service, required this.meta, required this.onTap});

  final CatalogService service;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = service;
    return Semantics(
      button: true,
      label: context.l10n.catalogAddService(s.name),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
            child: Row(
              children: [
                ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.monogram),
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
