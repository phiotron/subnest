import 'package:flutter/rendering.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import '../features/home/ui_harness.dart';

/// Real phone QA (2026-11-05): converted amounts start with "≈", which TalkBack skipped — "$37.41"
/// instead of "approximately $37.41". No semantics label on these screens may still contain "≈".
void main() {
  List<String> labelsWithApprox(WidgetTester tester) {
    final out = <String>[];
    void visit(SemanticsNode n) {
      for (final s in [n.label, n.value, n.hint, n.tooltip]) {
        if (s.contains('≈')) out.add(s.replaceAll('\n', ' | '));
      }
      n.visitChildren((c) {
        visit(c);
        return true;
      });
    }

    visit(tester.binding.renderViews.first.owner!.semanticsOwner!.rootSemanticsNode!);
    return out;
  }

  // ChatGPT Plus is billed in USD while the main currency is VND, so totals and rows show "≈".
  const screens = [
    '/home',
    '/subscription/chatgpt',
    '/awaiting',
    '/calendar',
    '/insights',
    '/settings/rates',
  ];
  for (final locale in ['en', 'vi']) {
    for (final location in screens) {
      testWidgets('$locale $location: "≈" is spoken as a word', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpApp(tester, setup: Setup(locale: locale, height: 3200), location: location);
        expect(labelsWithApprox(tester), isEmpty);
        handle.dispose();
        await closeApp(tester);
      });
    }
  }

  testWidgets('confirm sheet conversion line is spoken', (tester) async {
    final handle = tester.ensureSemantics();
    final usd = Mock.netflix.copyWith(currency: 'USD', priceMinor: 2699);
    await pumpApp(
      tester,
      subscriptions: [for (final s in Mock.all) s.id == 'netflix' ? usd : s],
      push: '/confirm/netflix',
    );
    expect(labelsWithApprox(tester), isEmpty);
    handle.dispose();
    await closeApp(tester);
  });

  test('spoken() replaces the symbol in EN and VI', () {
    expect(lookupAppLocalizations(const Locale('en')).spoken('≈ ₫508,000/month'), 'approximately ₫508,000/month');
    expect(lookupAppLocalizations(const Locale('vi')).spoken('Tổng ≈ 1,07tr'), 'Tổng khoảng 1,07tr');
    expect(lookupAppLocalizations(const Locale('en')).spokenLabel(r'$20.00'), isNull);
  });
}
