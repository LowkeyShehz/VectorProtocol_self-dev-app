import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../data/todo_provider.dart';
import '../domain/todo_model.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoControllerProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            floating: true,
            title: Text(
              'MISSIONS',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          todoAsync.when(
            data: (todos) {
              if (todos.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              // 1. Sort by date first to ensure groups are chronological
              final temporallySorted = List<TodoItem>.from(todos)
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

              final groupedTodos = <String, List<TodoItem>>{};
              for (var todo in temporallySorted) {
                final key = DateFormat.yMMMM().format(todo.dueDate);
                if (!groupedTodos.containsKey(key)) {
                  groupedTodos[key] = [];
                }
                groupedTodos[key]!.add(todo);
              }

              // 2. Sort within groups: Uncompleted first, then Completed
              for (var key in groupedTodos.keys) {
                groupedTodos[key]!.sort((a, b) {
                  if (a.isCompleted != b.isCompleted) {
                    return a.isCompleted ? 1 : -1; // Moved completed to bottom
                  }
                  return a.dueDate.compareTo(b.dueDate);
                });
              }

              // 3. Sort Groups: Active Month groups first, Fully Completed Month groups last
              final groupKeys = groupedTodos.keys.toList();
              final activeGroups = <String>[];
              final completedGroups = <String>[];

              for (var key in groupKeys) {
                final isGroupFullyCompleted =
                    groupedTodos[key]!.every((t) => t.isCompleted);
                if (isGroupFullyCompleted) {
                  completedGroups.add(key);
                } else {
                  activeGroups.add(key);
                }
              }

              final finalSortedKeys = [...activeGroups, ...completedGroups];

              return MultiSliver(
                children: finalSortedKeys.map((key) {
                  final items = groupedTodos[key]!;
                  return SliverStickyHeader(
                    header: _StickyHeader(title: key),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return _TodoTile(item: item)
                              .animate()
                              .fadeIn(delay: (30 * index).ms)
                              .slideY(begin: 0.1, end: 0);
                        },
                        childCount: items.length,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $err')),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'camera',
              onPressed: () {
                // Camera OCR logic
              },
              backgroundColor: Colors.white.withOpacity(0.1),
              elevation: 0,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'add',
              onPressed: () => _showAddTodoModal(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoModal(BuildContext context, {TodoItem? existingItem}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CreateTodoModal(existingItem: existingItem),
    );
  }
}

class _StickyHeader extends StatelessWidget {
  final String title;
  const _StickyHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black.withOpacity(0.9), // Sticky glass effect
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.jetBrainsMono(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TodoTile extends ConsumerWidget {
  final TodoItem item;
  const _TodoTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = !item.isCompleted &&
        item.dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF111111),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => _CreateTodoModal(existingItem: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: isOverdue
              ? Border.all(color: Colors.redAccent.withOpacity(0.5))
              : null,
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: InkWell(
            onTap: () {
              ref
                  .read(todoControllerProvider.notifier)
                  .toggleCompletion(item.id);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: item.isCompleted
                      ? Colors.grey
                      : (isOverdue
                          ? Colors.redAccent
                          : Theme.of(context).colorScheme.primary),
                  width: 2,
                ),
                color: item.isCompleted
                    ? Colors.grey.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: item.isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.grey)
                  : null,
            ),
          ),
          title: Text(
            item.title,
            style: GoogleFonts.inter(
              color: item.isCompleted
                  ? Colors.white24
                  : (isOverdue ? Colors.redAccent : Colors.white),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.description != null && item.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    item.description!,
                    style:
                        GoogleFonts.inter(color: Colors.white54, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 12,
                      color: isOverdue ? Colors.redAccent : Colors.white24),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.MMMd().format(item.dueDate),
                    style: GoogleFonts.jetBrainsMono(
                      color: isOverdue ? Colors.redAccent : Colors.white38,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_box_outline_blank,
              size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'NO ACTIVE MISSIONS',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTodoModal extends ConsumerStatefulWidget {
  final TodoItem? existingItem;
  const _CreateTodoModal({this.existingItem});

  @override
  ConsumerState<_CreateTodoModal> createState() => _CreateTodoModalState();
}

class _CreateTodoModalState extends ConsumerState<_CreateTodoModal> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _titleController.text = widget.existingItem!.title;
      _descController.text = widget.existingItem!.description ?? '';
      _selectedDate = widget.existingItem!.dueDate;
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.black,
              surface: const Color(0xFF222222),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isEditing = widget.existingItem != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'EDIT MISSION' : 'NEW MISSION',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                IconButton(
                  onPressed: () {
                    ref
                        .read(todoControllerProvider.notifier)
                        .deleteTodo(widget.existingItem!.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Mission Title',
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            autofocus: !isEditing,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Details (Optional)...',
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            minLines: 2,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: primary),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat.yMMMMd().format(_selectedDate),
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) return;

                if (isEditing) {
                  final updatedItem = widget.existingItem!
                    ..title = _titleController.text
                    ..description = _descController.text
                    ..dueDate = _selectedDate;

                  ref
                      .read(todoControllerProvider.notifier)
                      .editTodo(updatedItem);
                } else {
                  final newItem = TodoItem.create(
                    title: _titleController.text,
                    description: _descController.text,
                    dueDate: _selectedDate,
                    isCompleted: false,
                  );

                  ref.read(todoControllerProvider.notifier).addTodo(newItem);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                isEditing ? 'UPDATE MISSION' : 'ACCEPT MISSION',
                style: GoogleFonts.jetBrainsMono(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ).animate().slideY(begin: 0.5, end: 0, delay: 200.ms),
        ],
      ),
    );
  }
}
