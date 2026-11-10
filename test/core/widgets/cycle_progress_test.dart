import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/domain/domain.dart';

import '../design_system_test.dart' show loadAppFonts, pumpUi;
import 'service_tile_logo_test.dart' show FakeLogoSource, decode, fakePng;

const today = LocalDate(2026, 11, 4);
const shot = Key('shot');

/// 8 of 31 days gone (Oct 27 → Nov 27), 23 left.
const active = CycleProgress(from: LocalDate(2026, 10, 27), due: LocalDate(2026, 11, 27), today: today);

/// Painter colours of the first bar under [of] (private painter → read dynamically).
({Color fill, Color track, double value}) bar(WidgetTester tester, [Finder? of]) {
  final paint = find.descendant(of: of ?? find.byType(CycleProgressBar), matching: find.byType(CustomPaint)).first;
  final p = tester.widget<CustomPaint>(paint).painter! as dynamic;
  return (fill: p.fill as Color, track: p.track as Color, value: p.value as double);
}

Widget row(
  SubscriptionRowState state, {
  String name = 'Netflix Premium',
  CycleProgress? progress = active,
  CycleProgressTone? tone,
  String? meta,
}) => Builder(
  builder: (context) => SubscriptionRow(
    name: name,
    colorValue: 0xFFE50914,
    serviceId: 'netflix',
    state: state,
    meta: meta ?? (state == SubscriptionRowState.cancelled ? 'Cancelled 04/11/2026' : 'Video'),
    badgeLabel: state == SubscriptionRowState.trial ? 'Free trial' : null,
    progress: progress,
    progressTone: tone,
    amount: '₫260,000',
    amountMeta: '/month',
    onTap: () {},
    onConfirm: () {},
    onCancel: () {},
  ),
);

