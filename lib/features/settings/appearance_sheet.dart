import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import 'settings_format.dart';

/// Opens the Appearance sheet (png 50). Choices apply at once; "Done" closes.
Future<void> showAppearanceSheet(BuildContext context) =>
    showAppSheet<void>(context, builder: (_) => const AppearanceSheet());

/// Theme (System / Light / Dark) + Language (English / Tiếng Việt — the only two, S-90).
class AppearanceSheet extends ConsumerWidget {
  const AppearanceSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final repo = ref.read(settingsRepositoryProvider);
    return AppSheet(
      title: l.settingsAppearanceTitle,
      actions: [AppButton.tonal(label: l.commonDone, expand: true, onPressed: () => Navigator.pop(context))],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SectionHeader(
              label: l.settingsTheme,
              padding: const EdgeInsets.fromLTRB(AppSpace.s1, 0, AppSpace.s1, AppSpace.s2),
            ),
            AppSegmentedControl<AppThemeMode>(
              selected: settings?.themeMode ?? AppThemeMode.system,
              onChanged: settings == null ? null : repo.setThemeMode,
              segments: [
                AppSegment(value: AppThemeMode.system, label: l.settingsSystemShort),
                AppSegment(value: AppThemeMode.light, label: l.settingsThemeLight),
                AppSegment(value: AppThemeMode.dark, label: l.settingsThemeDark),
              ],
            ),
            SectionHeader(label: l.settingsLanguage),
            RadioRowGroup<String>(
              style: RadioRowStyle.flat,
              value: settings?.localeCode ?? 'en',
              onChanged: settings == null ? null : (code) => repo.setLocale(code),
              options: [
                RadioOption(value: 'en', title: SettingsFormat.languageName('en')),
                RadioOption(value: 'vi', title: SettingsFormat.languageName('vi')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
