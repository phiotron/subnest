import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';

import 'settings_harness.dart';

/// Every Settings screen/state (png 48–56) × light/dark × EN/VI × 360/390 × text 100/130/200%:
/// must lay out without overflow (a RenderFlex overflow fails the test).
///
/// Images for the notes: `flutter test test/features/settings/settings_shots_test.dart
/// --dart-define=SHOTS=true` writes them to notes/img/2026-11-05-ui-settings/.
class Scenario {
  const Scenario(this.name, this.location, {this.notificationsOn = true, this.offline = false, this.act});

  final String name;
  final String location;
  final bool notificationsOn;
  final bool offline;

  /// Opens a sheet/dialog or scrolls after the screen is up.
  final Future<void> Function(WidgetTester tester, SettingsFixture f)? act;
}

final scenarios = <Scenario>[
  const Scenario('48-settings', '/settings'),
  Scenario('49-settings-bottom', '/settings', act: (t, f) => _scrollToEnd(t)),
  Scenario('50-appearance', '/settings', act: (t, f) => tapVisible(t, find.byIcon(AppIcons.theme))),
  const Scenario('51-rates', '/settings/rates'),
  const Scenario('52-rates-offline', '/settings/rates', offline: true),
  Scenario(
    '53-rate-override',
    '/settings/rates',
    act: (t, f) async {
      await _tap(t, find.byIcon(AppIcons.next).first);
      await _tap(t, find.byType(AppToggle));
      await t.enterText(find.byType(TextField), '25000');
      await settle(t);
      // Keyboard is not part of the comparison.
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(t);
    },
  ),
  const Scenario('54-reminders-off', '/settings/reminders', notificationsOn: false),
  const Scenario('55-backup', '/settings/backup'),
  Scenario(
    '56-restore',
    '/settings/backup',
    act: (t, f) async {
      f.platform.nextPick = (name: 'subnest-backup-2026-09-24.json', text: f.backupJson);
      await tapVisible(t, find.byIcon(AppIcons.backup));
    },
  ),
  const Scenario('57-currency', '/settings/currency'),
  const Scenario('58-privacy', '/settings/privacy'),
  const Scenario('59-terms', '/settings/terms'),
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
