import 'package:flutter_test/flutter_test.dart';

import '../catalog/add_harness.dart';

/// Picks the five services of the mockup (png 05) on the "What do you pay for?" step.
Future<void> pickFive(WidgetTester tester) async {
  for (final name in ['Netflix', 'Spotify', 'YouTube Premium', 'ChatGPT', 'iCloud+']) {
    await tester.ensureVisible(find.bySemanticsLabel(name));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel(name));
    await settle(tester);
  }
}
