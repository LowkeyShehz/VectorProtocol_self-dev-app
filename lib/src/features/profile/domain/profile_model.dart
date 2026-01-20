import 'package:isar/isar.dart';

part 'profile_model.g.dart';

@collection
class Profile {
  Id id = Isar.autoIncrement;

  late String username;

  late bool isDarkMode;

  late List<String> radarLabels;

  late List<int> radarValues;

  bool dailyQuotesEnabled = true;

  // Storing hour/minute for daily quotes
  int motivationHour = 6;
  int motivationMinute = 0;

  int xp = 0;
  int level = 1;

  int appStreak = 0;
  DateTime? lastAppOpenDate;

  int totalHabitsCompleted = 0;
  int totalTodosCompleted = 0;

  List<String> completedAchievements = [];

  Profile();

  Profile.create({
    this.username = 'User',
    this.isDarkMode = true,
    required this.radarLabels,
    required this.radarValues,
    this.dailyQuotesEnabled = true,
    this.motivationHour = 6,
    this.motivationMinute = 0,
    this.xp = 0,
    this.level = 1,
    this.appStreak = 0,
    this.lastAppOpenDate,
    this.totalHabitsCompleted = 0,
    this.totalTodosCompleted = 0,
    this.completedAchievements = const [],
  });
}
