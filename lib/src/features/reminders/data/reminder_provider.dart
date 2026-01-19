import 'dart:async';
import 'package:isar/isar.dart';
import 'package:level_up/src/features/common/data/isar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/reminder_model.dart';
import '../services/notification_service.dart';

part 'reminder_provider.g.dart';

@riverpod
class ReminderController extends _$ReminderController {
  @override
  FutureOr<List<Reminder>> build() async {
    final isar = await ref.watch(isarDbProvider.future);
    final reminders = await isar.reminders.where().findAll();

    // Reschedule active reminders (CRITICAL for Linux persistence/restarts)
    final now = DateTime.now();
    for (final r in reminders) {
      if (r.isActive && r.remindAt.isAfter(now)) {
        await NotificationService().scheduleNotification(
          r.id,
          r.title,
          r.remindAt,
          r.id.toString(),
        );
      }
    }

    return reminders;
  }

  Future<void> addReminder(String title, DateTime remindAt,
      {String? imagePath}) async {
    final isar = await ref.watch(isarDbProvider.future);

    final reminder = Reminder.create(
      title: title,
      remindAt: remindAt,
      isActive: true,
      imagePath: imagePath,
    );

    // 1. Save to DB to generate ID
    await isar.writeTxn(() async {
      await isar.reminders.put(reminder);
    });

    // 2. Schedule Notification using the generated ID
    await NotificationService().scheduleNotification(
      reminder.id,
      title,
      remindAt,
      reminder.id.toString(),
    );

    ref.invalidateSelf();
  }

  Future<void> toggleReminder(int id) async {
    final isar = await ref.watch(isarDbProvider.future);

    // Convert logic to work with the fetched item
    // We fetch, modify, save, then schedule/cancel

    final item = await isar.reminders.get(id);
    if (item == null) return;

    final newActive = !item.isActive;

    await isar.writeTxn(() async {
      item.isActive = newActive;
      await isar.reminders.put(item);
    });

    // Handle signals outside transaction to avoid blocking DB (good practice)
    if (newActive) {
      if (item.remindAt.isAfter(DateTime.now())) {
        await NotificationService().scheduleNotification(
          item.id,
          item.title,
          item.remindAt,
          item.id.toString(),
        );
      }
    } else {
      await NotificationService().cancelNotification(item.id);
    }

    ref.invalidateSelf();
  }

  Future<void> editReminder(Reminder reminder) async {
    final isar = await ref.watch(isarDbProvider.future);

    await isar.writeTxn(() async {
      await isar.reminders.put(reminder);
    });

    // Reschedule or Cancel based on new state
    if (reminder.isActive && reminder.remindAt.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        reminder.id,
        reminder.title,
        reminder.remindAt,
        reminder.id.toString(),
      );
    } else {
      await NotificationService().cancelNotification(reminder.id);
    }

    ref.invalidateSelf();
  }

  Future<void> deleteReminder(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.reminders.delete(id);
    });
    // Ensure notification is cancelled
    await NotificationService().cancelNotification(id);
    ref.invalidateSelf();
  }
}
