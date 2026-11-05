import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/domain/domain.dart';

import 'ui_harness.dart';

/// Golden renders of S2 / S5 / S6 / S7 next to the mockups (design/png 08–15, 28–40):
/// `flutter test --update-goldens --dart-define=UI_SHOTS=true test/features/home/renders_test.dart`
/// → notes/img/2026-11-05-ui-home/render/. Skipped in normal runs.
Future<void> scrollTo(WidgetTester tester, Finder f, {double alignment = 0}) async {
  for (var i = 0; i < 30 && f.evaluate().isEmpty; i++) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200), warnIfMissed: false);
    await tester.pumpAndSettle();
  }
  await Scrollable.ensureVisible(tester.element(f.first), alignment: alignment);
  await tester.pumpAndSettle();
}

typedef Scene = Future<void> Function(WidgetTester tester, Setup s, String suffix);

final Map<String, Scene> scenes = {
  '08-s2-overview': (t, s, x) async {
    await pumpApp(t, setup: s);
    await shot('08-s2-overview-$x');
  },
  '09-s2-empty': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: const [], periods: const []);
    await shot('09-s2-empty-$x');
  },
  '10-s2-many-awaiting': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: Mock.many);
    await shot('10-s2-many-awaiting-$x');
  },
  '11-s2-offline-reminders-off': (t, s, x) async {
    await pumpApp(
      t,
      setup: s,
      remindersOn: false,
      rates: Mock.rates.copyWith(fetchedAt: now.subtract(const Duration(days: 3))),
    );
    await shot('11-s2-offline-reminders-off-$x');
  },
  '12-s2-trials': (t, s, x) async {
    await pumpApp(t, setup: s);
    await scrollTo(t, find.byKey(const ValueKey('row-netflix')), alignment: .5);
    await t.tap(find.textContaining(s.locale == 'vi' ? 'Dùng thử ' : 'Trials ', findRichText: true).last);
    await settle(t);
    await scrollTo(t, find.byKey(const ValueKey('row-spotify')), alignment: .75);
    await shot('12-s2-trials-$x');
  },
  '13-s2-cancelled': (t, s, x) async {
    await pumpApp(t, setup: s);
    await scrollTo(t, find.byKey(const ValueKey('row-netflix')), alignment: .5);
    await t.tap(find.textContaining(s.locale == 'vi' ? 'Đã huỷ ' : 'Cancelled ', findRichText: true).last);
    await settle(t);
    await scrollTo(t, find.byKey(const ValueKey('row-applemusic')), alignment: 1);
    await shot('13-s2-cancelled-$x');
  },
  '14-s2-swipe': (t, s, x) async {
    await pumpApp(t, setup: s);
    await scrollTo(t, find.byKey(const ValueKey('row-google1')), alignment: 1);
    await t.drag(find.byKey(const ValueKey('row-netflix')), const Offset(-170, 0));
    await t.pumpAndSettle();
    await shot('14-s2-swipe-$x');
  },
  '15-s2-sort': (t, s, x) async {
    await pumpApp(t, setup: s);
    await scrollTo(t, find.byIcon(AppIcons.sort), alignment: .5);
    await t.tap(find.byIcon(AppIcons.sort));
    await t.pumpAndSettle();
    await shot('15-s2-sort-$x');
  },
  '28-s5-detail': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/netflix');
    await shot('28-s5-detail-$x');
  },
  '29-s5-detail-history': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/netflix');
    await t.drag(find.byType(Scrollable).first, const Offset(0, -760));
    await t.pumpAndSettle();
    await shot('29-s5-detail-history-$x');
  },
  '30-s5-trial': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/spotify');
    await shot('30-s5-trial-$x');
  },
  '31-s5-cancelled': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/duolingo');
    await shot('31-s5-cancelled-$x');
  },
  '32-s5-delete': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/netflix');
    await scrollTo(t, find.byIcon(AppIcons.delete), alignment: .5);
    await t.tap(find.byIcon(AppIcons.delete));
    await t.pumpAndSettle();
    await shot('32-s5-delete-$x');
  },
  '33-s5-celebrate': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/canva');
    await scrollTo(t, find.byIcon(AppIcons.cancelled), alignment: .5);
    await t.tap(find.byIcon(AppIcons.cancelled).last);
    await t.pumpAndSettle();
    await t.tap(find.byIcon(AppIcons.cancelled).last); // dialog: Mark as cancelled
    for (var i = 0; i < 4; i++) {
      await t.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
      await t.pump(const Duration(milliseconds: 100));
    }
    await t.pump(const Duration(milliseconds: 250)); // confetti mid-fall
    await shot('33-s5-celebrate-$x');
    await t.pumpAndSettle();
  },
  '40-s5-edit-payment': (t, s, x) async {
    await pumpApp(t, setup: s, location: '/subscription/netflix');
    await scrollTo(t, find.byIcon(AppIcons.edit), alignment: .5);
    await t.tap(find.byIcon(AppIcons.edit).first);
    await t.pumpAndSettle();
    await t.enterText(find.byType(EditableText).first, '70000');
    await t.pumpAndSettle();
    FocusManager.instance.primaryFocus?.unfocus();
    await t.pumpAndSettle();
    await shot('40-s5-edit-payment-$x');
  },
  '34-s6-confirm': (t, s, x) async {
    await pumpApp(t, setup: s, push: '/confirm/netflix');
    await shot('34-s6-confirm-$x');
  },
  '35-s6-paid': (t, s, x) async {
    await pumpApp(t, setup: s, push: '/confirm/netflix');
    await t.tap(find.byIcon(AppIcons.check));
    await settle(t);
    await shot('35-s6-paid-$x');
  },
  '36-s6-catch-up': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: Mock.many, push: '/confirm/viettel');
    await shot('36-s6-catch-up-$x');
  },
  '37-s7-pending': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: Mock.many, location: '/awaiting');
    await shot('37-s7-pending-$x');
  },
  '38-s7-confirm-all': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: Mock.many, location: '/awaiting');
    await t.tap(find.byIcon(AppIcons.check).last);
    await t.pumpAndSettle();
    await shot('38-s7-confirm-all-$x');
  },
  '39-s7-empty': (t, s, x) async {
    await pumpApp(t, setup: s, subscriptions: [Mock.chatgpt], location: '/awaiting');
    await shot('39-s7-empty-$x');
  },
};

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('golden renders', skip: !uiShots, () {
    for (final e in scenes.entries) {
      for (final dark in [false, true]) {
        for (final locale in ['en', 'vi']) {
          final x = '${locale == 'vi' ? 'vi-' : ''}${dark ? 'dark' : 'light'}';
          testWidgets('${e.key} $x', (tester) async {
            await e.value(tester, Setup(dark: dark, locale: locale), x);
            await closeApp(tester);
          });
        }
      }
    }
    // Large text at the smallest frame, VI (worst case).
    for (final key in ['08-s2-overview', '28-s5-detail', '34-s6-confirm', '37-s7-pending']) {
      for (final scale in [1.3, 2.0]) {
        testWidgets('$key 360 vi ${(scale * 100).round()}%', (tester) async {
          final s = Setup(locale: 'vi', width: 360, height: 800, textScale: scale);
          await scenes[key]!(tester, s, 'vi-360-${(scale * 100).round()}');
          await closeApp(tester);
        });
      }
    }
  });

  // Keep the analyzer happy about the unused domain import when shots are off.
  test('sample data is the mockup data', () {
    expect(Mock.all.where((s) => s.status == SubscriptionStatus.cancelled).length, 2);
  });
}
