import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/organize_repository.dart';
import 'package:subnest/domain/domain.dart';

import '../catalog/add_harness.dart';

Finder get _amount => find.descendant(of: find.byType(AmountField), matching: find.byType(TextField));
Finder get _formList => find.byType(Scrollable).first;

/// Digits shown in the price field (the currency symbol is drawn beside them).
String _amountText(WidgetTester tester) => tester.widget<TextField>(_amount).controller!.text;

/// Brings [f] on screen: built already → ensureVisible (up or down), else scroll down to it.
Future<void> _scrollTo(WidgetTester tester, Finder f) async {
  if (f.evaluate().isNotEmpty) {
    Scrollable.ensureVisible(tester.element(f.first), alignment: .5);
  } else {
    await _toTop(tester);
    await tester.scrollUntilVisible(f, 200, scrollable: _formList);
    Scrollable.ensureVisible(tester.element(f.first), alignment: .5);
  }
  await settle(tester);
}

Future<void> _toTop(WidgetTester tester) async {
  await tester.fling(_formList, const Offset(0, 3000), 5000);
  await settle(tester);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadFonts();
  });

  addTest('S4 add from the Catalog: Netflix Premium, split 4 → saved, Overview (png 20, flow 2)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');
    expect(find.text('New subscription'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Netflix'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget);
    expect(_amountText(tester), '273,000');
    expect(find.text('Next renewal'), findsOneWidget);
    expect(find.text('Fri, 4 Dec 2026'), findsOneWidget);
    expect(find.text('Then 4 Jan 2027 · 4 Feb 2027 · 4 Mar 2027…'), findsOneWidget);

    await _scrollTo(tester, find.text('Split with others'));
    await tester.tap(find.byType(AppToggle).at(1));
    await settle(tester);
    await _scrollTo(tester, find.text('Your share'));
    await tester.tap(find.bySemanticsLabel('More'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('More'));
    await settle(tester);
    await _scrollTo(tester, find.text('₫273,000 ÷ 4'));
    expect(find.text('₫68,250 /month'), findsOneWidget);
    await shot(tester, 's4-add-split-390-en-light-100');

    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    expect(visited.last, '/home');
    final saved = (await f.subs.all()).single;
    expect(saved.name, 'Netflix Premium');
    expect(saved.priceMinor, 273000);
    expect(saved.currency, 'VND');
    expect(saved.sharedWith, 4);
    expect(saved.serviceId, 'netflix');
    expect(saved.category, SubscriptionCategory.video);
    expect(saved.dueDate, const LocalDate(2026, 12, 4));
    expect(saved.manageUrl, isNotNull);
  });

  addTest('S4 custom + trial validation (png 21)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new');
    expect(find.text('Service name'), findsOneWidget);
    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Price must be more than 0'), findsOneWidget);
    final button = tester.widget<AppButton>(find.widgetWithText(AppButton, 'Add subscription'));
    expect(button.onPressed, isNull, reason: 'disabled while errors show');

    // Trial on → "First charge", "Price after trial"; pick a past end date → error.
    await _scrollTo(tester, find.text('Free trial'));
    await tester.tap(find.byType(AppToggle).first);
    await settle(tester);
    expect(find.text('Trial ends'), findsOneWidget);
    await _scrollTo(tester, find.text('Price after trial'));
    expect(find.text('First charge'), findsOneWidget);
    await _scrollTo(tester, find.text('Trial ends'));
    await tester.tap(find.text('Wed, 11 Nov 2026').last);
    await settle(tester);
    await tester.tap(find.text('2').last);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('Trial end can’t be in the past'), findsOneWidget);
    await _toTop(tester);
    await shot(tester, 's4-trial-validation-390-en-light-100');

    // Fix everything → saves as a Trial.
    await tester.enterText(find.byType(TextField).first, 'Gym club');
    await tester.enterText(_amount, '150000');
    await settle(tester);
    await _scrollTo(tester, find.text('Mon, 2 Nov 2026').last);
    await tester.tap(find.text('Mon, 2 Nov 2026').last);
    await settle(tester);
    await tester.tap(find.text('20').last);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('Trial end can’t be in the past'), findsNothing);
    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    final saved = (await f.subs.all()).single;
    expect(saved.name, 'Gym club');
    expect(saved.priceMinor, 150000);
    expect(saved.status, SubscriptionStatus.trial);
    expect(saved.trialEndDate, const LocalDate(2026, 11, 20));
  });

  addTest('S4 edit price → note + "Apply from next period" dialog (png 22, 27)', (tester) async {
    final f = await AddFixture.create();
    await f.addNetflix();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/netflix/edit');
    expect(find.text('Edit subscription'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Netflix'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget, reason: 'plan split off the saved name');
    await tester.enterText(_amount, '280000');
    await settle(tester);
    expect(
      find.text('Was ₫260,000. The new price applies from the next period (4 Dec). Past payments stay as they were.'),
      findsOneWidget,
    );
    await shot(tester, 's4-edit-price-390-en-light-100');
    await tester.tap(find.text('Save changes'));
    await settle(tester);
    expect(find.text('Use ₫280,000 from the next period?'), findsOneWidget);
    expect(
      find.text(
        'The 4 Dec renewal and later ones use the new price. Your 5 past payments stay at what you actually paid.',
      ),
      findsOneWidget,
    );
    await shot(tester, 's4-price-confirm-390-en-light-100');
    await tester.tap(find.text('Apply from next period'));
    await settle(tester);
    expect(visited.last, '/home');
    final s = (await f.subs.get('netflix'))!;
    expect(s.priceMinor, 280000);
    expect(s.name, 'Netflix Premium');
    expect(s.sharedWith, 4);
    final periods = await f.subs.allPeriods();
    expect(periods.where((p) => p.amountMinor == 65000), hasLength(5), reason: 'past payments untouched');
  });

  addTest('S4 edit price → "Keep" saves other changes with the old price', (tester) async {
    final f = await AddFixture.create();
    await f.addNetflix();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/netflix/edit');
    await tester.enterText(_amount, '280000');
    await tester.enterText(find.byType(TextField).first, 'Netflix 4K');
    await settle(tester);
    await tester.tap(find.text('Save changes'));
    await settle(tester);
    await tester.tap(find.text('Keep ₫260,000'));
    await settle(tester);
    final s = (await f.subs.get('netflix'))!;
    expect(s.priceMinor, 260000);
    expect(s.name, 'Netflix 4K Premium');
  });

  addTest('S4 date picker sheet (png 23) moves the renewal', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');
    await tester.tap(find.text('Fri, 4 Dec 2026'));
    await settle(tester);
    expect(find.text('December 2026'), findsOneWidget);
    expect(find.text('Then 4 Jan 2027 · 4 Feb 2027 · 4 Mar 2027…'), findsWidgets);
    await shot(tester, 's4-date-picker-390-en-light-100');
    await tester.tap(find.text('10').last);
    await settle(tester);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.text('Thu, 10 Dec 2026'), findsOneWidget);
  });

  addTest('S4 tile sheet: colour + emoji (png 24)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');
    await tester.tap(find.bySemanticsLabel('Change tile'));
    await settle(tester);
    expect(find.text('Tile'), findsOneWidget);
    expect(find.text('Preview in a list'), findsOneWidget);
    expect(find.text('Netflix Premium'), findsOneWidget);
    expect(find.textContaining('own colour from the library'), findsOneWidget);
    await shot(tester, 's4-tile-sheet-390-en-light-100');
    await tester.tap(find.bySemanticsLabel('Colour 6'));
    await tester.tap(find.text('🎬'));
    await settle(tester);
    await tester.tap(find.text('Done'));
    await settle(tester);
    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    final s = (await f.subs.all()).single;
    expect(s.iconText, '🎬');
    expect(s.colorValue, isNot(0xFFE50914));
  });

  addTest('S4 currency sheet (png 25): USD shows ≈ conversion', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?name=Claude');
    await tester.tap(find.text('VND'));
    await settle(tester);
    expect(find.text('Currency for this subscription'), findsOneWidget);
    expect(find.text('USED BY YOUR SUBSCRIPTIONS'), findsOneWidget);
    expect(find.text('VND · Vietnamese đồng'), findsOneWidget);
    expect(find.text('Main currency'), findsOneWidget);
    expect(find.text('1 USD ≈ ₫25,400'), findsOneWidget);
    await shot(tester, 's4-currency-390-en-light-100');
    await tester.enterText(find.byType(TextField).last, 'dollar');
    await settle(tester);
    await tester.tap(find.text('USD · US dollar'));
    await settle(tester);
    await tester.enterText(_amount, '20');
    await settle(tester);
    expect(find.text('≈ ₫508,000'), findsOneWidget);
  });

  addTest('S4 at 320dp × 200% VI: cycle chips in a 2 × 2 grid, labels not cut', (tester) async {
    // Real phone (2026-11-05), largest display + font: one row cut the chips to "T… T… Q… N…".
    final f = await AddFixture.create();
    await pumpAdd(
      tester,
      f,
      location: '/home',
      push: '/subscription/new?service=netflix&plan=premium',
      setup: const Setup(width: 320, height: 700, locale: 'vi', textScale: 2),
    );
    await _scrollTo(tester, find.text('Năm'));
    expect(tester.getTopLeft(find.text('Năm')).dy, greaterThan(tester.getBottomLeft(find.text('Tuần')).dy));
    for (final label in ['Tuần', 'Tháng', 'Quý', 'Năm']) {
      expect(tester.renderObject<RenderParagraph>(find.text(label)).didExceedMaxLines, isFalse, reason: label);
    }
    await tester.tap(find.text('Năm'));
    await settle(tester);
    expectNoLayoutErrors(tester, '320');
  });

  addTest('S4 cycle chips, unit menu, several reminders, more details (png 26, 32)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');
    await tester.tap(find.text('Yearly'));
    await settle(tester);
    expect(find.text('Then 4 Dec 2027 · 4 Dec 2028 · 4 Dec 2029…'), findsOneWidget);
    await tester.tap(find.text('Quarterly'));
    await settle(tester);
    expect(find.text('Then 4 Mar 2027 · 4 Jun 2027 · 4 Sep 2027…'), findsOneWidget);
    expect(find.widgetWithText(TextField, '3'), findsOneWidget);
    await tester.tap(find.text('months'));
    await settle(tester);
    await tester.tap(find.text('weeks').last);
    await settle(tester);
    expect(find.text('Every 3 weeks'), findsNothing);

    // Remind me: Settings default {0, 3} pre-selected; each chip toggles on its own.
    await _scrollTo(tester, find.text('Remind me'));
    expect(find.text('Pick any — each one sends its own reminder at 9:00.'), findsOneWidget);
    bool on(String label) => tester.widget<AppChip>(find.widgetWithText(AppChip, label)).selected;
    expect([on('On day'), on('1 day'), on('3 days'), on('7 days')], [true, false, true, false]);
    await tester.tap(find.text('7 days'));
    await settle(tester);
    await tester.tap(find.text('On day'));
    await settle(tester);
    expect([on('On day'), on('1 day'), on('3 days'), on('7 days')], [false, false, true, true]);

    await _scrollTo(tester, find.text('More details'));
    expect(find.text('Cancel link, notes'), findsOneWidget);
    await tester.tap(find.text('More details'));
    await settle(tester);
    await _scrollTo(tester, find.text('Notes'));
    expect(find.text('Filled in from the library. Opens from “How to cancel”.'), findsOneWidget);
    await shot(tester, 's4-more-details-390-en-light-100');
    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    final s = (await f.subs.all()).single;
    expect(s.cycle, const BillingCycle(3, CycleUnit.week));
    expect(s.reminderOffsets, {3, 7});
  });

  addTest('S4 organize: category, labels + New label, payment method sheet + quick add, Worth it (png 36, 37)', (
    tester,
  ) async {
    final f = await AddFixture.create();
    final organize = OrganizeRepository(f.db, clock: () => kNow);
    final family = await organize.addLabel('Family', colorValue: 0xFF2856D8);
    await organize.addPaymentMethod('Visa ••4242');
    final momo = await organize.addPaymentMethod('MoMo');
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');

    // Category: the user's Categories, Video pre-selected from the Catalog.
    await _scrollTo(tester, find.text('Category'));
    await tester.tap(find.text('Learning'));
    await settle(tester);

    // Labels: pick one, quick-add another.
    await _scrollTo(tester, find.text('Labels'));
    await tester.tap(find.text('Family'));
    await settle(tester);
    await tester.tap(find.text('New label'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'Work');
    await settle(tester);
    await tester.tap(find.text('Add').last);
    await settle(tester);
    expect(find.text('Work'), findsOneWidget);

    // Payment method sheet: list with usage, None, quick add.
    await _scrollTo(tester, find.text('Payment method'));
    await tester.tap(find.bySemanticsLabel('Payment method: None'));
    await settle(tester);
    expect(find.text('Visa ••4242'), findsOneWidget);
    expect(find.text('Not used yet'), findsNWidgets(2));
    expect(find.text('Free text — Subnest never connects to your bank.'), findsOneWidget);
    await shot(tester, 's4-method-sheet-390-en-light-100');
    await tester.tap(find.text('MoMo'));
    await settle(tester);
    expect(find.bySemanticsLabel('Payment method: MoMo'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Payment method: MoMo'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'Techcombank ••88');
    await settle(tester);
    await tester.tap(find.text('Add').last);
    await settle(tester);
    expect(find.bySemanticsLabel('Payment method: Techcombank ••88'), findsOneWidget);

    // Worth it?
    await _scrollTo(tester, find.text('Worth it?'));
    await tester.tap(find.bySemanticsLabel('Not sure'));
    await settle(tester);
    await shot(tester, 's4-organize-390-en-light-100');

    await tester.tap(find.text('Add subscription'));
    await settle(tester);
    final s = (await f.subs.all()).single;
    final methods = await f.db.select(f.db.paymentMethods).get();
    final tcb = methods.firstWhere((m) => m.name == 'Techcombank ••88');
    final labels = await f.db.select(f.db.labels).get();
    expect(s.categoryId, 'education');
    expect(s.labelIds, {family.id, labels.firstWhere((x) => x.name == 'Work').id});
    expect(s.paymentMethodId, tcb.id);
    expect(s.paymentMethod, 'Techcombank ••88');
    expect(s.worthIt, WorthIt.unsure);
    expect(methods.map((m) => m.id), contains(momo.id));
  });

  addTest('S4 edit: Delete subscription at the end asks first (png 28)', (tester) async {
    final f = await AddFixture.create();
    await f.addNetflix();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/netflix/edit');
    await _scrollTo(tester, find.text('Delete subscription'));
    await tester.tap(find.text('Delete subscription'));
    await settle(tester);
    expect(find.text('Delete Netflix Premium?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await settle(tester);
    expect(await f.subs.all(), isEmpty);
    expect(find.text('stub:home'), findsOneWidget);
  });

  group('S4 layout matrix (360/390 · EN/VI · light/dark · 100/130/200% + 320 × 200%)', () {
    for (final s in layoutMatrixNarrow) {
      addTest('add + edit + sheets ${s.name}', (tester) async {
        final f = await AddFixture.create();
        await f.addNetflix();
        await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium', setup: s);
        expectNoLayoutErrors(tester, 'add');
        final l = l10nFor(s.locale);
        // Validation + trial + split + more details, scrolled through.
        await tester.enterText(_amount, '');
        await tester.enterText(find.byType(TextField).first, '');
        await settle(tester);
        await tester.tap(find.text(l.subscriptionFormAddButton));
        await settle(tester);
        expectNoLayoutErrors(tester, 'errors');
        if (s.width == 390 && s.textScale == 1 || s.width == 360 && !s.dark) {
          await shot(tester, 's4-validation-${s.name}');
        }
        for (final label in [l.subscriptionFormTrial, l.subscriptionFormShared]) {
          await _scrollTo(tester, find.text(label));
          await tester.tap(find.text(label));
          await settle(tester);
        }
        await _scrollTo(tester, find.text(l.subscriptionFormNewLabel));
        await tester.tap(find.text(l.subscriptionFormNewLabel));
        await settle(tester);
        expectNoLayoutErrors(tester, 'new label sheet');
        await tester.tapAt(const Offset(20, 60));
        await settle(tester);
        await _scrollTo(tester, find.text(l.subscriptionFormPaymentMethod));
        await tester.tap(find.bySemanticsLabel(RegExp('^${RegExp.escape(l.subscriptionFormPaymentMethod)}: ')));
        await settle(tester);
        expectNoLayoutErrors(tester, 'method sheet');
        await tester.tapAt(const Offset(20, 60));
        await settle(tester);
        await _scrollTo(tester, find.text(l.subscriptionFormWorthIt));
        expectNoLayoutErrors(tester, 'worth it');
        await _scrollTo(tester, find.text(l.subscriptionFormMore));
        await tester.tap(find.text(l.subscriptionFormMore));
        await settle(tester);
        await tester.scrollUntilVisible(find.text(l.subscriptionFormNotes), 300, scrollable: _formList);
        expectNoLayoutErrors(tester, 'scrolled');
        // Sheets.
        await _toTop(tester);
        await tester.tap(find.bySemanticsLabel(l.subscriptionFormEditTile));
        await settle(tester);
        expectNoLayoutErrors(tester, 'tile sheet');
        if (s.width == 390 && s.textScale == 1 || s.width == 360 && !s.dark) {
          await shot(tester, 's4-tile-sheet-${s.name}');
        }
        await tester.tap(find.text(l.commonDone));
        await settle(tester);
        await tester.tap(find.text('VND').first);
        await settle(tester);
        expectNoLayoutErrors(tester, 'currency sheet');
        await tester.tapAt(const Offset(20, 60));
        await settle(tester);

        // Edit screen with the price note.
        await pumpAdd(tester, f, location: '/home', push: '/subscription/netflix/edit', setup: s);
        await tester.enterText(_amount, '280000');
        await settle(tester);
        expectNoLayoutErrors(tester, 'edit');
        if (s.width == 390 && s.textScale == 1 || s.width == 360 && !s.dark) {
          await shot(tester, 's4-edit-price-${s.name}');
        }
        await _scrollTo(tester, find.text(l.subscriptionFormDelete));
        expectNoLayoutErrors(tester, 'edit end');
        await tester.tap(find.text(l.subscriptionFormSaveChanges));
        await settle(tester);
        expectNoLayoutErrors(tester, 'price dialog');
      });
    }
  });

  addTest('S4 meets tap-target, label and contrast guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/home', push: '/subscription/new?service=netflix&plan=premium');
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });
}
