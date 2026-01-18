import 'dart:async';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../common/data/isar_service.dart';
import '../domain/profile_model.dart';

part 'profile_provider.g.dart';

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
      );

      // Force ID 1
      newProfile.id = 1;

      await isar.writeTxn(() async {
        await isar.profiles.put(newProfile);
      });
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

    return profile;
  }

  Future<void> updateProfile({
    String? username,
    bool? isDarkMode,
    List<String>? radarLabels,
    List<int>? radarValues,
  }) async {
    final isar = await ref.watch(isarDbProvider.future);
    final currentProfile = state.value;

    if (currentProfile == null) return;

    final updatedProfile = Profile()
      ..id = currentProfile.id
      ..username = username ?? currentProfile.username
      ..isDarkMode = isDarkMode ?? currentProfile.isDarkMode
      ..radarLabels = radarLabels ?? currentProfile.radarLabels
      ..radarValues = radarValues ?? currentProfile.radarValues;

    await isar.writeTxn(() async {
      await isar.profiles.put(updatedProfile);
    });

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
