import 'dart:async';
import 'package:level_up/src/features/common/data/isar_service.dart';
import 'package:level_up/src/features/journal/domain/journal_entry_model.dart';
import '../../profile/data/profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';

part 'journal_provider.g.dart';

@riverpod
class JournalController extends _$JournalController {
  @override
  FutureOr<List<JournalEntry>> build() async {
    final isar = await ref.watch(isarDbProvider.future);
    return isar.journalEntrys.where().sortByDateDesc().findAll();
  }

  Future<void> addEntry(String content, {String? imagePath}) async {
    final isar = await ref.watch(isarDbProvider.future);
    final entry = JournalEntry.create(
      content: content,
      date: DateTime.now(),
      imagePath: imagePath,
    );
    await isar.writeTxn(() async {
      await isar.journalEntrys.put(entry);
    });

    // Check achievements
    ref.read(profileControllerProvider.notifier).reportJournalEntry();

    ref.invalidateSelf();
  }

  Future<void> editEntry(JournalEntry entry) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.journalEntrys.put(entry);
    });
    ref.invalidateSelf();
  }

  Future<void> deleteEntry(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.journalEntrys.delete(id);
    });
    ref.invalidateSelf();
  }
}
