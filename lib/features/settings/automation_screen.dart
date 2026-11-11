import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import 'settings_actions.dart';
import 'widgets/settings_bits.dart';

/// Settings › Automation (Pro, mockup 112): what Subnest can find on the phone — Screenshot scan
/// (Open → S13), Bank & wallet notifications and Gmail (Soon) — what happens when something is
/// found, and "Get early access" (mockup 113, never a price).
///
/// "Add new ones automatically" and "Confirm periods automatically" describe what Screenshot scan
/// does today (every change tagged Auto, with Undo); there is no setting to turn them off yet, so
/// the switches are shown on and read-only.
class AutomationScreen extends ConsumerWidget {
  const AutomationScreen({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const AutomationScreen());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppTopBar(title: l.settingsSectionAutomation),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s6),
          children: [
            // `.pro-card`
            Container(
              padding: const EdgeInsets.all(AppSpace.s5),
              decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(child: ProBadge(onBrand: true)),
                  const SizedBox(height: 10),
                  Semantics(
                    header: true,
                    child: Text(l.settingsAutomationHero, style: AppType.title.copyWith(color: c.onBrand)),
                  ),
                  const SizedBox(height: 6),
                  Text(l.settingsAutomationHeroBody, style: AppType.meta.copyWith(color: c.onBrand)),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.s4),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: LucideIcons.scanLine,
                  label: l.settingsScan,
                  subtitle: l.settingsAutomationScanHint,
                  trailing: AppButton.tonal(
                    label: l.settingsOpen,
                    small: true,
                    onPressed: () => context.push(AppRoutes.scan),
                  ),
                ),
                SettingRow(
                  icon: AppIcons.reminderRing,
                  label: l.settingsBankNotifications,
                  subtitle: 'Android',
                  trailing: SoonChip(l.settingsSoon),
                ),
                SettingRow(
                  icon: AppIcons.mail,
                  label: 'Gmail',
                  subtitle: l.settingsGmailHint,
                  trailing: SoonChip(l.settingsSoon),
                ),
              ],
            ),
            SectionHeader(label: l.settingsAutomationFound),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: LucideIcons.plus,
                  label: l.settingsAutoAdd,
                  trailing: AppToggle(value: true, semanticLabel: l.settingsAutoAdd, onChanged: null),
                ),
                SettingRow(
                  icon: LucideIcons.check,
                  label: l.settingsAutoConfirm,
                  trailing: AppToggle(value: true, semanticLabel: l.settingsAutoConfirm, onChanged: null),
                ),
              ],
            ),
            ListNote(l.settingsAutomationNote),
            const SizedBox(height: AppSpace.s4),
            AppButton.outline(
              label: l.settingsEarlyAccessCta,
              icon: LucideIcons.sparkles,
              expand: true,
              onPressed: () => showEarlyAccessSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Subnest Pro" early-access sheet (mockup 113): what Pro does, Now / Soon, the early-access
/// note — no price — and "Join early access" (an email to support) / "Not now".
Future<void> showEarlyAccessSheet(BuildContext context) =>
    showAppSheet<void>(context, builder: (_) => const EarlyAccessSheet());

class EarlyAccessSheet extends ConsumerWidget {
  const EarlyAccessSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final rows = <(IconData, String, Widget?)>[
      (
        LucideIcons.scanLine,
        l.settingsScan,
        StatusBadge(label: l.settingsProNow, kind: BadgeKind.success, icon: LucideIcons.check),
      ),
      (AppIcons.reminderRing, l.settingsBankNotifications, SoonChip(l.settingsSoon)),
      (AppIcons.mail, 'Gmail', SoonChip(l.settingsSoon)),
      (LucideIcons.rotateCcw, l.settingsProUndo, null),
    ];
    return AppSheet(
      actions: [
        AppButton.primary(
          label: l.settingsJoinEarlyAccess,
          expand: true,
          onPressed: () async {
            await SettingsActions.joinEarlyAccess(context, ref);
            if (context.mounted) Navigator.pop(context);
          },
        ),
        AppButton.text(label: l.settingsNotNow, expand: true, onPressed: () => Navigator.pop(context)),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // `.pro-hero`
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s3, AppSpace.s1, AppSpace.s3, AppSpace.s4),
              child: Column(
                children: [
                  const ExcludeSemantics(child: ProBadge()),
                  const SizedBox(height: AppSpace.s2),
                  Semantics(
                    header: true,
                    child: Text('Subnest Pro', style: AppType.title.copyWith(color: c.ink)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.settingsProBody,
                    textAlign: TextAlign.center,
                    style: AppType.meta.copyWith(color: c.inkMuted),
                  ),
                ],
              ),
            ),
            AppGroup(
              dividerIndent: 52,
              children: [
                for (final (icon, label, trailing) in rows)
                  SettingRow(icon: icon, label: label, trailing: trailing ?? const SizedBox.shrink()),
              ],
            ),
            const SizedBox(height: AppSpace.s4),
            AppBanner(
              kind: BannerKind.info,
              icon: LucideIcons.sparkles,
              title: l.settingsEarlyAccessTitle,
              body: l.settingsEarlyAccessBody,
            ),
            const SizedBox(height: AppSpace.s2),
          ],
        ),
      ),
    );
  }
}
