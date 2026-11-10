import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../lock/app_lock.dart';
import '../lock/pin_screens.dart';
import '../lock/privacy_screen.dart';
import 'settings_platform.dart';

/// Settings › Security (APP.md decision 2026-11-10 item 5), right after Data: PIN lock · Privacy
/// screen. Layout as A002 (switch rows with a note), drawn with the Subnest components.
class SecuritySection extends ConsumerWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final pinOn = ref.watch(pinEnabledProvider).value ?? false;
    final privacyOn = ref.watch(privacyScreenProvider).value ?? false;
    final ios = ref.watch(settingsPlatformProvider).isIOS;

    Future<void> togglePin() => pinOn ? PinActions.turnOff(context, ref) : PinActions.turnOn(context, ref);
    Future<void> togglePrivacy() => setPrivacyScreen(ref, !privacyOn);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(label: l.securitySection),
        AppGroup(
          dividerIndent: 52,
          children: [
            SettingRow(
              icon: AppIcons.privacy,
              label: l.securityPinLock,
              subtitle: l.securityPinWarning,
              onTap: togglePin,
              trailing: AppToggle(value: pinOn, semanticLabel: l.securityPinLock, onChanged: (_) => togglePin()),
            ),
            SettingRow(
              icon: LucideIcons.eyeOff,
              label: l.securityPrivacyScreen,
              subtitle: ios ? l.securityPrivacyScreenNoteIos : l.securityPrivacyScreenNote,
              onTap: togglePrivacy,
              trailing: AppToggle(
                value: privacyOn,
                semanticLabel: l.securityPrivacyScreen,
                onChanged: (_) => togglePrivacy(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
