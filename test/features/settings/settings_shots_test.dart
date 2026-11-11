import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/organize_repository.dart';
import 'package:subnest/features/lock/pin_service.dart';
import 'package:subnest/features/settings/manage/manage_widgets.dart';
import 'package:subnest/features/settings/widgets/settings_bits.dart';

import '../../data/backup/backup_test_utils.dart';

import 'settings_harness.dart';

/// Every Settings + PIN screen/state of mockup v14 (002–004, 087–113) × light/dark × EN/VI ×
/// 360/390 × text 100/130/200%, plus 320 × 200%: must lay out without overflow (a RenderFlex
/// overflow fails the test).
///
/// Images for the notes: `flutter test test/features/settings/settings_shots_test.dart
/// --dart-define=SHOTS=true` writes them to notes/img/2026-11-05-ui-settings/.
class Scenario {
  const Scenario(this.name, this.location, {this.notificationsOn = true, this.offline = false, this.act, this.seed});

  final String name;
  final String location;
  final bool notificationsOn;
  final bool offline;

  /// Opens a sheet/dialog or scrolls after the screen is up.
  final Future<void> Function(WidgetTester tester, SettingsFixture f)? act;

  /// Data written before the screen is pumped (PIN on, labels, budgets…).
  final Future<void> Function(SettingsFixture f)? seed;
}

Future<void> _pinOn(SettingsFixture f) => PinService(f.secrets, settings: () => f.settings).setPin('2580');

Future<void> _organize(SettingsFixture f) async {
  final o = OrganizeRepository(f.db, clock: () => kNow);
  for (final (name, color) in [('Family', 0xFFE87BA4), ('Work', 0xFF2856D8), ('Health', 0xFF1F9D55)]) {
    await o.addLabel(name, colorValue: color);
  }
  for (final name in ['Visa ••4821', 'PayPal', 'Apple Pay', 'Google Play', 'MoMo']) {
    await o.addPaymentMethod(name);
  }
  await o.setBudget(amountMinor: 15000000, currency: 'VND');
  await o.setBudget(categoryId: 'video', amountMinor: 200000, currency: 'VND');
}

Future<void> _autoBackupOn(SettingsFixture f, {String result = 'ok'}) async {
  f.secrets.values.addAll({
    'auto_backup_enabled': '1',
    'auto_backup_uri': 'content://tree/a',
    'auto_backup_name': 'Google Drive › Backups',
    'auto_backup_password': 'pass-123',
    'auto_backup_time': '21:00',
    'auto_backup_last_at': DateTime(2026, 11, 4, 21, 2).toUtc().toIso8601String(),
    'auto_backup_last_result': result,
  });
}

Finder _danger() => find.byWidgetPredicate((w) => w is AppButton && w.kind == AppButtonKind.danger);

Future<void> _pinKeys(WidgetTester t, String pin) async {
  for (final d in pin.split('')) {
    await t.tap(find.byKey(ValueKey('pin-key-$d')));
    await t.pump();
  }
  await settle(t);
}

