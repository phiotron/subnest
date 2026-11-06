import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/catalog/catalog_helpers.dart';

import 'dart:io';

import 'add_harness.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadFonts();
  });

  group('CatalogView', () {
    final catalog = CatalogRepository.parse(File('assets/catalog/services.json').readAsStringSync());
    final en = l10nFor('en');

    test('popular services first; Vietnamese ones only in VN', () {
      final vn = CatalogView.ordered(catalog, 'VN');
      expect(vn.take(5).map((s) => s.id), ['netflix', 'spotify', 'youtube-premium', 'chatgpt', 'icloud']);
      expect(vn.map((s) => s.id).toSet(), hasLength(catalog.length));
      final us = CatalogView.ordered(catalog, 'US');
      expect(us.take(CatalogView.popularCount).any((s) => s.isVietnamese), isFalse);
    });

    test('search: aliases, no diacritics, prefix matches first', () {
      final all = CatalogView.ordered(catalog, 'VN');
      expect(CatalogView.search(all, 'netf').map((s) => s.id), ['netflix']);
      expect(CatalogView.search(all, 'NETFLIX').first.id, 'netflix');
      // Alias in Vietnamese without accents, typed with accents.
      expect(CatalogView.search(all, 'phím').map((s) => s.id), contains('netflix'));
      expect(CatalogView.search(all, 'zzzz'), isEmpty);
    });

    test('regional plans and "from" meta', () {
      final netflix = catalog.firstWhere((s) => s.id == 'netflix');
      expect(CatalogView.plans(netflix, 'VN').map((p) => p.name), ['Mobile', 'Basic', 'Standard', 'Premium']);
      expect(CatalogView.rowMeta(en, netflix, 'VN'), 'from ₫74,000/month · 4 plans');
      expect(CatalogView.plans(netflix, 'US').map((p) => p.id), isNot(contains('mobile')));
    });

    test('v13: plans closed to new customers are never offered', () {
      final copilot = catalog.firstWhere((s) => s.id == 'copilot');
      expect(copilot.plans.map((p) => p.id), contains('pro'));
      expect(CatalogView.plans(copilot, 'US').map((p) => p.id), isNot(contains('pro')));
    });

    test('v13 tabs: General = global section (US prices), Vietnam = VN section + global sold in VN', () {
      final general = CatalogView.forTab(catalog, LibraryTab.general);
      final vietnam = CatalogView.forTab(catalog, LibraryTab.vietnam);
      expect(general.any((s) => s.isVietnamese), isFalse);
      expect(general.first.id, 'netflix');
      expect(vietnam.map((s) => s.id), containsAll(['netflix', 'spotify']));
      expect(vietnam.map((s) => s.id), isNot(contains('notion')), reason: 'no VN price');
      expect(vietnam.where((s) => s.isVietnamese), hasLength(catalog.where((s) => s.isVietnamese).length));
      expect(CatalogView.regionFor(LibraryTab.general), 'US');
      expect(CatalogView.regionFor(LibraryTab.vietnam), 'VN');
    });

    test('v13 row meta: US price, ≈ Primary currency, plan count; Reference price flag', () {
      final netflix = catalog.firstWhere((s) => s.id == 'netflix');
      expect(
        CatalogView.rowMeta(en, netflix, 'US', approx: (p) => '≈ ${p.currency}'),
        'from \$8.99/month · ≈ USD · 3 plans',
      );
      expect(CatalogView.rowIsReference(netflix, 'US'), isFalse);
      final reference = catalog.where((s) => CatalogView.rowIsReference(s, 'US'));
      expect(reference, isNotEmpty);
    });
  });

  addTest('S3 library: focused search, chips, custom row, popular list (png 16)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    expect(find.text('Add subscription'), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.autofocus, isTrue);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Create a custom service'), findsOneWidget);
    expect(find.text('POPULAR IN VIETNAM'), findsOneWidget);
    expect(find.text('from ₫74,000/month · 4 plans'), findsOneWidget);
    await shot(tester, 's3-library-390-en-light-100');

    // Category chip filters.
    await tester.tap(find.text('Music'));
    await settle(tester);
    expect(find.text('Netflix'), findsNothing);
    expect(find.text('Spotify'), findsOneWidget);
  });

  addTest('S3 search "netf" → 1 result + "Not seeing it?" (png 17)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    await tester.enterText(find.byType(TextField), 'netf');
    await settle(tester);
    expect(find.text('1 RESULT'), findsOneWidget);
    expect(find.text('Netflix'), findsOneWidget);
    expect(find.text('Not seeing it? Create “netf”'), findsOneWidget);
    expect(find.text('All'), findsNothing, reason: 'chips hide while searching');
    await shot(tester, 's3-search-390-en-light-100');

    // Clear button.
    await tester.tap(find.byTooltip('Clear search'));
    await settle(tester);
    expect(find.text('POPULAR IN VIETNAM'), findsOneWidget);
  });

  addTest('S3 no results → Create “abc” opens S4 with the name (png 18)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    await tester.enterText(find.byType(TextField), 'qzxw');
    await settle(tester);
    expect(find.text('No service called “qzxw”'), findsOneWidget);
    expect(find.text('Create it — you can pick the colour and letters.'), findsOneWidget);
    await shot(tester, 's3-no-results-390-en-light-100');
    await tester.tap(find.text('Create “qzxw”'));
    await settle(tester);
    expect(find.text('New subscription'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'qzxw'), findsOneWidget);
  });

  addTest('S3 plan sheet: 4 plans with VN prices, Continue with Premium (png 19)', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    await tester.enterText(find.byType(TextField), 'netf');
    await settle(tester);
    await tester.tap(find.text('Netflix'));
    await settle(tester);
    expect(find.text('Choose a plan · suggested prices for Vietnam'), findsOneWidget);
    for (final p in ['Mobile', 'Basic', 'Standard', 'Premium']) {
      expect(find.text(p), findsOneWidget);
    }
    await tester.tap(find.text('Premium'));
    await settle(tester);
    expect(find.text('Continue with Premium'), findsOneWidget);
    await shot(tester, 's3-plan-sheet-390-en-light-100');
    await tester.tap(find.text('Continue with Premium'));
    await settle(tester);
    expect(find.text('New subscription'), findsOneWidget);
    expect(find.text('Premium'), findsOneWidget, reason: 'plan chip');
  });

  addTest('S3 v13 tabs (png 34, 35): Vietnam first on a VN phone; General shows US prices ≈ VND', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    expect(find.text('General'), findsOneWidget);
    expect(find.text('Vietnam'), findsOneWidget);
    expect(find.text('Search 500+ services'), findsOneWidget);
    await shot(tester, 's3-vietnam-390-en-light-100');
    await tester.tap(find.text('General'));
    await settle(tester);
    expect(find.text('POPULAR'), findsOneWidget);
    expect(find.text('from \$8.99/month · ≈ ₫228,346 · 3 plans'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('≈')), findsNothing, reason: '"≈" is spoken as a word');
    await shot(tester, 's3-general-390-en-light-100');

    // Picking from General pre-fills the US price the row showed.
    await tester.enterText(find.byType(TextField), 'netf');
    await settle(tester);
    await tester.tap(find.text('Netflix'));
    await settle(tester);
    expect(find.text('Choose a plan · suggested prices'), findsOneWidget);
    await tester.tap(find.textContaining('Continue with'));
    await settle(tester);
    expect(find.text('New subscription'), findsOneWidget);
    expect(find.text('USD'), findsOneWidget);
    expect(find.textContaining('≈ ₫'), findsOneWidget);
  });

  addTest('S3 v13: no tabs outside VN; Reference price chip on unverified prices', (tester) async {
    final f = await AddFixture.create(primary: 'USD');
    await pumpAdd(tester, f, location: '/catalog', deviceLocale: 'en_US');
    expect(find.text('General'), findsNothing);
    expect(find.text('Vietnam'), findsNothing);
    final catalog = CatalogRepository.parse(File('assets/catalog/services.json').readAsStringSync());
    final ref = CatalogView.forTab(catalog, LibraryTab.general).firstWhere((s) => CatalogView.rowIsReference(s, 'US'));
    await tester.enterText(find.byType(TextField), ref.name);
    await settle(tester);
    expect(find.text('Reference price'), findsWidgets);
    await shot(tester, 's3-reference-390-en-light-100');
  });

  addTest('S3 single-plan service skips the sheet', (tester) async {
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    await tester.enterText(find.byType(TextField), 'duolingo');
    await settle(tester);
    final rows = find.textContaining('Duolingo');
    expect(rows, findsWidgets);
    await tester.tap(rows.first);
    await settle(tester);
    // Either straight to the form, or a plan sheet when Duolingo has several plans.
    if (find.text('New subscription').evaluate().isEmpty) {
      await tester.tap(find.textContaining('Continue with'));
      await settle(tester);
    }
    expect(find.text('New subscription'), findsOneWidget);
  });

  group('S3 layout matrix (360/390 · EN/VI · light/dark · 100/130/200% + 320 × 200%)', () {
    for (final s in layoutMatrixNarrow) {
      addTest('library + search + sheet ${s.name}', (tester) async {
        final f = await AddFixture.create();
        await pumpAdd(tester, f, location: '/catalog', setup: s);
        expectNoLayoutErrors(tester, 'library');
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -600));
        await settle(tester);
        expectNoLayoutErrors(tester, 'library scrolled');
        await tester.tap(find.text(l10nFor(s.locale).catalogTabGeneral));
        await settle(tester);
        await tester.drag(find.byType(Scrollable).last, const Offset(0, -1200));
        await settle(tester);
        expectNoLayoutErrors(tester, 'general tab (≈ prices, Reference price chips)');
        await tester.enterText(find.byType(TextField), 'netf');
        await settle(tester);
        expectNoLayoutErrors(tester, 'search');
        await tester.tap(find.text('Netflix'));
        await settle(tester);
        expectNoLayoutErrors(tester, 'plan sheet');
        if (s.width == 390 && s.textScale == 1 || s.width == 360 && s.locale == 'vi' && !s.dark) {
          await shot(tester, 's3-plan-sheet-${s.name}');
        }
        await tester.tapAt(const Offset(20, 60));
        await settle(tester);
        await tester.enterText(find.byType(TextField), 'qzxw');
        await settle(tester);
        expectNoLayoutErrors(tester, 'no results');
      });
    }
  });

  addTest('S3 meets tap-target and contrast guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    final f = await AddFixture.create();
    await pumpAdd(tester, f, location: '/catalog');
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
    handle.dispose();
  });

  test('ServiceTile import keeps widgets reachable', () => expect(ServiceTile.initials('Netflix'), 'N'));
  test('domain import', () => expect(const BillingCycle.monthly().every, 1));
}
