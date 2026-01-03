import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/todo_model.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoController extends _$TodoController {
  @override
  FutureOr<List<TodoItem>> build() {
    // Initial mock data
    return [
      TodoItem(
        id: '1',
        title: 'Complete Flutter Architecture',
        dueDate: DateTime.now(),
        isCompleted: false,
      ),
      TodoItem(
        id: '2',
        title: 'Read Clean Code',
        description: 'Chapter 2 and 3',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        isCompleted: false,
      ),
      TodoItem(
        id: '3',
        title: 'Review PRs',
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue
        isCompleted: false,
      ),
    ];
  }

  Future<void> addTodo(TodoItem todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      final currentList = state.value ?? [];
      return [...currentList, todo];
    });
  }

  Future<void> toggleCompletion(String id) async {
    final currentList = state.value;
    if (currentList == null) return;

    state = await AsyncValue.guard(() async {
      return currentList.map((item) {
        if (item.id == id) {
          return item.copyWith(isCompleted: !item.isCompleted);
        }
        return item;
      }).toList();
    });
  }
}
