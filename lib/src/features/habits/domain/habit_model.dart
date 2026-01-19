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

  String? relatedAttribute; // For Radar Chart Integration

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

  bool isScheduledOn(DateTime date) {
    if (frequency == HabitFrequency.daily) return true;
    if (frequency == HabitFrequency.weekly &&
        weeklyType == HabitWeeklyType.specificDays) {
      // weekday is 1(Mon)..7(Sun). targetDays is 0(Mon)..6(Sun)
      return targetDays.contains(date.weekday - 1);
    }
    // Fallback for others (like countPerWeek), treat as scheduled to be safe or maybe false?
    // If countPerWeek, we can't easily determine "scheduled" specific days.
    // Let's assume daily for streak purposes to encourage consistency, or just return true.
    return true;
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;

    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => b.compareTo(a)); // Newest first

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastCompleted =
        DateTime(sorted.first.year, sorted.first.month, sorted.first.day);

    // 1. Check if streak is broken between Today and Last Completed
    // Iterate from Today down to LastCompleted (exclusive)
    for (var d = today;
        d.isAfter(lastCompleted);
        d = d.subtract(const Duration(days: 1))) {
      // If day is strictly between today and last completed (exclusive of both? no, inclusive of today check)
      // If I haven't done it today, but I was scheduled, is streak broken?
      // Usually: "Current Streak" allows "Today" to be pending.
      // So we only check strict past days.

      if (d.year == today.year && d.month == today.month && d.day == today.day)
        continue; // Allow today to be pending

      if (isScheduledOn(d)) {
        return 0; // Missed a scheduled day in the past
      }
    }

    // 2. Calculate streak backwards from lastCompleted
    int streak = 0;
    // Map for fast lookup
    final completedSet =
        sorted.map((d) => DateTime(d.year, d.month, d.day)).toSet();

    // Start counting from the last completed date
    // We know lastCompleted exists in set.

    // Wait, if today is completed, lastCompleted == today.
    // If today is NOT completed, lastCompleted is in past.
    // We established valid continuity above.

    var d = lastCompleted;
    while (true) {
      if (completedSet.contains(d)) {
        streak++;
      } else if (isScheduledOn(d)) {
        // Scheduled but not completed -> End of streak
        break;
      } else {
        // Not scheduled (rest day) -> Continue maintain streak
      }

      d = d.subtract(const Duration(days: 1));
      if (d.isBefore(createdAt.subtract(const Duration(days: 1)))) break;
    }

    return streak;
  }

  int get bestStreak {
    if (completedDates.isEmpty) return 0;

    final sorted = List<DateTime>.from(completedDates)
      ..sort((a, b) => a.compareTo(b)); // Oldest first

    final completedSet =
        sorted.map((d) => DateTime(d.year, d.month, d.day)).toSet();

    int maxStreak = 0;
    int currentRun = 0;

    if (sorted.isEmpty) return 0;

    // Range: First completed to Last completed
    final start =
        DateTime(sorted.first.year, sorted.first.month, sorted.first.day);
    final end = DateTime(sorted.last.year, sorted.last.month, sorted.last.day);

    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      if (completedSet.contains(d)) {
        currentRun++;
      } else if (isScheduledOn(d)) {
        // Break
        if (currentRun > maxStreak) maxStreak = currentRun;
        currentRun = 0;
      }
      // Else (Rest day), continue currentRun
    }
    if (currentRun > maxStreak) maxStreak = currentRun;

    return maxStreak;
  }
}
