import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import 'settings_format.dart';

/// Theme sheet (mockup 093): System / Light / Dark segments + a note. Applies at once.
Future<void> showThemeSheet(BuildContext context) => showAppSheet<void>(context, builder: (_) => const ThemeSheet());

/// Language sheet (mockup 092): English / Tiếng Việt (the only two, S-90). Applies at once and
/// closes.
Future<void> showLanguageSheet(BuildContext context) =>
    showAppSheet<void>(context, builder: (_) => const LanguageSheet());

class ThemeSheet extends ConsumerWidget {
  const ThemeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final repo = ref.read(settingsRepositoryProvider);
    return AppSheet(
      title: l.settingsTheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSegmentedControl<AppThemeMode>(
            selected: settings?.themeMode ?? AppThemeMode.system,
            onChanged: settings == null ? null : repo.setThemeMode,
            segments: [
              AppSegment(value: AppThemeMode.system, label: l.settingsSystemShort),
              AppSegment(value: AppThemeMode.light, label: l.settingsThemeLight),
              AppSegment(value: AppThemeMode.dark, label: l.settingsThemeDark),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpace.s3, bottom: AppSpace.s4),
            child: Text(l.settingsThemeNote, style: AppType.meta.copyWith(color: c.inkMuted)),
          ),
        ],
      ),
    );
  }
}

class LanguageSheet extends ConsumerWidget {
  const LanguageSheet({super.key});

  /// Each language in its own words, with its English name under it (`.plan` rows in a group).
  static const _options = [('en', 'English'), ('vi', 'Vietnamese')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final repo = ref.read(settingsRepositoryProvider);
    final current = settings?.localeCode ?? 'en';
    return AppSheet(
      title: l.settingsLanguage,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final (code, english) in _options)
                    _LanguageRow(
                      title: SettingsFormat.languageName(code),
                      subtitle: english,
                      selected: current == code,
                      onTap: settings == null
                          ? null
                          : () async {
                              await repo.setLocale(code);
                              if (context.mounted) Navigator.pop(context);
                            },
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: AppSpace.s3, bottom: AppSpace.s4),
              child: Text(l.settingsLanguageNote, style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.group .plan`: radio, title-sm, meta under it; the chosen row on `brand-soft`.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.title, required this.subtitle, required this.selected, this.onTap});

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      child: Material(
        color: selected ? c.brandSoft : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  RadioMark(selected: selected),
                  const SizedBox(width: AppSpace.s3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
                        Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted)),
                      ],
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
