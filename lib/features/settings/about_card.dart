import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/catalog/catalog_providers.dart';
import '../../data/providers.dart';
import 'app_info.dart';
import 'settings_actions.dart';
import 'settings_platform.dart';
import 'widgets/app_mark.dart';
import 'widgets/settings_bits.dart';

/// Settings › About as one inline card (mockup 089, `.about-in`): app mark + name + version,
/// Service library (when the Catalog last changed · how many services) and Price lists, link
/// chips (Privacy policy · Terms · Licences · Rate the app · Send feedback) and the trademark line.
class AboutCard extends ConsumerWidget {
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final platform = ref.watch(settingsPlatformProvider);
    final count = ref.watch(catalogDataProvider).value?.services.length;
    final updatedOn = ref.watch(catalogUpdatedOnProvider);
    final today = ref.watch(todayProvider);

    String? library;
    if (count != null) {
      if (updatedOn == null) {
        library = l.settingsLibraryCount(count);
      } else {
        final days = updatedOn.daysUntil(today);
        library = l.settingsLibraryValue(days <= 0 ? l.settingsAgoToday : l.settingsAgoDays(days), count);
      }
    }

    final links = <(String, IconData, VoidCallback, bool)>[
      (l.settingsPrivacyPolicy, LucideIcons.shieldCheck, () => SettingsActions.openPrivacyPolicy(context, ref), false),
      (l.settingsTerms, LucideIcons.fileText, () => SettingsActions.openTerms(context, ref), false),
      (l.settingsLicenses, LucideIcons.scrollText, () => SettingsActions.openLicenses(context), false),
      if (SettingsActions.canRate(platform))
        (l.settingsRateApp, LucideIcons.star, () => SettingsActions.rateApp(context, ref), true),
      (l.settingsFeedback, LucideIcons.mail, () => SettingsActions.sendFeedback(context, ref), true),
    ];

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          MergeSemantics(
            child: Row(
              children: [
                const AppMark(size: 44, radius: 10),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.commonAppName, style: AppType.titleSm.copyWith(color: c.ink)),
                      Text(l.settingsVersionValue(appVersionLabel), style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          KeyValueGrid(
            rowGap: 4,
            columnGap: 12,
            rows: [
              if (library != null) (l.settingsLibrary, KvText(library)),
              (l.settingsPriceLists, KvText(l.settingsPriceListsValue)),
            ],
          ),
          const SizedBox(height: AppSpace.s2),
          Wrap(
            spacing: 6,
            children: [
              for (final (label, icon, onTap, external) in links)
                _LinkChip(label: label, icon: icon, onTap: onTap, external: external),
            ],
          ),
          const SizedBox(height: AppSpace.s2),
          Text(l.settingsLogosOwnership, style: AppType.meta.copyWith(color: c.inkMuted)),
        ],
      ),
    );
  }
}

/// `.ab-l`: 34 px `surface-2` pill, 16 px icon + 13/600 label, inside a 48 px tap area.
class _LinkChip extends StatelessWidget {
  const _LinkChip({required this.label, required this.icon, required this.onTap, required this.external});

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool external;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      link: external,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          child: Center(
            widthFactor: 1,
            child: Container(
              constraints: const BoxConstraints(minHeight: 34),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(17)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: c.ink),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: AppType.meta.copyWith(color: c.ink, fontWeight: FontWeight.w600),
                    ),
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
