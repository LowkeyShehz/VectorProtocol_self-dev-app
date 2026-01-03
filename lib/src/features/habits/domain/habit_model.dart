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

class Habit {
  final String id;
  final String title;
  final HabitType type;
  final HabitFrequency frequency;
  final HabitWeeklyType? weeklyType; // Null if not weekly
  final List<int> targetDays; // 0 = Mon, 6 = Sun
  final int weeklyCount; // For "countPerWeek" (e.g. 3 times a week)
  final int color; // Hex int
  final HabitCategory category;
  final List<DateTime> completedDates;
  final DateTime createdAt;

  const Habit({
    required this.id,
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

  bool isCompletedOn(DateTime date) {
    return completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  Habit copyWith({
    String? id,
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
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      weeklyType: weeklyType ?? this.weeklyType,
      targetDays: targetDays ?? this.targetDays,
      weeklyCount: weeklyCount ?? this.weeklyCount,
      color: color ?? this.color,
      category: category ?? this.category,
      completedDates: completedDates ?? this.completedDates,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
