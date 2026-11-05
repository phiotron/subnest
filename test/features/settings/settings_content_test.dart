import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/features/settings/app_info.dart';
import 'package:subnest/features/settings/legal_screen.dart';
import 'package:subnest/features/settings/legal_texts.dart';
import 'package:subnest/features/settings/licenses.dart';
import 'package:subnest/features/settings/settings_format.dart';

import 'settings_harness.dart';

String _read(String path) => _lf(File(path).readAsStringSync());

/// A Windows checkout (core.autocrlf) may give either file CRLF line ends.
String _lf(String s) => s.replaceAll('\r\n', '\n');

void main() {
  setUpAll(initializeDateFormatting);

  group('bundled texts stay in sync with their sources', () {
    test('privacy policy and terms = store/legal/*.md', () {
      expect(_lf(LegalTexts.privacyEn), _read('store/legal/privacy-policy.en.md'));
      expect(_lf(LegalTexts.privacyVi), _read('store/legal/privacy-policy.vi.md'));
      expect(_lf(LegalTexts.termsEn), _read('store/legal/terms.en.md'));
      expect(_lf(LegalTexts.termsVi), _read('store/legal/terms.vi.md'));
    });

    test('Be Vietnam Pro licence = assets/fonts/BeVietnamPro/OFL.txt', () {
      expect(_lf(AppLicenses.beVietnamProOfl), _read('assets/fonts/BeVietnamPro/OFL.txt'));
      expect(AppLicenses.lucideIsc, startsWith('ISC License'));
    });

    test('version shown in Settings = pubspec.yaml', () {
      final line = _read('pubspec.yaml').split('\n').firstWhere((l) => l.startsWith('version:'));
      expect(line.trim(), 'version: $kAppVersion+$kAppBuild');
    });

    test('privacy URL placeholder is explicit (S-13: in-app copy until it is set)', () {
      // When the public page exists, set kPrivacyPolicyUrl; the row then opens it externally
      // and falls back to the in-app copy offline.
      expect(kPrivacyPolicyUrl == null || kPrivacyPolicyUrl!.startsWith('https://'), isTrue);
      expect(kSupportEmail, 'phamphuongphuongnd@gmail.com');
    });
  });

  group('legal markdown', () {
    test('headings, wrapped paragraphs, bullets and numbered items', () {
      final blocks = LegalMarkdown.parse(
        '# Title\n\nOne line\nwrapped.\n\n## Part\n\n- **A** first\n  continued\n- B\n\n1. **X** one\n   more\n2. Y\n',
      );
      expect(blocks.map((b) => b.kind), [
        LegalBlockKind.title,
        LegalBlockKind.paragraph,
        LegalBlockKind.heading,
        LegalBlockKind.bullet,
        LegalBlockKind.bullet,
        LegalBlockKind.numbered,
        LegalBlockKind.numbered,
      ]);
      expect(blocks[1].text, 'One line wrapped.');
      expect(blocks[3].text, '**A** first continued');
      expect(blocks[5].number, '1');
      expect(blocks[5].text, '**X** one more');
    });

    test('every store document parses into readable blocks (no raw markdown left)', () {
      for (final doc in LegalDoc.values) {
        for (final lang in ['en', 'vi']) {
          final blocks = LegalMarkdown.parse(legalText(doc, lang));
          expect(blocks.first.kind, LegalBlockKind.title);
          for (final b in blocks) {
            expect(b.text, isNot(startsWith('#')));
            expect(b.text, isNot(startsWith('- ')));
          }
        }
      }
    });
  });

  group('formatting', () {
    final en = l10nFor('en');
    final vi = l10nFor('vi');
    final now = DateTime(2026, 11, 5, 10);

    test('time ago', () {
      expect(SettingsFormat.ago(en, now.subtract(const Duration(seconds: 20)), now), 'just now');
      expect(SettingsFormat.ago(en, now.subtract(const Duration(minutes: 5)), now), '5 min ago');
      expect(SettingsFormat.ago(en, now.subtract(const Duration(hours: 2)), now, short: true), '2 h ago');
      expect(SettingsFormat.ago(en, now.subtract(const Duration(hours: 1)), now), '1 hour ago');
      expect(SettingsFormat.ago(en, now.subtract(const Duration(days: 3)), now), '3 days ago');
      expect(SettingsFormat.ago(vi, now.subtract(const Duration(hours: 2)), now), '2 giờ trước');
    });

    test('backup nudge after 30 days', () {
      expect(SettingsFormat.backupOverdue(null, now), isTrue);
      expect(SettingsFormat.backupOverdue(DateTime(2026, 10, 6, 23), now), isFalse, reason: '30 days');
      expect(SettingsFormat.backupOverdue(DateTime(2026, 10, 5), now), isTrue, reason: '31 days');
      expect(SettingsFormat.backupFileName(DateTime(2026, 9, 23, 22)), 'subnest-backup-2026-09-23.json');
    });

    test('rates: display and parse by locale', () {
      expect(SettingsFormat.rate(25400, 'en'), '25,400');
      expect(SettingsFormat.rate(25400, 'vi'), '25.400');
      expect(SettingsFormat.rate(1.0846, 'en'), '1.0846');
      expect(SettingsFormat.rate(1 / 25400, 'en'), '0.0000394');
      expect(SettingsFormat.parseRate('25,400', 'en'), 25400);
      expect(SettingsFormat.parseRate('25.400', 'vi'), 25400);
      expect(SettingsFormat.parseRate('1,08', 'vi'), 1.08);
      expect(SettingsFormat.parseRate('1.08', 'en'), 1.08);
      expect(SettingsFormat.parseRate('0', 'en'), isNull);
      expect(SettingsFormat.parseRate('', 'en'), isNull);
    });
  });

  group('S12 notification texts match the mockup (png 58)', () {
    final en = l10nFor('en');
    final vi = l10nFor('vi');
    test('EN', () {
      expect(en.notificationsRenewalSoon('Netflix', 3, '₫260,000'), 'Netflix renews in 3 days — ₫260,000');
      expect(
        '${en.notificationsTrialEndingTitle('Spotify', 3)} ${en.notificationsTrialEndingBody}',
        'Your Spotify trial ends in 3 days. Cancel now if you don’t want to be charged.',
      );
      expect(en.notificationsDueToday('Netflix'), 'Netflix renews today — tap to confirm');
    });
    test('VI', () {
      expect(vi.notificationsRenewalSoon('Netflix', 3, '260.000đ'), 'Netflix gia hạn sau 3 ngày — 260.000đ');
      expect(
        '${vi.notificationsTrialEndingTitle('Spotify', 3)} ${vi.notificationsTrialEndingBody}',
        'Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí.',
      );
      expect(vi.notificationsDueToday('Netflix'), 'Hôm nay gia hạn Netflix — chạm để xác nhận');
    });
  });
}
