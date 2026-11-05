import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/core/theme/app_theme.dart';
import 'package:subnest/core/widgets/sheet_dialog.dart';

/// QA on a real phone (2026-11-05): closing the S4 date picker gave focus back to the price field, so the
/// keyboard popped up again and covered "Add subscription". Sheets and dialogs now drop text focus first.
void main() {
  Future<BuildContext> pumpField(WidgetTester tester, FocusNode node) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              ctx = context;
              return TextField(focusNode: node);
            },
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(node.hasFocus, isTrue);
    return ctx;
  }

  testWidgets('closing a sheet does not refocus the text field', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    final ctx = await pumpField(tester, node);

    final result = showAppSheet<int>(ctx, builder: (c) => TextButton(onPressed: () => Navigator.pop(c, 1), child: const Text('Done')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    expect(await result, 1);
    expect(node.hasFocus, isFalse);
  });

  testWidgets('closing a dialog does not refocus the text field', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    final ctx = await pumpField(tester, node);

    showAppDialog<void>(
      ctx,
      title: 'Title',
      actions: [Builder(builder: (c) => TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')))],
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(node.hasFocus, isFalse);
  });
}
