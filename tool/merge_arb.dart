// Merges per-feature ARB parts into the ARB files that `flutter gen-l10n` reads.
//
//   lib/l10n/parts/<part>_en.arb + <part>_vi.arb   (edited by feature sessions)
//        ↓  dart run tool/merge_arb.dart
//   lib/l10n/app_en.arb + app_vi.arb                (GENERATED — do not edit)
//        ↓  flutter gen-l10n   (also runs automatically on flutter run/build)
//   lib/l10n/generated/app_localizations*.dart
//
// Rules enforced (exit code 1 on violation):
//   * every key in `<part>_*.arb` starts with the camelCase part name
//     (subscription_form → `subscriptionForm…`) so two sessions never collide;
//   * no duplicate keys across parts;
//   * every locale has exactly the same message keys as English;
//   * metadata (`@key`) lives in the English file only.
//
// Usage:
//   dart run tool/merge_arb.dart          write merged files
//   dart run tool/merge_arb.dart --check  verify merged files are up to date (for CI)
import 'dart:convert';
import 'dart:io';

const partsDir = 'lib/l10n/parts';
const outDir = 'lib/l10n';
const templateLocale = 'en';
const locales = ['en', 'vi'];

void main(List<String> args) {
  final check = args.contains('--check');
  final errors = <String>[];
  final dir = Directory(partsDir);
  if (!dir.existsSync()) {
    stderr.writeln('Missing $partsDir');
    exit(1);
  }

  // part name → locale → content
  final parts = <String, Map<String, Map<String, Object?>>>{};
  final fileRe = RegExp(r'^([a-z0-9_]+)_([a-z]{2})\.arb$');
  final files = dir.listSync().whereType<File>().toList()..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final name = f.uri.pathSegments.last;
    final m = fileRe.firstMatch(name);
    if (m == null) {
      errors.add('$name: file name must be <part>_<locale>.arb');
      continue;
    }
    final locale = m.group(2)!;
    if (!locales.contains(locale)) {
      errors.add('$name: unsupported locale "$locale" (supported: ${locales.join(', ')})');
      continue;
    }
    try {
      final json = jsonDecode(f.readAsStringSync()) as Map<String, Object?>;
      parts.putIfAbsent(m.group(1)!, () => {})[locale] = json;
    } on FormatException catch (e) {
      errors.add('$name: invalid JSON (${e.message})');
    }
  }

  final merged = {for (final l in locales) l: <String, Object?>{'@@locale': l}};
  final owner = <String, String>{}; // key → part

  final partNames = parts.keys.toList()..sort((a, b) => a == 'common' ? -1 : (b == 'common' ? 1 : a.compareTo(b)));
  for (final part in partNames) {
    final prefix = _camel(part);
    final byLocale = parts[part]!;
    final en = byLocale[templateLocale];
    if (en == null) {
      errors.add('${part}_$templateLocale.arb is missing');
      continue;
    }
    final enKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
    for (final locale in locales) {
      final content = byLocale[locale];
      if (content == null) {
        errors.add('${part}_$locale.arb is missing');
        continue;
      }
      for (final entry in content.entries) {
        final key = entry.key;
        if (key == '@@locale') continue;
        final base = key.startsWith('@') ? key.substring(1) : key;
        if (!base.startsWith(prefix)) {
          errors.add('${part}_$locale.arb: key "$base" must start with "$prefix"');
        }
        if (key.startsWith('@') && locale != templateLocale) {
          errors.add('${part}_$locale.arb: metadata "$key" belongs in ${part}_$templateLocale.arb only');
          continue;
        }
        if (!key.startsWith('@') && locale == templateLocale) {
          final prev = owner[key];
          if (prev != null && prev != part) errors.add('Duplicate key "$key" in parts "$prev" and "$part"');
          owner[key] = part;
        }
        merged[locale]![key] = entry.value;
      }
      if (locale != templateLocale) {
        final keys = content.keys.where((k) => !k.startsWith('@')).toSet();
        for (final k in enKeys.difference(keys)) {
          errors.add('${part}_$locale.arb: missing translation "$k"');
        }
        for (final k in keys.difference(enKeys)) {
          errors.add('${part}_$locale.arb: "$k" not in ${part}_$templateLocale.arb');
        }
      }
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('merge_arb: ${errors.length} problem(s):');
    for (final e in errors) {
      stderr.writeln('  - $e');
    }
    exit(1);
  }

  const encoder = JsonEncoder.withIndent('  ');
  var stale = false;
  for (final locale in locales) {
    final file = File('$outDir/app_$locale.arb');
    final text = '${encoder.convert(merged[locale])}\n';
    if (check) {
      if (!file.existsSync() || file.readAsStringSync().replaceAll('\r\n', '\n') != text) {
        stderr.writeln('${file.path} is out of date — run: dart run tool/merge_arb.dart');
        stale = true;
      }
    } else {
      file.writeAsStringSync(text);
      stdout.writeln('wrote ${file.path} (${merged[locale]!.keys.where((k) => !k.startsWith('@')).length} messages)');
    }
  }
  if (stale) exit(1);
}

String _camel(String snake) {
  final p = snake.split('_');
  return p.first + p.skip(1).map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join();
}