/// Every state the bar has (normal with logo, trial, awaiting, paused, cancelled) in one group.
Widget allStates() => ServiceLogoScope(
  source: FakeLogoSource(services: {'netflix': fakePng}),
  child: AppGroup(
    children: [
      row(SubscriptionRowState.normal, name: 'Netflix Premium Family Plan (4K)'),
      row(SubscriptionRowState.trial, name: 'Spotify'),
      row(
        SubscriptionRowState.awaiting,
        name: 'ChatGPT Plus',
        progress: const CycleProgress(from: LocalDate(2026, 10, 2), due: LocalDate(2026, 11, 2), today: today),
      ),
      row(SubscriptionRowState.normal, name: 'Canva Pro', tone: CycleProgressTone.off, meta: 'Paused'),
      row(SubscriptionRowState.cancelled, name: 'Duolingo Super'),
    ],
  ),
);

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadAppFonts();
  });

  group('CycleProgress maths', () {
    test('later periods start at the previous Due date', () {
      final p = CycleProgress.of(
        cycle: const BillingCycle.monthly(),
        anchorDate: const LocalDate(2026, 1, 31),
        periodIndex: 2,
        startDate: const LocalDate(2026, 1, 31),
        today: const LocalDate(2026, 3, 10),
      );
      expect(p.from, const LocalDate(2026, 2, 28)); // anchored maths: Jan 31 → Feb 28 → Mar 31
      expect(p.due, const LocalDate(2026, 3, 31));
      expect(p.daysLeft, 21);
      expect(p.fraction, closeTo(10 / 31, 1e-9));
    });

    test('first period starts at startDate when it is inside the cycle', () {
      final p = CycleProgress.of(
        cycle: const BillingCycle.monthly(),
        anchorDate: const LocalDate(2026, 11, 20),
        periodIndex: 0,
        startDate: const LocalDate(2026, 11, 1),
        today: today,
      );
      expect(p.from, const LocalDate(2026, 11, 1));
      expect(p.fraction, closeTo(3 / 19, 1e-9));
    });

    test('first period after a re-anchor (start long ago) starts one cycle before the Due date', () {
      for (final (cycle, from) in [
        (const BillingCycle.monthly(), const LocalDate(2026, 10, 20)),
        (const BillingCycle.yearly(), const LocalDate(2025, 11, 20)),
        (const BillingCycle.weekly(), const LocalDate(2026, 11, 13)),
        (const BillingCycle(28, CycleUnit.day), const LocalDate(2026, 10, 23)),
      ]) {
        final p = CycleProgress.of(
          cycle: cycle,
          anchorDate: const LocalDate(2026, 11, 20),
          periodIndex: 0,
          startDate: const LocalDate(2024, 5, 1),
          today: today,
        );
        expect(p.from, from, reason: '$cycle');
      }
      // Start on/after the Due date makes no sense either → one cycle before.
      final p = CycleProgress.of(
        cycle: const BillingCycle.monthly(),
        anchorDate: const LocalDate(2026, 3, 31),
        periodIndex: 0,
        startDate: const LocalDate(2026, 4, 2),
        today: today,
      );
      expect(p.from, const LocalDate(2026, 2, 28));
    });

    test('fraction is clamped; past the Due date (awaiting) it is full', () {
      expect(
        const CycleProgress(from: LocalDate(2026, 11, 10), due: LocalDate(2026, 12, 10), today: today).fraction,
        0,
      );
      final late = const CycleProgress(from: LocalDate(2026, 10, 2), due: LocalDate(2026, 11, 2), today: today);
      expect(late.fraction, 1);
      expect(late.daysLeft, -2);
      expect(const CycleProgress(from: today, due: today, today: today).fraction, 1);
    });

    test('forSubscription uses the stored cycle fields', () {
      final s = Subscription(
        id: 's1',
        name: 'Netflix',
        priceMinor: 260000,
        currency: 'VND',
        cycle: const BillingCycle.monthly(),
        anchorDate: const LocalDate(2026, 8, 27),
        periodIndex: 3,
        startDate: const LocalDate(2026, 8, 27),
        createdAt: DateTime(2026, 8, 27),
        updatedAt: DateTime(2026, 8, 27),
      );
      expect(CycleProgress.forSubscription(s, today: today), active);
    });
  });

  group('SubscriptionRow', () {
    testWidgets('without progress / serviceId nothing changes', (tester) async {
      await pumpUi(
        tester,
        SubscriptionRow(name: 'Netflix', colorValue: 0xFFE50914, meta: 'Video', amount: '₫260,000', onTap: () {}),
      );
      expect(find.byType(CycleProgressBar), findsNothing);
      expect(tester.widget<ServiceTile>(find.byType(ServiceTile)).serviceId, isNull);
      expect(tester.getSize(find.byType(SubscriptionRow)).height, AppSize.rowH);
    });

    testWidgets('serviceId reaches the tile; logo drawn from the scope', (tester) async {
      await pumpUi(tester, allStates(), settle: false);
      await decode(tester);
      expect(tester.widget<ServiceTile>(find.byType(ServiceTile).first).serviceId, 'netflix');
      expect(find.byType(Image), findsNWidgets(5));
    });

    testWidgets('bar colour follows the state (token per state)', (tester) async {
      await pumpUi(tester, allStates());
      final c = AppColors.light;
      final rows = find.byType(SubscriptionRow);
      Finder at(int i) => find.descendant(of: rows.at(i), matching: find.byType(CycleProgressBar));
      expect(bar(tester, at(0)).fill, c.brand);
      expect(bar(tester, at(0)).track, c.surface2);
      expect(bar(tester, at(0)).value, closeTo(8 / 31, 1e-9));
      expect(bar(tester, at(1)).fill, c.inkMuted);
      expect(bar(tester, at(2)).fill, c.warning);
      expect(bar(tester, at(2)).track, c.warningSoft);
      expect(bar(tester, at(2)).value, 1);
      expect(bar(tester, at(3)).fill, c.lineStrong);
      expect(bar(tester, at(4)).fill, c.lineStrong);
    });

    for (final (locale, spoken, ago) in [('en', 'in 23 days', '2 days ago'), ('vi', 'còn 23 ngày', '2 ngày trước')]) {
      testWidgets('semantics reads the days left ($locale)', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpUi(tester, allStates(), locale: locale);
        final node = tester.getSemantics(find.byType(CycleProgressBar).first);
        expect(node.label, spoken);
        expect(node.value, '26%');
        expect(tester.getSemantics(find.byType(CycleProgressBar).at(2)).label, ago);
        handle.dispose();
      });
    }

    testWidgets('changes animate; with reduced motion they jump', (tester) async {
      for (final reduced in [false, true]) {
        var p = active;
        late StateSetter set;
        await pumpUi(
          tester,
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
              child: StatefulBuilder(
                builder: (context, s) {
                  set = s;
                  return row(SubscriptionRowState.normal, progress: p);
                },
              ),
            ),
          ),
        );
        set(() => p = CycleProgress(from: active.from, due: active.due, today: const LocalDate(2026, 11, 20)));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        final mid = bar(tester).value;
        if (reduced) {
          expect(mid, closeTo(24 / 31, 1e-9), reason: 'reduced motion → final value at once');
        } else {
          expect(mid, inExclusiveRange(8 / 31, 24 / 31));
        }
        await tester.pumpAndSettle();
        expect(bar(tester).value, closeTo(24 / 31, 1e-9));
      }
    });

    // EN/VI × light/dark × 320/360/390dp × 100/200%: no overflow, ≥ 48dp targets, bar full width.
    // Golden images only with --dart-define=SHOTS=true (fonts render per platform):
    //   flutter test test/core/widgets/cycle_progress_test.dart --dart-define=SHOTS=true --update-goldens
    //   → notes/img/2026-11-06-p3-progress/
    for (final locale in ['en', 'vi']) {
      for (final dark in [false, true]) {
        for (final width in [320.0, 360.0, 390.0]) {
          for (final scale in [1.0, 2.0]) {
            final id = '$locale-${dark ? 'dark' : 'light'}-${width.round()}-${(scale * 100).round()}';
            testWidgets('rows with bar: $id', (tester) async {
              await pumpUi(
                tester,
                RepaintBoundary(key: shot, child: allStates()),
                locale: locale,
                dark: dark,
                textScale: scale,
                size: Size(width, 1400),
                settle: false,
              );
              await decode(tester);
              expect(tester.takeException(), isNull);
              for (final b in find.byType(CycleProgressBar).evaluate()) {
                final box = b.renderObject! as RenderBox;
                expect(box.size.height, CycleProgressBar.height);
                expect(box.size.width, greaterThan(100));
              }
              for (final r in find.byType(SubscriptionRow).evaluate()) {
                expect((r.renderObject! as RenderBox).size.height, greaterThanOrEqualTo(AppSize.rowH));
              }
              await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
              if (const bool.fromEnvironment('SHOTS')) {
                // 1× images keep the notes folder small.
                tester.view.physicalSize = Size(width, 1400);
                tester.view.devicePixelRatio = 1;
                await tester.pump();
                await expectLater(
                  find.byKey(shot),
                  matchesGoldenFile('../../../notes/img/2026-11-06-p3-progress/rows-$id.png'),
                );
              }
            });
          }
        }
      }
    }
  });
}
