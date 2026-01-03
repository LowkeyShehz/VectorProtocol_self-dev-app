import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/reminder_model.dart';
import '../services/notification_service.dart';

part 'reminder_provider.g.dart';

@riverpod
class ReminderController extends _$ReminderController {
  @override
  FutureOr<List<Reminder>> build() {
    // Initial mock data
    return [
      Reminder(
        id: '1',
        intId: 1001,
        title: 'Team Sync Meeting',
        remindAt: DateTime.now().add(const Duration(hours: 2)),
        isActive: true,
      ),
      Reminder(
        id: '2',
        intId: 1002,
        title: 'Drink Water',
        remindAt: DateTime.now().add(const Duration(hours: 6)),
        isActive: true,
      ),
    ];
  }

  Future<void> addReminder(String title, DateTime remindAt) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));

      final newIntId = Random().nextInt(100000);
      final newItem = Reminder(
        id: DateTime.now().toIso8601String(),
        intId: newIntId,
        title: title,
        remindAt: remindAt,
        isActive: true,
      );

      final currentList = state.value ?? [];

      // Schedule Native Notification
      await NotificationService().scheduleNotification(
        newIntId,
        title,
        remindAt,
        newItem.id,
      );

      return [...currentList, newItem];
    });
  }

  Future<void> toggleReminder(String id) async {
    final currentList = state.value;
    if (currentList == null) return;

    state = await AsyncValue.guard(() async {
      final updatedList = <Reminder>[];
      for (var item in currentList) {
        if (item.id == id) {
          final newActive = !item.isActive;

          if (newActive) {
            // Reschedule if enabling and time is in future
            if (item.remindAt.isAfter(DateTime.now())) {
              await NotificationService().scheduleNotification(
                item.intId,
                item.title,
                item.remindAt,
                item.id,
              );
            }
          } else {
            // Cancel if disabling
            await NotificationService().cancelNotification(item.intId);
          }
          updatedList.add(item.copyWith(isActive: newActive));
        } else {
          updatedList.add(item);
        }
      }
      return updatedList;
    });
  }
}
