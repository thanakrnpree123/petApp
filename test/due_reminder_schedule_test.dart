import 'package:flutter_test/flutter_test.dart';
import 'package:pawhealth/services/notification_service.dart';

void main() {
  final schedule = NotificationService.dueReminderSchedule;

  group('dueReminderSchedule', () {
    test('reminds at 9:00 AM the day before — not at midnight', () {
      // Date pickers return local midnight.
      final result = schedule(
        DateTime(2026, 9, 20),
        now: DateTime(2026, 9, 10, 14),
      );
      expect(result?.at, DateTime(2026, 9, 19, 9));
      expect(result?.dueToday, isFalse);
    });

    test('ignores the time of day on the due date', () {
      final result = schedule(
        DateTime(2026, 9, 20, 15, 30),
        now: DateTime(2026, 9, 10),
      );
      expect(result?.at, DateTime(2026, 9, 19, 9));
    });

    test('rolls back across a month boundary', () {
      final result = schedule(DateTime(2026, 10, 1), now: DateTime(2026, 9, 1));
      expect(result?.at, DateTime(2026, 9, 30, 9));
    });

    test('added late the day before: reminds on the due morning', () {
      final result = schedule(
        DateTime(2026, 9, 20),
        now: DateTime(2026, 9, 19, 21),
      );
      expect(result?.at, DateTime(2026, 9, 20, 9));
      expect(result?.dueToday, isTrue);
    });

    test('no reminder once the due morning has passed', () {
      expect(
        schedule(DateTime(2026, 9, 20), now: DateTime(2026, 9, 20, 10)),
        isNull,
      );
      expect(
        schedule(DateTime(2026, 9, 1), now: DateTime(2026, 9, 10)),
        isNull,
      );
    });
  });
}
