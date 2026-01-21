import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../common/data/isar_service.dart';
import '../domain/profile_model.dart';
import '../domain/achievement_definitions.dart';

import '../../reminders/services/notification_service.dart';
import '../../habits/data/habit_provider.dart';
import '../../todo/data/todo_provider.dart';
import '../../reminders/data/reminder_provider.dart';
import '../../dashboard/data/dashboard_provider.dart';

part 'profile_provider.g.dart';

const _motivationalQuotes = [
  "The only way to do great work is to love what you do.",
  "Believe you can and you're halfway there.",
  "Your time is limited, don't waste it living someone else's life.",
  "Don't watch the clock; do what it does. Keep going.",
  "The future belongs to those who believe in the beauty of their dreams.",
  "Success is not final, failure is not fatal: It is the courage to continue that counts.",
  "What lies behind us and what lies before us are tiny matters compared to what lies within us.",
  "The only limit to our realization of tomorrow will be our doubts of today.",
  "Act as if what you do makes a difference. It does.",
  "Success usually comes to those who are too busy to be looking for it.",
  "Don't be afraid to give up the good to go for the great.",
  "I find that the harder I work, the more luck I seem to have.",
  "Success is walking from failure to failure with no loss of enthusiasm.",
  "Opportunities don't happen. You create them.",
  "Try not to become a man of success. Rather become a man of value.",
  "Stop chasing the money and start chasing the passion.",
  "All progress takes place outside the comfort zone.",
  "The ones who are crazy enough to think they can change the world, are the ones who do.",
  "Don't let yesterday take up too much of today.",
  "You are never too old to set another goal or to dream a new dream."
];

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<Profile> build() async {
    final isar = await ref.watch(isarDbProvider.future);
    final profile = await isar.profiles.get(1); // Assuming single user ID 1

    if (profile == null) {
      // Initialize default profile
      final newProfile = Profile.create(
        username: 'Level Up User',
        isDarkMode: true,
        radarLabels: [
          'Self Development',
          'Health',
          'Intellect',
          'Social',
          'Spirit',
          'Finance',
        ],
        radarValues: [50, 80, 60, 70, 90, 50],
        dailyQuotesEnabled: true,
      );

      // Force ID 1
      newProfile.id = 1;

      await isar.writeTxn(() async {
        await isar.profiles.put(newProfile);
      });

      // Schedule default quotes
      await NotificationService().scheduleDailyQuotes(_motivationalQuotes);

      return newProfile;
    }

    // Ensure 'Self Development' exists for existing users
    if (!profile.radarLabels.contains('Self Development')) {
      final newLabels = List<String>.from(profile.radarLabels);
      final newValues = List<int>.from(profile.radarValues);

      // Insert at the beginning
      newLabels.insert(0, 'Self Development');
      newValues.insert(0, 50); // Default start value

      profile.radarLabels = newLabels;
      profile.radarValues = newValues;

      await isar.writeTxn(() async {
        await isar.profiles.put(profile);
      });
    }

    // Reschedule on startup if enabled to ensure continuity
    if (profile.dailyQuotesEnabled) {
      await NotificationService().scheduleDailyQuotes(
        _motivationalQuotes,
        hour: profile.motivationHour,
        minute: profile.motivationMinute,
      );
    }

    // Streak Logic
    final now = DateTime.now();
    bool needsSave = false;

    if (profile.lastAppOpenDate == null) {
      // First open
      profile.lastAppOpenDate = now;
      profile.appStreak = 1;
      needsSave = true;
    } else {
      final lastDate = profile.lastAppOpenDate!;
      if (lastDate.year == now.year &&
          lastDate.month == now.month &&
          lastDate.day == now.day) {
        // Same day, do nothing
      } else {
        // Different day
        final yesterday = now.subtract(const Duration(days: 1));
        if (lastDate.year == yesterday.year &&
            lastDate.month == yesterday.month &&
            lastDate.day == yesterday.day) {
          // It was yesterday -> increment
          profile.appStreak += 1;
        } else {
          // Missed a day -> reset
          profile.appStreak = 1;
        }
        profile.lastAppOpenDate = now;
        needsSave = true;
      }
    }

    // Check Streak Achievements
    List<String> completedIds = List.from(profile.completedAchievements);
    bool achievementAdded = false;

    for (final achievement in allAchievements) {
      if (achievement.id.startsWith('streak_') &&
          !completedIds.contains(achievement.id)) {
        final parts = achievement.id.split('_');
        if (parts.length == 2) {
          final target = int.tryParse(parts[1]) ?? 0;
          if (target > 0 && profile.appStreak >= target) {
            completedIds.add(achievement.id);
            profile.xp += achievement.xpReward;
            achievementAdded = true;
          }
        }
      }
    }

    if (achievementAdded) {
      profile.completedAchievements = completedIds;
      // Recalculate levels
      int xp = profile.xp;
      int level = profile.level;
      int threshold = 150 + (level * 20);
      while (xp >= threshold) {
        xp -= threshold;
        level++;
        threshold = 150 + (level * 20);
      }
      profile.xp = xp;
      profile.level = level;
      needsSave = true;
    }

    // Sanitize Bad Data (e.g. Negative Level)
    if (profile.level < 1) {
      profile.level = 1;
      profile.xp = 0;
      needsSave = true;
    }
    if (profile.xp < 0) {
      profile.xp = 0;
      needsSave = true;
    }

    if (needsSave) {
      await isar.writeTxn(() async {
        await isar.profiles.put(profile);
      });
    }

    return profile;
  }

  Future<void> updateProfile({
    String? username,
    bool? isDarkMode,
    List<String>? radarLabels,
    List<int>? radarValues,
    bool? dailyQuotesEnabled,
    int? motivationHour,
    int? motivationMinute,
    int? xp,
    int? level,
    int? totalHabitsCompleted,
    int? totalTodosCompleted,
    int? totalJournalEntries,
    int? totalRemindersSet,
    List<String>? completedAchievements,
    bool? customNotificationEnabled,
    String? customNotificationMessage,
    int? customNotificationHour,
    int? customNotificationMinute,
    String? customNotificationMediaPath,
    bool? isCustomNotificationVideo,
  }) async {
    final isar = await ref.watch(isarDbProvider.future);
    final currentProfile = state.value;

    if (currentProfile == null) return;

    final updatedProfile = Profile()
      ..id = currentProfile.id
      ..username = username ?? currentProfile.username
      ..isDarkMode = isDarkMode ?? currentProfile.isDarkMode
      ..radarLabels = radarLabels ?? currentProfile.radarLabels
      ..radarValues = radarValues ?? currentProfile.radarValues
      ..dailyQuotesEnabled =
          dailyQuotesEnabled ?? currentProfile.dailyQuotesEnabled
      ..motivationHour = motivationHour ?? currentProfile.motivationHour
      ..motivationMinute = motivationMinute ?? currentProfile.motivationMinute
      ..xp = xp ?? currentProfile.xp
      ..level = level ?? currentProfile.level
      ..appStreak = currentProfile.appStreak
      ..lastAppOpenDate = currentProfile.lastAppOpenDate
      ..totalHabitsCompleted =
          totalHabitsCompleted ?? currentProfile.totalHabitsCompleted
      ..totalTodosCompleted =
          totalTodosCompleted ?? currentProfile.totalTodosCompleted
      ..totalJournalEntries =
          totalJournalEntries ?? currentProfile.totalJournalEntries
      ..totalRemindersSet =
          totalRemindersSet ?? currentProfile.totalRemindersSet
      ..completedAchievements =
          completedAchievements ?? currentProfile.completedAchievements
      ..customNotificationEnabled =
          customNotificationEnabled ?? currentProfile.customNotificationEnabled
      ..customNotificationMessage =
          customNotificationMessage ?? currentProfile.customNotificationMessage
      ..customNotificationHour =
          customNotificationHour ?? currentProfile.customNotificationHour
      ..customNotificationMinute =
          customNotificationMinute ?? currentProfile.customNotificationMinute
      ..customNotificationMediaPath = customNotificationMediaPath ??
          currentProfile.customNotificationMediaPath
      ..isCustomNotificationVideo =
          isCustomNotificationVideo ?? currentProfile.isCustomNotificationVideo;

    await isar.writeTxn(() async {
      await isar.profiles.put(updatedProfile);
    });

    state = AsyncValue.data(updatedProfile);

    // DAILY QUOTES LOGIC
    final quotesEnabled =
        dailyQuotesEnabled ?? currentProfile.dailyQuotesEnabled;
    final timeChanged = (motivationHour != null &&
            motivationHour != currentProfile.motivationHour) ||
        (motivationMinute != null &&
            motivationMinute != currentProfile.motivationMinute);

    if (quotesEnabled && (dailyQuotesEnabled == true || timeChanged)) {
      await NotificationService().scheduleDailyQuotes(
        _motivationalQuotes,
        hour: updatedProfile.motivationHour,
        minute: updatedProfile.motivationMinute,
      );
    } else if (dailyQuotesEnabled == false) {
      await NotificationService().cancelDailyQuotes();
    }

    // CUSTOM NOTIFICATION LOGIC
    final customEnabled =
        customNotificationEnabled ?? currentProfile.customNotificationEnabled;
    final customTimeChanged = (customNotificationHour != null &&
            customNotificationHour != currentProfile.customNotificationHour) ||
        (customNotificationMinute != null &&
            customNotificationMinute !=
                currentProfile.customNotificationMinute);
    final contentChanged = (customNotificationMessage != null &&
            customNotificationMessage !=
                currentProfile.customNotificationMessage) ||
        (customNotificationMediaPath != null &&
            customNotificationMediaPath !=
                currentProfile.customNotificationMediaPath) ||
        (isCustomNotificationVideo != null &&
            isCustomNotificationVideo !=
                currentProfile.isCustomNotificationVideo);

    if (customEnabled &&
        (customNotificationEnabled == true ||
            customTimeChanged ||
            contentChanged)) {
      await NotificationService().scheduleCustomNotification(
        hour: updatedProfile.customNotificationHour,
        minute: updatedProfile.customNotificationMinute,
        message: updatedProfile.customNotificationMessage,
        mediaPath: updatedProfile.customNotificationMediaPath,
        isVideo: updatedProfile.isCustomNotificationVideo,
      );
    } else if (customNotificationEnabled == false) {
      await NotificationService().cancelCustomNotification();
    }
  }

  Future<bool> updateRadarChart(int index, String label, int value) async {
    final currentProfile = state.value;
    if (currentProfile == null) return false;

    // Check for duplicates
    bool nameExists = false;
    for (int i = 0; i < currentProfile.radarLabels.length; i++) {
      if (i != index &&
          currentProfile.radarLabels[i].toLowerCase() == label.toLowerCase()) {
        nameExists = true;
        break;
      }
    }

    if (nameExists) return false;

    final newLabels = List<String>.from(currentProfile.radarLabels);
    final newValues = List<int>.from(currentProfile.radarValues);

    if (index >= 0 && index < newLabels.length) {
      if (currentProfile.radarLabels[index] == 'Self Development') {
        newLabels[index] = 'Self Development';
      } else {
        newLabels[index] = label;
      }
      newValues[index] = value;

      await updateProfile(radarLabels: newLabels, radarValues: newValues);
      return true;
    }
    return false;
  }

  Future<bool> addRadarAxis(String name) async {
    final currentProfile = state.value;
    if (currentProfile == null) return false;

    if (currentProfile.radarLabels.length >= 8) return false;

    if (currentProfile.radarLabels
        .any((l) => l.toLowerCase() == name.toLowerCase())) {
      return false;
    }

    final newLabels = List<String>.from(currentProfile.radarLabels)..add(name);
    final newValues = List<int>.from(currentProfile.radarValues)..add(50);

    await updateProfile(radarLabels: newLabels, radarValues: newValues);
    return true;
  }

  Future<void> removeRadarAxis(int index) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    if (currentProfile.radarLabels.length <= 3) return;

    final newLabels = List<String>.from(currentProfile.radarLabels);
    final newValues = List<int>.from(currentProfile.radarValues);

    if (index >= 0 && index < newLabels.length) {
      if (newLabels[index] == 'Self Development') return;

      newLabels.removeAt(index);
      newValues.removeAt(index);
      await updateProfile(radarLabels: newLabels, radarValues: newValues);
    }
  }

  Future<void> addXp(int amount) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    int newXp = currentProfile.xp + amount;
    int newLevel = currentProfile.level;

    if (amount > 0) {
      int getThreshold(int lvl) => 150 + (lvl * 20);

      int threshold = getThreshold(newLevel);
      while (newXp >= threshold) {
        newXp -= threshold;
        newLevel++;
        threshold = getThreshold(newLevel);
      }
    } else {
      while (newXp < 0 && newLevel > 1) {
        newLevel--;
        int threshold =
            150 + (newLevel * 20); // Threshold of the previous leveld;
        newXp += threshold;
      }
      if (newXp < 0) newXp = 0;
    }

    await updateProfile(xp: newXp, level: newLevel);
    await checkAchievements();
  }

  Future<void> checkAchievements() async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    final completedIds =
        List<String>.from(currentProfile.completedAchievements);
    bool changed = false;
    int xpToAdd = 0;

    for (final achievement in allAchievements) {
      if (completedIds.contains(achievement.id)) continue;

      bool met = false;
      final parts = achievement.id.split('_');
      if (parts.length == 2) {
        final type = parts[0];
        final target = int.tryParse(parts[1]) ?? 0;

        if (target > 0) {
          switch (type) {
            case 'habit':
              met = currentProfile.totalHabitsCompleted >= target;
              break;
            case 'streak':
              met = currentProfile.appStreak >= target;
              break;
            case 'level':
              met = currentProfile.level >= target;
              break;
            case 'todo':
              met = currentProfile.totalTodosCompleted >= target;
              break;
            case 'journal':
              met = currentProfile.totalJournalEntries >= target;
              break;
            case 'reminder':
              met = currentProfile.totalRemindersSet >= target;
              break;
          }
        }
      }

      if (met) {
        completedIds.add(achievement.id);
        xpToAdd += achievement.xpReward;
        changed = true;
      }
    }

    if (changed) {
      // Must update list first to avoid re-triggering loop if addXp calls checkAchievements again
      // Although addXp calls checkAchievements, passing updated list prevents infinite loop
      await updateProfile(completedAchievements: completedIds);
      if (xpToAdd > 0) {
        await addXp(xpToAdd);
      }
    }
  }

  Future<void> reportHabitCompletion(bool completed) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    if (completed) {
      await updateProfile(
          totalHabitsCompleted: currentProfile.totalHabitsCompleted + 1);
      await addXp(10);
      await checkAchievements();
    } else {
      await updateProfile(
          totalHabitsCompleted: currentProfile.totalHabitsCompleted > 0
              ? currentProfile.totalHabitsCompleted - 1
              : 0);
      await addXp(-10);
      // We don't revoke achievements on undoing action usually
    }
  }

  Future<void> reportTodoCompletion(bool completed) async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    if (completed) {
      await updateProfile(
          totalTodosCompleted: currentProfile.totalTodosCompleted + 1);
      await addXp(20);
      await checkAchievements();
    } else {
      await updateProfile(
          totalTodosCompleted: currentProfile.totalTodosCompleted > 0
              ? currentProfile.totalTodosCompleted - 1
              : 0);
      await addXp(-20);
    }
  }

  Future<void> reportJournalEntry() async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    await updateProfile(
        totalJournalEntries: currentProfile.totalJournalEntries + 1);
    await addXp(15);
    await checkAchievements();
  }

  Future<void> reportReminderCreation() async {
    final currentProfile = state.value;
    if (currentProfile == null) return;

    await updateProfile(
        totalRemindersSet: currentProfile.totalRemindersSet + 1);
    await addXp(5);
    await checkAchievements();
  }

  Future<void> resetAllData() async {
    final isar = await ref.read(isarDbProvider.future);

    // Clear all data
    await isar.writeTxn(() async {
      await isar.clear();
    });

    // Cancel all notifications
    await NotificationService().cancelAll();

    // Invalidate state to trigger rebuild/re-init across the app
    ref.invalidateSelf();
    ref.invalidate(habitControllerProvider);
    ref.invalidate(todoControllerProvider);
    ref.invalidate(reminderControllerProvider);
    // Also invalidate dashboard metrics which depend on these
    ref.invalidate(dashboardRadarStatsProvider);
    ref.invalidate(dashboardTimeFilterProvider);
  }
}