final scenarios = <Scenario>[
  // ---- PIN lock 002–004 ----
  const Scenario('002-pin-lock', '/lock'),
  Scenario('003-pin-wrong', '/lock', seed: _pinOn, act: (t, f) => _pinKeys(t, '1111')),
  Scenario(
    '004-pin-forgot',
    '/lock',
    act: (t, f) async {
      await t.ensureVisible(find.byType(TextButton).last);
      await _tap(t, find.byType(TextButton).last);
    },
  ),
  // ---- Settings 087–093 ----
  const Scenario('087-settings', '/settings'),
  Scenario('088-settings-data', '/settings', act: (t, f) => t.scrollUntilVisible(find.byIcon(AppIcons.delete), 300)),
  Scenario(
    '088b-auto-backup-on',
    '/settings',
    seed: (f) => _autoBackupOn(f),
    act: (t, f) => t.scrollUntilVisible(find.byIcon(AppIcons.delete), 300),
  ),
  Scenario(
    '088c-auto-backup-folder-error',
    '/settings',
    seed: (f) => _autoBackupOn(f, result: 'permissionDenied'),
    act: (t, f) => t.scrollUntilVisible(find.byIcon(AppIcons.delete), 300),
  ),
  Scenario('089-settings-about', '/settings', act: (t, f) => _scrollToEnd(t)),
  Scenario(
    '090-pin-on',
    '/settings',
    seed: _pinOn,
    act: (t, f) => t.scrollUntilVisible(find.byIcon(LucideIcons.keyRound), 300),
  ),
  Scenario('092-language', '/settings', act: (t, f) => tapVisible(t, find.byIcon(AppIcons.language))),
  Scenario('093-theme', '/settings', act: (t, f) => tapVisible(t, find.byIcon(AppIcons.theme))),
  // ---- 094 Exchange rates ----
  const Scenario('094-rates', '/settings/rates'),
  const Scenario('094b-rates-offline', '/settings/rates', offline: true),
  Scenario(
    '094c-rate-override',
    '/settings/rates',
    act: (t, f) async {
      await _tap(t, find.byIcon(AppIcons.next).first);
    },
  ),
  // ---- 095–096 Reminders ----
  const Scenario('095-reminders', '/settings/reminders'),
  const Scenario('096-reminders-off', '/settings/reminders', notificationsOn: false),
  // ---- 097–101 Backup ----
  const Scenario('097-auto-backup-setup', '/settings/auto-backup-setup'),
  Scenario('098-backup-now', '/settings', act: (t, f) => tapVisible(t, find.byIcon(AppIcons.backupNow))),
  Scenario(
    '099-restore',
    '/settings',
    act: (t, f) async {
      f.platform.nextPick = (name: 'subnest-20261109-2100.subnest', text: f.backupJson);
      await tapVisible(t, find.byIcon(LucideIcons.folderOpen));
    },
  ),
  Scenario(
    '100-restore-password',
    '/settings',
    act: (t, f) async {
      final envelope = (await t.runAsync(() => encryptFast(f.backupJson, 'pass-123456')))!;
      f.platform.nextPick = (name: 'subnest-auto-20261109-2100.subnest', text: envelope);
      await tapVisible(t, find.byIcon(LucideIcons.folderOpen));
    },
  ),
  Scenario(
    '101-restore-replace',
    '/settings',
    act: (t, f) async {
      f.platform.nextPick = (name: 'subnest-20261109-2100.subnest', text: f.backupJson);
      await tapVisible(t, find.byIcon(LucideIcons.folderOpen));
      await _tap(t, find.descendant(of: find.byType(BottomActionBar), matching: find.byType(AppButton)));
    },
  ),
  // ---- 102–103 Erase all data ----
  Scenario('102-erase-1', '/settings', act: (t, f) => tapVisible(t, find.byIcon(AppIcons.delete))),
  Scenario(
    '103-erase-2',
    '/settings',
    act: (t, f) async {
      await tapVisible(t, find.byIcon(AppIcons.delete));
      await _tap(t, _danger());
    },
  ),
  // ---- 104–105 PIN set-up ----
  const Scenario('104-pin-choose', '/settings/pin-setup'),
  Scenario('105-pin-repeat', '/settings/pin-setup', act: (t, f) => _pinKeys(t, '1234')),
  Scenario(
    '105b-pin-mismatch',
    '/settings/pin-setup',
    act: (t, f) async {
      await _pinKeys(t, '1234');
      await _pinKeys(t, '1235');
    },
  ),
  // ---- 106–111 Organize ----
  const Scenario('106-categories', '/settings/categories'),
  Scenario('107-category-edit', '/settings/categories', act: (t, f) => _tap(t, find.byType(ManageRow).first)),
  Scenario(
    '108-category-delete',
    '/settings/categories',
    act: (t, f) async {
      await _tap(t, find.byType(ManageRow).first);
      await t.ensureVisible(find.byType(DangerTextButton));
      await _tap(t, find.byType(DangerTextButton));
    },
  ),
  Scenario('109-labels', '/settings/labels', seed: _organize),
  Scenario('110-payment-methods', '/settings/payment-methods', seed: _organize),
  Scenario('111-budget', '/settings/budgets', seed: _organize),
  // ---- 112–113 Automation ----
  const Scenario('112-automation', '/settings/automation'),
  Scenario('113-early-access', '/settings/automation', act: (t, f) => tapVisible(t, find.byIcon(LucideIcons.sparkles))),
  // ---- unchanged screens ----
  const Scenario('currency', '/settings/currency'),
  const Scenario('privacy', '/settings/privacy'),
  const Scenario('terms', '/settings/terms'),
];

/// Scrolls S10 to its last card (the privacy note, found by its lock icon).
Future<void> _scrollToEnd(WidgetTester t) async {
  await t.scrollUntilVisible(find.byIcon(AppIcons.privacy), 400);
  await t.drag(find.byType(Scrollable).first, const Offset(0, -400));
  await settle(t);
}

Future<void> _tap(WidgetTester t, Finder f) async {
  await t.tap(f);
  await settle(t);
}

Future<void> _run(
  WidgetTester tester,
  Scenario s, {
  required bool dark,
  required String locale,
  required double scale,
  required Size size,
  String? save,
}) async {
  final f = await SettingsFixture.create(ratesAge: s.offline ? const Duration(days: 3) : const Duration(hours: 2));
  f.online = !s.offline;
  if (s.seed != null) await tester.runAsync(() => s.seed!(f));
  await pumpSettings(
    tester,
    f,
    location: s.location,
    dark: dark,
    locale: locale,
    textScale: scale,
    size: size,
    dpr: 1.5,
    notificationsOn: s.notificationsOn,
  );
  if (s.act != null) await s.act!(tester, f);
  if (save != null) await shot(tester, save);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadSettingsFonts();
  });

  for (final s in scenarios) {
    group(s.name, () {
      // Mockup comparison set: light EN + dark VI at 390 × 844.
      settingsTest(
        'light EN 390',
        (t) => _run(t, s, dark: false, locale: 'en', scale: 1, size: const Size(390, 844), save: '${s.name}-light-en'),
      );
      settingsTest(
        'dark VI 390',
        (t) => _run(t, s, dark: true, locale: 'vi', scale: 1, size: const Size(390, 844), save: '${s.name}-dark-vi'),
      );
      settingsTest('dark EN 390', (t) => _run(t, s, dark: true, locale: 'en', scale: 1, size: const Size(390, 844)));
      settingsTest('light VI 390', (t) => _run(t, s, dark: false, locale: 'vi', scale: 1, size: const Size(390, 844)));
      // Smallest phone at the largest text.
      for (final locale in ['en', 'vi']) {
        settingsTest(
          'light $locale 320 200%',
          (t) => _run(t, s, dark: false, locale: locale, scale: 2, size: const Size(320, 640)),
        );
      }
      // Worst cases: Vietnamese on the smallest frame, large text.
      for (final scale in [1.3, 2.0]) {
        for (final locale in ['en', 'vi']) {
          final pct = (scale * 100).round();
          settingsTest(
            'light $locale 360 $pct%',
            (t) => _run(
              t,
              s,
              dark: false,
              locale: locale,
              scale: scale,
              size: const Size(360, 800),
              save: locale == 'vi' ? '${s.name}-light-vi-360-$pct' : null,
            ),
          );
        }
      }
    });
  }
}
