import 'dart:async';
import 'package:isar/isar.dart';
import 'package:level_up/src/features/common/data/isar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/habit_model.dart';
import '../../profile/data/profile_provider.dart';

part 'habit_provider.g.dart';

@riverpod
class HabitController extends _$HabitController {
  @override
  FutureOr<List<Habit>> build() async {
    final isar = await ref.watch(isarDbProvider.future);
    return isar.habits.where().findAll();
  }

  Future<void> addHabit(Habit habit) async {
    final isar = await ref.watch(isarDbProvider.future);

    // Auto-check bad habits on creation
    if (habit.type == HabitType.bad) {
      if (!habit.completedDates.any((d) =>
          d.year == DateTime.now().year &&
          d.month == DateTime.now().month &&
          d.day == DateTime.now().day)) {
        habit.completedDates = [...habit.completedDates, DateTime.now()];
      }
    }

    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
    ref.invalidateSelf();
    if (habit.relatedAttribute != null) {
      await _updateRadarScore(habit.relatedAttribute!);
    }
  }

  Future<void> toggleCompletion(int habitId, DateTime date) async {
    final isar = await ref.watch(isarDbProvider.future);
    String? linkedAttribute;
    bool wasCompleted = false;

    await isar.writeTxn(() async {
      final habit = await isar.habits.get(habitId);
      if (habit != null) {
        linkedAttribute = habit.relatedAttribute;
        wasCompleted = habit.isCompletedOn(date);

        final newDates = List<DateTime>.from(habit.completedDates);

        if (wasCompleted) {
          newDates.removeWhere((d) =>
              d.year == date.year &&
              d.month == date.month &&
              d.day == date.day);
        } else {
          newDates.add(date);
        }

        habit.completedDates = newDates;
        await isar.habits.put(habit);
      }
    });
    ref.invalidateSelf();

    if (linkedAttribute != null) {
      await _updateRadarScore(linkedAttribute!);
    }
  }

  Future<void> editHabit(Habit habit) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
    ref.invalidateSelf();
    if (habit.relatedAttribute != null) {
      await _updateRadarScore(habit.relatedAttribute!);
    }
  }

  Future<void> deleteHabit(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    String? attribute;
    final habit = await isar.habits.get(id);
    if (habit != null) attribute = habit.relatedAttribute;

    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    ref.invalidateSelf();

    if (attribute != null) {
      await _updateRadarScore(attribute);
    }
  }

  Future<void> _updateRadarScore(String attribute) async {
    final isar = await ref.read(isarDbProvider.future);
    final today = DateTime.now();

    // Fetch all habits linked to this attribute
    final habits =
        await isar.habits.filter().relatedAttributeEqualTo(attribute).findAll();

    int totalScheduled = 0;
    int totalCompleted = 0;

    for (final h in habits) {
      // Check if scheduled for today
      bool isScheduled = false;
      if (h.frequency == HabitFrequency.daily) {
        isScheduled = true;
      } else if (h.frequency == HabitFrequency.weekly &&
          h.weeklyType == HabitWeeklyType.specificDays) {
        // 0 = Mon, 6 = Sun. DateTime.weekday is 1-7.
        final todayIndex = today.weekday - 1;
        if (h.targetDays.contains(todayIndex)) {
          isScheduled = true;
        }
      }

      if (isScheduled) {
        totalScheduled++;
        if (h.isCompletedOn(today)) {
          totalCompleted++;
        }
      }
    }

    // Calculate Score
    int newScore = 0;
    if (totalScheduled > 0) {
      double percentage = (totalCompleted / totalScheduled) * 100;
      newScore = percentage.round();
    } else {
      newScore = 0;
    }

    final profileController = ref.read(profileControllerProvider.notifier);
    final currentProfile = ref.read(profileControllerProvider).value;

    if (currentProfile != null) {
      final index = currentProfile.radarLabels.indexOf(attribute);
      if (index != -1) {
        await profileController.updateRadarChart(index, attribute, newScore);
      }
    }
  }
}
