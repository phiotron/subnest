import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/domain/domain.dart';

void main() {
  test('notification ids are stable, distinct per kind, positive 32-bit', () {
    final a = NotificationService.notificationId('1e1d93a4-7af9-4c26-a299-465aeafa6ea3', ReminderKind.dueToday);
    expect(NotificationService.notificationId('1e1d93a4-7af9-4c26-a299-465aeafa6ea3', ReminderKind.dueToday), a);
    final ids = {
      for (final k in ReminderKind.values) NotificationService.notificationId('netflix', k),
    };
    expect(ids, hasLength(ReminderKind.values.length));
    for (var i = 0; i < 1000; i++) {
      final id = NotificationService.notificationId('sub-$i', ReminderKind.renewalSoon);
      expect(id, inInclusiveRange(1, 0x7FFFFFFF));
    }
  });
}
