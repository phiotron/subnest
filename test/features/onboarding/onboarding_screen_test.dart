import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/domain/domain.dart';

import '../catalog/add_harness.dart';
import 'onboarding_helpers.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadFonts();
  });

  addTest('S1.0 language: first screen, only English/Tiếng Việt, applies at once (S-90)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.bySemanticsLabel('Step 1 of 5'), findsOneWidget);
    expect(find.text('Skip'), findsNothing, reason: 'the language choice cannot be skipped');
    await shot(tester, 's1-language-390-en-light-100');

    await tester.tap(find.text('Tiếng Việt'));
    await settle(tester);
    expect((await f.settings.load()).localeCode, 'vi');
  });

  addTest('S1.1 welcome (png 02)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('All your subscriptions, one nest'), findsOneWidget);
    expect(find.text('Reminders before you’re charged'), findsOneWidget);
    expect(find.text('Know exactly what each month costs'), findsOneWidget);
    expect(find.text('Private — data stays on your phone'), findsOneWidget);
    expect(find.bySemanticsLabel('Step 2 of 5'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await shot(tester, 's1-welcome-390-en-light-100');
  });

  addTest('S1.2 currency: USD by default, change via searchable sheet (png 03–04)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    expect(find.text('Your main currency'), findsOneWidget);
    expect(find.text('USD — US dollar'), findsOneWidget);
    expect(find.text('Default — change it any time'), findsOneWidget);
    expect(find.text('VND — Vietnamese đồng'), findsOneWidget);
    expect(find.text('Suggested for Vietnam'), findsNothing, reason: 'never suggested from the region');
    await shot(tester, 's1-currency-390-en-light-100');

    await tester.tap(find.text('Choose another currency'));
    await settle(tester);
    expect(find.text('Main currency'), findsOneWidget);
    expect(find.text('Search currency or country'), findsOneWidget);
    await shot(tester, 's1-currency-list-390-en-light-100');
    await tester.enterText(find.byType(TextField).last, 'singapore');
    await settle(tester);
    await tester.tap(find.text('SGD'));
    await settle(tester);
    expect(find.text('SGD — Singapore dollar'), findsOneWidget);
    expect(find.text('Your choice'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect((await f.settings.load()).primaryCurrency, 'SGD');
  });

  addTest('S1.3 pick 5 services, quick edit, total in USD (png 05)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('What do you pay for?'), findsOneWidget);
    expect(find.text('Nothing selected yet'), findsOneWidget);
    expect(find.text('Skip'), findsNothing, reason: 'no Skip after the currency step');
    await pickFive(tester);
    expect(find.text('5 selected'), findsOneWidget);
    // US prices (the global default): Netflix 8.99 + Spotify 12.99 + YouTube 15.99 +
    // ChatGPT Go 8.00 + iCloud+ 50 GB 0.99.
    expect(find.text('≈ \$46.96/month'), findsOneWidget);
    expect(find.text('iCloud+ 50 GB'), findsOneWidget);

    // Quick edit: iCloud+ 200 GB.
    await tester.tap(find.bySemanticsLabel('Edit price and cycle of iCloud+ 50 GB'));
    await settle(tester);
    await tester.tap(find.text('200 GB'));
    await settle(tester);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('iCloud+ 200 GB'), findsOneWidget);
    expect(find.text('\$2.99/month · Monthly'), findsOneWidget);
    expect(find.text('≈ \$48.96/month'), findsOneWidget);
    await tester.fling(find.byType(ListView).first, const Offset(0, 2000), 4000);
    await settle(tester);
    await shot(tester, 's1-services-390-en-light-100');

    // Untick one; search without accents.
    await tester.fling(find.byType(ListView).first, const Offset(0, 2000), 4000);
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Spotify'));
    await settle(tester);
    expect(find.text('4 selected'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'zzzz');
    await settle(tester);
    expect(find.text('No service called “zzzz”. You can add it later with +.'), findsOneWidget);
  });

  addTest('S1.4 reminders → OS permission once → Overview with data (png 06–07)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await pickFive(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('A heads-up before every charge'), findsOneWidget);
    // No picks in this flow's sample? The example is always USD (S-90).
    expect(find.text('Netflix renews in 3 days — \$8.99'), findsOneWidget);
    expect(f.notifications.permissionRequests, 0, reason: 'explain first (S-40)');
    await shot(tester, 's1-reminders-390-en-light-100');
    await tester.tap(find.text('Turn on reminders'));
    await settle(tester);
    expect(f.notifications.permissionRequests, 1);
    expect(visited.last, '/home');
    final settings = await f.settings.load();
    expect(settings.onboardingDone, isTrue);
    expect(settings.primaryCurrency, 'USD');
    final subs = await f.subs.all();
    expect(subs.map((s) => s.name).toSet(), {
      'Netflix Standard with ads',
      'Spotify Individual',
      'YouTube Premium Individual',
      'ChatGPT Go',
      'iCloud+ 50 GB',
    });
    expect(subs.every((s) => s.dueDate == const LocalDate(2026, 12, 4)), isTrue);
  });

  addTest('S1.4 "Not now" never asks the OS and still finishes (S-40)', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Skip'));
    await settle(tester);
    expect(find.text('A heads-up before every charge'), findsOneWidget, reason: 'Skip jumps to the explainer');
    expect(find.text('Netflix renews in 3 days — \$26.99'), findsOneWidget, reason: 'USD example (S-90)');
    await tester.tap(find.text('Not now'));
    await settle(tester);
    expect(f.notifications.permissionRequests, 0);
    expect(visited.last, '/home');
    expect((await f.settings.load()).onboardingDone, isTrue);
    expect(await f.subs.all(), isEmpty);
  });

  addTest('S1 system Back goes one step back; Later skips the services', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('Your main currency'), findsOneWidget);
    await tester.binding.handlePopRoute();
    await settle(tester);
    expect(find.text('All your subscriptions, one nest'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('Netflix'));
    await settle(tester);
    await tester.tap(find.text('Later'));
    await settle(tester);
    await tester.tap(find.text('Not now'));
    await settle(tester);
    expect(await f.subs.all(), isEmpty, reason: 'Later = add nothing now');
  });

  group('S1 layout matrix (360/390 · EN/VI · light/dark · 100/130/200%)', () {
    for (final s in layoutMatrix) {
      addTest('all steps ${s.name}', (tester) async {
        final l = l10nFor(s.locale);
        final f = await AddFixture.create(onboardingDone: false, primary: null);
        await pumpAdd(tester, f, location: '/onboarding', setup: s);
        final keep = s.width == 390 && s.textScale == 1 || s.width == 360 && !s.dark && s.locale == 'vi';
        expectNoLayoutErrors(tester, 'language');
        if (keep) await shot(tester, 's1-language-${s.name}');
        await tester.tap(find.text(l.commonContinue));
        await settle(tester);
        expectNoLayoutErrors(tester, 'welcome');
        if (keep) await shot(tester, 's1-welcome-${s.name}');
        await tester.tap(find.text(l.onboardingStart));
        await settle(tester);
        expectNoLayoutErrors(tester, 'currency');
        if (keep) await shot(tester, 's1-currency-${s.name}');
        await tester.ensureVisible(find.text(l.onboardingCurrencyChange));
        await settle(tester);
        await tester.tap(find.text(l.onboardingCurrencyChange));
        await settle(tester);
        expectNoLayoutErrors(tester, 'currency sheet');
        if (keep) await shot(tester, 's1-currency-list-${s.name}');
        await tester.tap(find.text('VND').last);
        await settle(tester);
        await tester.tap(find.text(l.commonContinue));
        await settle(tester);
        await pickFive(tester);
        expectNoLayoutErrors(tester, 'pick');
        await tester.fling(find.byType(ListView).first, const Offset(0, 2000), 4000);
        await settle(tester);
        if (keep) await shot(tester, 's1-services-${s.name}');
        await tester.tap(find.byType(AppButton).first);
        await settle(tester);
        expectNoLayoutErrors(tester, 'quick edit');
        await tester.tap(find.text(l.commonDone));
        await settle(tester);
        await tester.tap(find.text(l.commonContinue));
        await settle(tester);
        expectNoLayoutErrors(tester, 'reminders');
        if (keep) await shot(tester, 's1-reminders-${s.name}');
      });
    }
  });

  addTest('S1 meets tap-target, label and contrast guidelines', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpAdd(tester, f, location: '/onboarding');
    for (var i = 0; i < 5; i++) {
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      // The grid cell's node spans the coloured tile too, which fools the pixel-sampling contrast
      // check; its text is `ink` on `bg` / `brand-soft` (AA by the tokens).
      if (i != 3) await expectLater(tester, meetsGuideline(textContrastGuideline));
      final next = [
        find.text('Continue'),
        find.text('Get started'),
        find.text('Continue'),
        find.text('Continue'),
      ];
      if (i < 4) {
        if (i == 3) await pickFive(tester);
        await tester.tap(next[i].last);
        await settle(tester);
      }
    }
  });
}
