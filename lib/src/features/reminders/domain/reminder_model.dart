import 'package:isar/isar.dart';

part 'reminder_model.g.dart';

@collection
class Reminder {
  Id id = Isar.autoIncrement;

  late String title;

  late DateTime remindAt;

  late bool isActive;

  String? imagePath;

  // We can use the 'id' itself as the notification ID since it's an int.

  Reminder();

  Reminder.create({
    required this.title,
    required this.remindAt,
    this.isActive = true,
    this.imagePath,
  });

  Reminder copyWith({
    String? title,
    DateTime? remindAt,
    bool? isActive,
    String? imagePath,
  }) {
    final reminder = Reminder()
      ..id = this.id
      ..title = title ?? this.title
      ..remindAt = remindAt ?? this.remindAt
      ..isActive = isActive ?? this.isActive
      ..imagePath = imagePath ?? this.imagePath;
    return reminder;
  }
}
