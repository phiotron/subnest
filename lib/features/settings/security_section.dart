import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../lock/app_lock.dart';
import '../lock/pin_screens.dart';
import '../lock/privacy_screen.dart';
import 'settings_platform.dart';

/// Settings › Security (mockup 088, 090), right after Data: PIN lock (+ Change PIN while on) ·
/// Hide content in app switcher.
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
    Future<void> changePin() async {
      if (await PinActions.change(context, ref) && context.mounted) showAppToast(context, l.securityPinChanged);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(label: l.securitySection),
        AppGroup(
          dividerIndent: 52,
          children: [
            SettingRow(
              icon: LucideIcons.lockKeyhole,
              label: l.securityPinLock,
              subtitle: pinOn ? l.securityPinOnNote : l.securityPinOffNote,
              onTap: togglePin,
              trailing: AppToggle(value: pinOn, semanticLabel: l.securityPinLock, onChanged: (_) => togglePin()),
            ),
            if (pinOn) SettingRow(icon: LucideIcons.keyRound, label: l.securityChangePin, onTap: changePin),
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
