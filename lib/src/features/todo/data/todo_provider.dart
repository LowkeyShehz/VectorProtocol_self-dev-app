import 'dart:async';
import 'package:isar/isar.dart';
import 'package:level_up/src/features/common/data/isar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/todo_model.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoController extends _$TodoController {
  @override
  FutureOr<List<TodoItem>> build() async {
    final isar = await ref.watch(isarDbProvider.future);
    return isar.todoItems.where().findAll();
  }

  Future<void> addTodo(TodoItem todo) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.todoItems.put(todo);
    });
    ref.invalidateSelf();
  }

  Future<void> toggleCompletion(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      final item = await isar.todoItems.get(id);
      if (item != null) {
        item.isCompleted = !item.isCompleted;
        await isar.todoItems.put(item);
      }
    });
    ref.invalidateSelf();
  }

  Future<void> editTodo(TodoItem todo) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.todoItems.put(todo);
    });
    ref.invalidateSelf();
  }

  Future<void> deleteTodo(int id) async {
    final isar = await ref.watch(isarDbProvider.future);
    await isar.writeTxn(() async {
      await isar.todoItems.delete(id);
    });
    ref.invalidateSelf();
  }
}
