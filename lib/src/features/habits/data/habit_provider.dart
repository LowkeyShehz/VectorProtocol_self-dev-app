import 'dart:async';
import 'package:isar/isar.dart';
import 'package:level_up/src/features/common/data/isar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/habit_model.dart';

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
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
    ref.invalidateSelf();
  }

  Future<void> toggleCompletion(int habitId, DateTime date) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      final habit = await isar.habits.get(habitId);
      if (habit != null) {
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

        habit.completedDates = newDates;
        await isar.habits.put(habit);
      }
    });
    ref.invalidateSelf();
  }

  Future<void> editHabit(Habit habit) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.habits.put(habit);
    });
    ref.invalidateSelf();
  }

  Future<void> deleteHabit(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    ref.invalidateSelf();
  }
}
