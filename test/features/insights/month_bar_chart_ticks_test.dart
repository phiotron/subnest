import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/core/theme/app_theme.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/insights/widgets/month_bar_chart.dart';
import 'package:subnest/l10n/generated/app_localizations.dart';

/// QA on a real phone (2026-11-05): the right-aligned tick label ("500k") sat under the tall current-month
/// bar and only its "k" was visible. Tick labels are now painted after the bars, on a card-coloured chip.
void main() {
  testWidgets('tick labels are painted after the bars, on a surface chip', (tester) async {
    final theme = AppTheme.light();
    final series = [
      for (var m = 1; m <= 12; m++) MonthSpending(LocalDate(2026, m, 1), m == 12 ? 100000 : 300000, m == 12 ? 900000 : 0),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        locale: const Locale('vi'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: MonthBarChart(series: series, current: LocalDate(2026, 12, 1), currency: 'VND'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final colors = theme.extension<AppColors>()!;
    final chart = find.descendant(of: find.byType(MonthBarChart), matching: find.byType(CustomPaint)).first;
    // Record the draw calls, then check: after the baseline (drawn after every bar) come the tick chips
    // (surface-coloured rrects) and their labels.
    final calls = <(Symbol, int?)>[];
    expect(
      chart,
      paints
        ..everything((m, args) {
          calls.add((m, args.whereType<Paint>().firstOrNull?.color.toARGB32()));
          return true;
        }),
    );
    final baseline = calls.lastIndexWhere((c) => c.$1 == #drawLine && c.$2 == colors.lineStrong.toARGB32());
    final lastBar = calls.lastIndexWhere((c) => c.$1 == #drawRRect && c.$2 == colors.brand.toARGB32());
    final chips = [for (var i = 0; i < calls.length; i++) if (calls[i].$1 == #drawRRect && calls[i].$2 == colors.surface.toARGB32()) i];
    expect(baseline, greaterThan(lastBar));
    expect(chips, isNotEmpty);
    expect(chips.first, greaterThan(baseline));
    expect(calls.sublist(chips.first).where((c) => c.$1 == #drawParagraph), hasLength(chips.length));
  });
}
