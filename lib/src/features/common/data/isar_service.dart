import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../habits/domain/habit_model.dart';
import '../../todo/domain/todo_model.dart';
import '../../reminders/domain/reminder_model.dart';
import '../../journal/domain/journal_entry_model.dart';
import '../../profile/domain/profile_model.dart';

part 'isar_service.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDb(IsarDbRef ref) async {
  // Renamed to isarDb to just return the Future<Isar>
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open(
      [
        HabitSchema,
        TodoItemSchema,
        ReminderSchema,
        JournalEntrySchema,
        ProfileSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
  }
  return Isar.getInstance()!;
}
