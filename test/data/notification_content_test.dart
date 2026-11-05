import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/l10n/generated/app_localizations.dart';

/// Real phone (2026-11-05): reminders used the colour launcher icon as small icon (tinted into a
/// white blob), no accent colour, and the sentence as a bold title cut to one line. Design png 58:
/// "Subnest" + one regular sentence.
void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final vi = lookupAppLocalizations(const Locale('vi'));
  final now = DateTime(2026, 11, 4, 9);
  Subscription sub(String name, int price, {int shared = 1}) => Subscription(
    id: name,
    name: name,
    priceMinor: price,
    currency: 'VND',
    cycle: const BillingCycle.monthly(),
    anchorDate: const LocalDate(2026, 11, 4),
    startDate: const LocalDate(2026, 1, 4),
    createdAt: now,
    updatedAt: now,
    sharedWith: shared,
  );
  PlannedReminder reminder(ReminderKind kind, int days) => PlannedReminder(
    kind: kind,
    subscriptionId: 'x',
    fireAt: now,
    dueDate: const LocalDate(2026, 11, 4),
    daysBefore: days,
  );

  test('reminder sentence = product.md S12, trial ending is one sentence pair', () {
    final netflix = sub('Netflix', 260000);
    expect(
      NotificationService.reminderText(en, reminder(ReminderKind.dueToday, 0), netflix),
      'Netflix renews today — tap to confirm',
    );
    expect(
      NotificationService.reminderText(vi, reminder(ReminderKind.renewalSoon, 3), netflix),
      'Netflix gia hạn sau 3 ngày — 260.000đ',
    );
    expect(
      NotificationService.reminderText(en, reminder(ReminderKind.trialEnding, 3), sub('Spotify', 59000)),
      'Your Spotify trial ends in 3 days. Cancel now if you don’t want to be charged.',
    );
    expect(
      NotificationService.reminderText(vi, reminder(ReminderKind.trialEnding, 3), sub('Spotify', 59000)),
      'Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí.',
    );
  });

  test('Android: monochrome small icon, brand accent, big text, not colourised', () {
    final android = NotificationService.details(en, 'Netflix renews today — tap to confirm').android!;
    expect(android.icon, 'ic_stat_subnest');
    expect(android.color, const Color(0xFF0E6B63));
    expect(android.colorized, isFalse);
    final style = android.styleInformation;
    expect(style, isA<BigTextStyleInformation>());
    expect((style! as BigTextStyleInformation).bigText, 'Netflix renews today — tap to confirm');
    expect(android.channelId, 'reminders');
  });

  test('ic_stat_subnest exists for every density and is white-on-transparent', () async {
    const sizes = {'mdpi': 24, 'hdpi': 36, 'xhdpi': 48, 'xxhdpi': 72, 'xxxhdpi': 96};
    for (final e in sizes.entries) {
      final file = File('android/app/src/main/res/drawable-${e.key}/ic_stat_subnest.png');
      expect(file.existsSync(), isTrue, reason: e.key);
      final codec = await instantiateImageCodec(file.readAsBytesSync());
      final image = (await codec.getNextFrame()).image;
      expect([image.width, image.height], [e.value, e.value], reason: e.key);
      final bytes = (await image.toByteData(format: ImageByteFormat.rawStraightRgba))!;
      var opaque = 0;
      for (var i = 0; i < bytes.lengthInBytes; i += 4) {
        final a = bytes.getUint8(i + 3);
        if (a == 0) continue;
        opaque++;
        expect([bytes.getUint8(i), bytes.getUint8(i + 1), bytes.getUint8(i + 2)], [255, 255, 255], reason: '${e.key} pixel');
      }
      expect(opaque, greaterThan(e.value * e.value ~/ 5), reason: '${e.key} has a visible mark');
    }
    expect(File('android/app/src/main/res/raw/keep.xml').readAsStringSync(), contains('@drawable/ic_stat_subnest'));
  });
}
