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
  int totalJournalEntries = 0;
  int totalRemindersSet = 0;

  bool customNotificationEnabled = false;
  String customNotificationMessage = '';
  int customNotificationHour = 20;
  int customNotificationMinute = 0;
  String? customNotificationMediaPath;
  bool isCustomNotificationVideo = false;

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
    this.totalJournalEntries = 0,
    this.totalRemindersSet = 0,
    this.completedAchievements = const [],
    this.customNotificationEnabled = false,
    this.customNotificationMessage = "It's time to Level Up!",
    this.customNotificationHour = 20,
    this.customNotificationMinute = 0,
    this.customNotificationMediaPath,
    this.isCustomNotificationVideo = false,
  });
}
