import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/features/lock/pin_screens.dart';
import 'package:subnest/features/lock/pin_service.dart';
import 'package:subnest/features/lock/privacy_screen.dart';
import 'package:subnest/features/settings/auto_backup_section.dart';
import 'package:subnest/features/settings/security_section.dart';

import 'settings_harness.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadSettingsFonts();
  });

  final en = l10nFor('en');
  final vi = l10nFor('vi');

  bool toggleOf(WidgetTester tester, String label) => tester
      .widget<AppToggle>(
        find.descendant(of: find.widgetWithText(SettingRow, label), matching: find.byType(AppToggle)),
      )
      .value;

  Future<void> enterPin(WidgetTester tester, String pin) async {
    for (final d in pin.split('')) {
      await tester.tap(find.byKey(ValueKey('pin-key-$d')));
      await tester.pump();
    }
    await settle(tester);
  }

  PinService pinOf(SettingsFixture f) => PinService(f.secrets, settings: () => f.settings);

  group('Settings › Security', () {
    settingsTest('comes right after Data with PIN lock and Privacy screen, both off', (tester) async {
      final f = await SettingsFixture.create();
      await pumpSettings(tester, f);
      await tester.scrollUntilVisible(find.text(en.securityPrivacyScreen), 300);
      await tester.pumpAndSettle();
      expect(find.text(en.securitySection.toUpperCase()), findsOneWidget);
      expect(find.text(en.securityPinWarning), findsOneWidget);
      expect(find.text(en.securityPrivacyScreenNote), findsOneWidget, reason: 'Android note');
      expect(toggleOf(tester, en.securityPinLock), isFalse);
      expect(toggleOf(tester, en.securityPrivacyScreen), isFalse);
      // Order: Data (… Delete all in the automatic-backup card) → Security → About.
      final list = tester.widget<ListView>(find.byType(ListView).first);
      final children = (list.childrenDelegate as SliverChildListDelegate).children;
      final data = children.indexWhere((w) => w is AutoBackupSection);
      final security = children.indexWhere((w) => w is SecuritySection);
      final about = children.indexWhere((w) => w is SectionHeader && w.label == en.settingsSectionAbout);
      expect(data, greaterThan(0));
      expect(security, greaterThan(data));
      expect(about, greaterThan(security));
    });

    settingsTest('iPhone note says screenshots cannot be blocked; Vietnamese labels', (tester) async {
      final f = await SettingsFixture.create(platform: FakeSettingsPlatform(ios: true));
      await pumpSettings(tester, f, locale: 'vi');
      await tester.scrollUntilVisible(find.text(vi.securityPrivacyScreen), 300);
      await tester.pumpAndSettle();
      expect(find.text('BẢO MẬT'), findsOneWidget);
      expect(find.text('Khoá mã PIN'), findsOneWidget);
      expect(find.text('Che nội dung khi chuyển app'), findsOneWidget);
      expect(find.text(vi.securityPrivacyScreenNoteIos), findsOneWidget);
    });

    settingsTest('turn PIN on: 4 digits twice, a mismatch starts over; saved as a hash', (tester) async {
      final f = await SettingsFixture.create();
      await pumpSettings(tester, f);
      await tapVisible(tester, find.text(en.securityPinLock));
      expect(find.byType(PinSetupScreen), findsOneWidget);
      expect(find.text(en.securityNewPin), findsOneWidget);
      expect(find.text(en.securityPinWarning), findsOneWidget, reason: 'forgot-PIN warning on the first step');

      await enterPin(tester, '1234');
      expect(find.text(en.securityConfirmPin), findsOneWidget);
      expect(find.text(en.securityPinWarning), findsNothing);
      await enterPin(tester, '1235');
      expect(find.text(en.securityPinMismatch), findsOneWidget);
      expect(find.text(en.securityNewPin), findsOneWidget, reason: 'starts over');
      expect(await pinOf(f).isEnabled(), isFalse);

      await enterPin(tester, '1234');
      await enterPin(tester, '1234');
      expect(find.byType(PinSetupScreen), findsNothing);
      expect(toggleOf(tester, en.securityPinLock), isTrue);
      expect(await pinOf(f).isEnabled(), isTrue);
      expect(await pinOf(f).verify('1234'), isTrue);
      expect(f.secrets.values.values.any((v) => v.contains('1234')), isFalse);
    });

    settingsTest('Back while choosing a PIN: the lock stays off', (tester) async {
      final f = await SettingsFixture.create();
      await pumpSettings(tester, f);
      await tapVisible(tester, find.text(en.securityPinLock));
      await enterPin(tester, '1234');
      await tester.tap(find.byTooltip('Back'));
      await settle(tester);
      expect(find.byType(PinSetupScreen), findsNothing);
      expect(toggleOf(tester, en.securityPinLock), isFalse);
      expect(await pinOf(f).isEnabled(), isFalse);
    });

    settingsTest('turn PIN off: only with the current PIN', (tester) async {
      final f = await SettingsFixture.create();
      await pinOf(f).setPin('2580');
      await pumpSettings(tester, f);
      await tester.scrollUntilVisible(find.text(en.securityPinLock), 300);
      await tester.pumpAndSettle();
      expect(toggleOf(tester, en.securityPinLock), isTrue);

      await tapVisible(tester, find.text(en.securityPinLock));
      expect(find.byType(PinCheckScreen), findsOneWidget);
      expect(find.text(en.securityEnterPin), findsOneWidget);
      await enterPin(tester, '0852');
      expect(find.text(en.securityWrongPin), findsOneWidget);
      expect(await pinOf(f).isEnabled(), isTrue);

      // Back keeps it on.
      await tester.tap(find.byTooltip('Back'));
      await settle(tester);
      expect(toggleOf(tester, en.securityPinLock), isTrue);

      await tapVisible(tester, find.text(en.securityPinLock));
      await enterPin(tester, '2580');
      expect(find.byType(PinCheckScreen), findsNothing);
      expect(toggleOf(tester, en.securityPinLock), isFalse);
      expect(await pinOf(f).isEnabled(), isFalse);
      for (final k in [PinService.hashKey, PinService.saltKey, PinService.installKey]) {
        expect(f.secrets.values.containsKey(k), isFalse, reason: k);
      }
    });

    settingsTest('Privacy screen switch is saved in this phone\'s settings (not in backups)', (tester) async {
      final f = await SettingsFixture.create();
      await pumpSettings(tester, f);
      await tapVisible(tester, find.text(en.securityPrivacyScreen));
      expect(toggleOf(tester, en.securityPrivacyScreen), isTrue);
      expect((await f.settings.raw())[privacyScreenKey], 'true');
      expect(toggleOf(tester, en.securityPinLock), isFalse, reason: 'independent of the PIN');
      expect(SettingsRepository.backupKeys, isNot(contains(privacyScreenKey)));

      await tester.tap(find.text(en.securityPrivacyScreen));
      await settle(tester);
      expect(toggleOf(tester, en.securityPrivacyScreen), isFalse);
      expect((await f.settings.raw())[privacyScreenKey], isNull);
    });

    settingsTest('Delete all data turns the PIN and Privacy screen off', (tester) async {
      final f = await SettingsFixture.create();
      await pinOf(f).setPin('1234');
      await f.settings.set(privacyScreenKey, 'true');
      await pumpSettings(tester, f);
      await tapVisible(tester, find.text(en.settingsDeleteAll));
      expect(find.textContaining('turns off automatic backup and PIN lock'), findsOneWidget, reason: 'the confirmation says the PIN goes too');
      await tester.tap(find.text(en.settingsDelete));
      await settle(tester);
      await tester.tap(find.text(en.settingsDeleteEverything));
      await settle(tester);
      expect(find.text('ONBOARDING'), findsOneWidget);
      expect(await pinOf(f).isEnabled(), isFalse);
      expect(f.secrets.values, isEmpty);
      expect((await f.settings.raw())[privacyScreenKey], isNull);
    });
  });
}
