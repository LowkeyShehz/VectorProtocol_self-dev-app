import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/habit_model.dart';

part 'habit_provider.g.dart';

@riverpod
class HabitController extends _$HabitController {
  @override
  FutureOr<List<Habit>> build() {
    // Initial mock data
    return [
      Habit(
        id: '1',
        title: 'Morning Meditation',
        type: HabitType.good,
        frequency: HabitFrequency.daily,
        targetDays: [],
        color: 0xFF00FF9D, // Neon Green
        category: HabitCategory.spirit,
        createdAt: DateTime.now(),
      ),
      Habit(
        id: '2',
        title: 'No Sugar',
        type: HabitType.good,
        frequency: HabitFrequency.daily,
        targetDays: [],
        color: 0xFF00FF9D,
        category: HabitCategory.health,
        createdAt: DateTime.now(),
      ),
    ];
  }

  Future<void> addHabit(Habit habit) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      final currentList = state.value ?? [];
      return [...currentList, habit];
    });
  }

  Future<void> toggleCompletion(String habitId, DateTime date) async {
    final currentList = state.value;
    if (currentList == null) return;

    state = await AsyncValue.guard(() async {
      return currentList.map((habit) {
        if (habit.id == habitId) {
          final isCompleted = habit.isCompletedOn(date);
          final newDates = List<DateTime>.from(habit.completedDates);
          if (isCompleted) {
            newDates.removeWhere((d) =>
                d.year == date.year &&
                d.month == date.month &&
                d.day == date.day);
          } else {
            newDates.add(date);
          }
          return habit.copyWith(completedDates: newDates);
        }
        return habit;
      }).toList();
    });
  }
}
