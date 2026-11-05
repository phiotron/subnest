import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// QA on a real phone (2026-11-05): `Semantics(button: true, excludeSemantics: true, child: InkWell(onTap: …))`
/// drops the InkWell's tap action, so the node is "Button" but not clickable for TalkBack / Switch Access
/// (uiautomator showed clickable=false on the onboarding service tiles). Any Semantics that excludes its
/// children while wrapping a tap handler must forward the handler with `onTap:` itself.
void main() {
  test('Semantics(excludeSemantics: true) around a tap handler forwards onTap', () {
    final offenders = <String>[];
    final files = Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
    for (final file in files) {
      if (file.path.contains('generated')) continue;
      final src = file.readAsStringSync();
      for (final m in RegExp(r'\bSemantics\(').allMatches(src)) {
        final rest = src.substring(m.end, (m.end + 1500).clamp(0, src.length));
        final childAt = rest.indexOf('child:');
        if (childAt < 0) continue;
        final head = rest.substring(0, childAt);
        if (!head.contains('excludeSemantics: true') || head.contains('onTap')) continue;
        final body = rest.substring(childAt, (childAt + 700).clamp(0, rest.length));
        final wrapsTap = RegExp(r'on(Tap|Pressed|LongPress|Changed)\s*:').hasMatch(body);
        if (head.contains('button: true') || wrapsTap) {
          final line = '\n'.allMatches(src.substring(0, m.start)).length + 1;
          offenders.add('${file.path}:$line');
        }
      }
    }
    expect(offenders, isEmpty, reason: 'Semantics hides the child tap action — add onTap: to the Semantics');
  });
}
