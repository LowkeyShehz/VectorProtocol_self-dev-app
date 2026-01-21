import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../data/reminder_provider.dart';
import '../domain/reminder_model.dart';
import '../services/notification_service.dart';

class ReminderScreen extends ConsumerWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminderAsync = ref.watch(reminderControllerProvider);

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
              'REMINDERS',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_active),
                onPressed: () {
                  NotificationService().requestPermissions();
                },
              ),
            ],
          ),
          reminderAsync.when(
            data: (reminders) {
              if (reminders.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              final groupedReminders = <String, List<Reminder>>{};
              final now = DateTime.now();

              // Sort reminders:
              // 1. Upcoming first
              // 2. Archived (past & different day) last
              // 3. Within groups, sort by time diff
              final sortedReminders = List<Reminder>.from(reminders)
                ..sort((a, b) {
                  final aIsPast = a.remindAt.isBefore(now);
                  final bIsPast = b.remindAt.isBefore(now);

                  final aIsToday = a.remindAt.year == now.year &&
                      a.remindAt.month == now.month &&
                      a.remindAt.day == now.day;
                  final bIsToday = b.remindAt.year == now.year &&
                      b.remindAt.month == now.month &&
                      b.remindAt.day == now.day;

                  final aIsArchived = aIsPast && !aIsToday;
                  final bIsArchived = bIsPast && !bIsToday;

                  if (aIsArchived && !bIsArchived) return 1;
                  if (!aIsArchived && bIsArchived) return -1;

                  return a.remindAt.compareTo(b.remindAt);
                });

              for (var reminder in sortedReminders) {
                // If archived, maybe group them separately?
                // Or just keep them in their respective month buckets but sorted at bottom of that month?
                // The sort above handles list order.
                final key = DateFormat.yMMMM().format(reminder.remindAt);
                if (!groupedReminders.containsKey(key)) {
                  groupedReminders[key] = [];
                }
                groupedReminders[key]!.add(reminder);
              }

              return MultiSliver(
                children: groupedReminders.entries.map((entry) {
                  return SliverStickyHeader(
                    header: _StickyHeader(title: entry.key),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = entry.value[index];
                          return _ReminderTile(item: item)
                              .animate()
                              .fadeIn(delay: (30 * index).ms)
                              .slideX();
                        },
                        childCount: entry.value.length,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderModal(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showAddReminderModal(BuildContext context, {Reminder? existingItem}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CreateReminderModal(existingItem: existingItem),
    );
  }
}

class _StickyHeader extends StatelessWidget {
  final String title;
  const _StickyHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 60,
      color: (isDark ? Colors.black : Colors.white).withOpacity(0.9),
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

class _ReminderTile extends ConsumerWidget {
  final Reminder item;
  const _ReminderTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;
    final now = DateTime.now();
    final isPast = item.remindAt.isBefore(now);
    final isToday = item.remindAt.year == now.year &&
        item.remindAt.month == now.month &&
        item.remindAt.day == now.day;
    final isArchived = isPast && !isToday;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Visual styles for archived items
    final textColor =
        isArchived ? Colors.grey : (isDark ? Colors.white : Colors.black);
    final timeColor = isArchived
        ? (isDark ? Colors.white24 : Colors.black26)
        : (isPast
            ? (isDark ? Colors.white38 : Colors.black38)
            : (isDark ? Colors.white : Colors.black));

    final decoration = isArchived ? TextDecoration.lineThrough : null;
    final badgeColor = isArchived ? Colors.grey : primary;

    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: isDark ? const Color(0xFF111111) : Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => _CreateReminderModal(existingItem: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(isArchived ? 0.02 : 0.05)
              : Colors.grey.withOpacity(
                  isArchived ? 0.05 : 0.2), // Light gray for light mode
          borderRadius: BorderRadius.circular(12),
          border: Border(
              left: BorderSide(
                  color: isArchived ? Colors.grey.shade800 : badgeColor,
                  width: 4)),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  DateFormat('HH:mm').format(item.remindAt),
                  style: GoogleFonts.jetBrainsMono(
                    color: timeColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: decoration,
                  ),
                ),
                Text(
                  DateFormat('MMM d').format(item.remindAt),
                  style: GoogleFonts.inter(
                    color: isDark ? Colors.white24 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            if (item.imagePath != null) ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: ResizeImage(
                      FileImage(File(item.imagePath!)),
                      width: 150,
                    ),
                    fit: BoxFit.cover,
                    opacity: isArchived ? 0.5 : 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                item.title,
                style: GoogleFonts.inter(
                  color: item.isActive
                      ? textColor
                      : (isDark ? Colors.white24 : Colors.black26),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration:
                      !item.isActive ? TextDecoration.lineThrough : decoration,
                ),
              ),
            ),
            if (!isArchived)
              Switch.adaptive(
                value: item.isActive,
                onChanged: (val) {
                  ref
                      .read(reminderControllerProvider.notifier)
                      .toggleReminder(item.id);
                },
                activeColor: primary,
                inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_off_outlined,
              size: 64,
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'NO ACTIVE SIGNALS',
            style: GoogleFonts.jetBrainsMono(
              color: isDark ? Colors.white54 : Colors.black54,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateReminderModal extends ConsumerStatefulWidget {
  final Reminder? existingItem;
  const _CreateReminderModal({this.existingItem});

  @override
  ConsumerState<_CreateReminderModal> createState() =>
      _CreateReminderModalState();
}

class _CreateReminderModalState extends ConsumerState<_CreateReminderModal> {
  final _titleController = TextEditingController();
  DateTime _scheduledTime = DateTime.now().add(const Duration(minutes: 5));
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _titleController.text = widget.existingItem!.title;
      _scheduledTime = widget.existingItem!.remindAt;
      if (widget.existingItem!.imagePath != null) {
        _selectedImage = File(widget.existingItem!.imagePath!);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isEditing = widget.existingItem != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'EDIT SIGNAL' : 'NEW SIGNAL',
                  style: GoogleFonts.jetBrainsMono(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt,
                          color: isDark ? Colors.white70 : Colors.black54),
                      tooltip: 'Take Photo',
                    ),
                    IconButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library,
                          color: isDark ? Colors.white70 : Colors.black54),
                      tooltip: 'Choose from Gallery',
                    ),
                    if (isEditing)
                      IconButton(
                        onPressed: () {
                          ref
                              .read(reminderControllerProvider.notifier)
                              .deleteReminder(widget.existingItem!.id);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Image Preview
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _selectedImage = null),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

            TextField(
              controller: _titleController,
              style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Reminder Title',
                hintStyle: GoogleFonts.inter(
                    color: isDark ? Colors.white24 : Colors.black26),
                filled: true,
                fillColor: isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              autofocus: !isEditing,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  brightness: isDark ? Brightness.dark : Brightness.light,
                  textTheme: CupertinoTextThemeData(
                    pickerTextStyle: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 16),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _scheduledTime,
                  onDateTimeChanged: (val) {
                    setState(() => _scheduledTime = val);
                  },
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
                      ..remindAt = _scheduledTime
                      ..imagePath =
                          _selectedImage?.path; // Allow clearing image if null

                    ref
                        .read(reminderControllerProvider.notifier)
                        .editReminder(updatedItem);
                  } else {
                    ref.read(reminderControllerProvider.notifier).addReminder(
                          _titleController.text,
                          _scheduledTime,
                          imagePath: _selectedImage?.path,
                        );
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
                  isEditing ? 'UPDATE SIGNAL' : 'SCHEDULE SIGNAL',
                  style: GoogleFonts.jetBrainsMono(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ).animate().slideY(begin: 0.5, end: 0, delay: 200.ms),
          ],
        ),
      ),
    );
  }
}
