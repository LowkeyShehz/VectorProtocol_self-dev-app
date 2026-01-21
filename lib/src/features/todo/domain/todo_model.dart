import 'package:isar/isar.dart';

part 'todo_model.g.dart';

@collection
class TodoItem {
  Id id = Isar.autoIncrement;

  late String title;

  String? description;

  late DateTime dueDate;

  late bool isCompleted;

  String? imagePath;

  TodoItem();

  TodoItem.create({
    required this.title,
    this.description,
    required this.dueDate,
    this.isCompleted = false,
    this.imagePath,
  });

  TodoItem copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    String? imagePath,
  }) {
    final item = TodoItem()
      ..id = this.id
      ..title = title ?? this.title
      ..description = description ?? this.description
      ..dueDate = dueDate ?? this.dueDate
      ..isCompleted = isCompleted ?? this.isCompleted
      ..imagePath = imagePath ?? this.imagePath;
    return item;
  }
}
