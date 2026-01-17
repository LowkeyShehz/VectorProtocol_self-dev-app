import 'package:isar/isar.dart';

part 'habit_model.g.dart';

enum HabitType { good, bad }

enum HabitFrequency { daily, weekly, monthly }

enum HabitWeeklyType { specificDays, countPerWeek }

enum HabitCategory {
  health,
  productivity,
  social,
  spirit,
  finance,
  creativity,
  other
}

@collection
class Habit {
  Id id = Isar.autoIncrement;

  late String title;

  @Enumerated(EnumType.name)
  late HabitType type;

  @Enumerated(EnumType.name)
  late HabitFrequency frequency;

  @Enumerated(EnumType.name)
  HabitWeeklyType? weeklyType; // Null if not weekly

  late List<int> targetDays; // 0 = Mon, 6 = Sun

  late int weeklyCount; // For "countPerWeek" (e.g. 3 times a week)

  late int color; // Hex int

  @Enumerated(EnumType.name)
  late HabitCategory category;

  late List<DateTime> completedDates;

  late DateTime createdAt;

  Habit(); // Default constructor for Isar

  Habit.create({
    required this.title,
    required this.type,
    required this.frequency,
    this.weeklyType,
    required this.targetDays,
    this.weeklyCount = 0,
    required this.color,
    required this.category,
    this.completedDates = const [],
    required this.createdAt,
  });

  // Helper method for logic
  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  // CopyWith mainly for updating local state before saving,
  // though with Isar we usually just modify the object and put().
  Habit copyWith({
    String? title,
    HabitType? type,
    HabitFrequency? frequency,
    HabitWeeklyType? weeklyType,
    List<int>? targetDays,
    int? weeklyCount,
    int? color,
    HabitCategory? category,
    List<DateTime>? completedDates,
    DateTime? createdAt,
  }) {
    final habit = Habit()
      ..id = this.id
      ..title = title ?? this.title
      ..type = type ?? this.type
      ..frequency = frequency ?? this.frequency
      ..weeklyType = weeklyType ?? this.weeklyType
      ..targetDays = targetDays ?? this.targetDays
      ..weeklyCount = weeklyCount ?? this.weeklyCount
      ..color = color ?? this.color
      ..category = category ?? this.category
      ..completedDates = completedDates ?? this.completedDates
      ..createdAt = createdAt ?? this.createdAt;
    return habit;
  }
}
