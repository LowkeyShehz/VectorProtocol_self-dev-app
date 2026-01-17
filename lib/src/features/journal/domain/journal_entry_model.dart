import 'package:isar/isar.dart';

part 'journal_entry_model.g.dart';

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  late String content;

  late DateTime date;

  String? imagePath;

  JournalEntry(); // Default constructor for Isar

  JournalEntry.create({
    required this.content,
    required this.date,
    this.imagePath,
  });
}
