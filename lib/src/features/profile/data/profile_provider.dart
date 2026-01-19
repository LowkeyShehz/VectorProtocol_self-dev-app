import 'dart:async';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../common/data/isar_service.dart';
import '../domain/profile_model.dart';

import '../../reminders/services/notification_service.dart';

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
    List<String>? completedAchievements,
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
      ..completedAchievements =
          completedAchievements ?? currentProfile.completedAchievements;

    await isar.writeTxn(() async {
      await isar.profiles.put(updatedProfile);
    });

    // Handle Quote Scheduling if toggled or time changed
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

    ref.invalidateSelf();
  }

  Future<bool> updateRadarChart(int index, String label, int value) async {
    final currentProfile = state.value;
    if (currentProfile == null) return false;

    // Check for duplicates
    // We want to allow keeping the name same if we are just updating value,
    // but if we are renaming, we must check if OTHER indices have this name.
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
      // Prevent renaming 'Self Development'
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

    // Duplicate check
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
      // Prevent removing 'Self Development'
      if (newLabels[index] == 'Self Development') return;

      newLabels.removeAt(index);
      newValues.removeAt(index);
      await updateProfile(radarLabels: newLabels, radarValues: newValues);
    }
  }
}
