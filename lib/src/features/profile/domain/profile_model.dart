import 'package:isar/isar.dart';

part 'profile_model.g.dart';

@collection
class Profile {
  Id id = Isar.autoIncrement;

  late String username;

  late bool isDarkMode;

  late List<String> radarLabels;

  late List<int> radarValues;

  Profile();

  Profile.create({
    this.username = 'User',
    this.isDarkMode = true,
    required this.radarLabels,
    required this.radarValues,
  });
}
