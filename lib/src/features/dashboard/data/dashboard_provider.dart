import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../habits/data/habit_provider.dart';
import '../../habits/domain/habit_model.dart';
import '../../profile/data/profile_provider.dart';
import '../../todo/data/todo_provider.dart';

enum DashboardTimeFilter { daily, weekly, monthly, yearly }

final dashboardTimeFilterProvider =
    StateProvider<DashboardTimeFilter>((ref) => DashboardTimeFilter.daily);

final dashboardRadarStatsProvider = FutureProvider<List<int>>((ref) async {
  final filter = ref.watch(dashboardTimeFilterProvider);
  final profile = await ref.watch(profileControllerProvider.future);
  final allHabits = await ref.watch(habitControllerProvider.future);
  final allTodos = await ref.watch(todoControllerProvider.future);

  if (profile.radarLabels.isEmpty) return [];

  final List<int> scores = [];
  final now = DateTime.now();
  late DateTime startDate;

  switch (filter) {
    case DashboardTimeFilter.daily:
      startDate = now;
      break;
    case DashboardTimeFilter.weekly:
      startDate = now.subtract(Duration(days: now.weekday - 1));
      break;
    case DashboardTimeFilter.monthly:
      startDate = DateTime(now.year, now.month, 1);
      break;
    case DashboardTimeFilter.yearly:
      startDate = DateTime(now.year, 1, 1);
      break;
  }

  // Normalize startDate to beginning of day
  startDate = DateTime(startDate.year, startDate.month, startDate.day);
  final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

  for (final attribute in profile.radarLabels) {
    int totalScheduled = 0;
    int totalCompleted = 0;

    // "Self Development" Logic: Performance of ALL habits + ALL task completions
    if (attribute == 'Self Development') {
      // 1. Calculate Habit performance (ALL habits)
      for (var day = startDate;
          day.isBefore(endDate) || day.isAtSameMomentAs(endDate);
          day = day.add(const Duration(days: 1))) {
        if (day.isAfter(now)) break;

        for (final h in allHabits) {
          bool isScheduled = false;
          if (h.frequency == HabitFrequency.daily) {
            isScheduled = true;
          } else if (h.frequency == HabitFrequency.weekly &&
              h.weeklyType == HabitWeeklyType.specificDays) {
            final dayIndex = day.weekday - 1;
            if (h.targetDays.contains(dayIndex)) {
              isScheduled = true;
            }
          }
          // TODO: Monthly

          if (isScheduled) {
            totalScheduled++;
            if (h.isCompletedOn(day)) {
              totalCompleted++;
            }
          }
        }
      }

      // 2. Calculate Task completions (Todos)
      // Filter todos that are due in the time range
      // For daily: due today. For weekly: due this week.
      for (final todo in allTodos) {
        // Normalize due date
        final due =
            DateTime(todo.dueDate.year, todo.dueDate.month, todo.dueDate.day);
        // Check if due is within range [startDate, MIN(endDate, now)]
        // Actually, task completions should probably count if they were COMPLETED in range,
        // but TodoItem doesn't store completedAt.
        // So we rely on DueDate. If it was due in this range, did we do it?

        if (due.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
            due.isBefore(endDate.add(const Duration(seconds: 1)))) {
          totalScheduled++;
          if (todo.isCompleted) {
            totalCompleted++;
          }
        }
      }
    } else {
      // Standard Logic (Linked Habits only)
      final relatedHabits =
          allHabits.where((h) => h.relatedAttribute == attribute).toList();

      if (relatedHabits.isNotEmpty) {
        for (var day = startDate;
            day.isBefore(endDate) || day.isAtSameMomentAs(endDate);
            day = day.add(const Duration(days: 1))) {
          if (day.isAfter(now)) break;

          for (final h in relatedHabits) {
            bool isScheduled = false;
            if (h.frequency == HabitFrequency.daily) {
              isScheduled = true;
            } else if (h.frequency == HabitFrequency.weekly &&
                h.weeklyType == HabitWeeklyType.specificDays) {
              final dayIndex = day.weekday - 1;
              if (h.targetDays.contains(dayIndex)) {
                isScheduled = true;
              }
            }

            if (isScheduled) {
              totalScheduled++;
              if (h.isCompletedOn(day)) {
                totalCompleted++;
              }
            }
          }
        }
      }
    }

    if (totalScheduled == 0) {
      scores.add(0);
    } else {
      scores
          .add(((totalCompleted / totalScheduled) * 100).round().clamp(0, 100));
    }
  }

  return scores;
});
