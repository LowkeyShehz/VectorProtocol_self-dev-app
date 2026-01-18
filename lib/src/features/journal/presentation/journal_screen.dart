import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:level_up/src/features/journal/data/journal_provider.dart';
import 'package:level_up/src/features/journal/domain/journal_entry_model.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalControllerProvider);

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
              'JOURNAL',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          journalAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = entries[index];
                      return _JournalEntryCard(entry: entry)
                          .animate()
                          .fadeIn(delay: (50 * index).ms)
                          .slideX();
                    },
                    childCount: entries.length,
                  ),
                ),
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
              heroTag: 'camera_journal',
              onPressed: () => _pickImage(context, ref),
              backgroundColor: Colors.white.withOpacity(0.1),
              elevation: 0,
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              heroTag: 'add_journal',
              onPressed: () => _showAddEntryModal(context),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // Prompt for caption? or just save?
      // For now, let's open the modal with the image pre-selected or just save immediately.
      // Let's open the modal passing the image.
      if (context.mounted) {
        _showAddEntryModal(context, imagePath: pickedFile.path);
      }
    }
  }

  void _showAddEntryModal(BuildContext context,
      {String? imagePath, JournalEntry? existingEntry}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CreateJournalModal(
        initialImagePath: imagePath,
        existingEntry: existingEntry,
      ),
    );
  }
}

class _JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;
  const _JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        // Find the parent State object to call _showAddEntryModal
        final screenState =
            context.findAncestorWidgetOfExactType<JournalScreen>();
        // Since JournalScreen is a ConsumerWidget, we can't call private methods directly easily
        // But we can just duplicate the modal showing logic or move it to a global function if needed.
        // Or better, just show the modal directly here.
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF111111),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => _CreateJournalModal(existingEntry: entry),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imagePath != null && File(entry.imagePath!).existsSync())
              Image.file(
                File(entry.imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(entry.date),
                        style: GoogleFonts.jetBrainsMono(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.jm().format(entry.date),
                        style: GoogleFonts.inter(
                          color: Colors.white24,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry.content,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.book, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'LOG YOUR JOURNEY',
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

class _CreateJournalModal extends ConsumerStatefulWidget {
  final String? initialImagePath;
  final JournalEntry? existingEntry;
  const _CreateJournalModal({this.initialImagePath, this.existingEntry});

  @override
  ConsumerState<_CreateJournalModal> createState() =>
      _CreateJournalModalState();
}

class _CreateJournalModalState extends ConsumerState<_CreateJournalModal> {
  final _contentController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _contentController.text = widget.existingEntry!.content;
      _imagePath = widget.existingEntry!.imagePath;
    } else {
      _imagePath = widget.initialImagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isEditing = widget.existingEntry != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEditing ? 'EDIT ENTRY' : 'LOG ENTRY',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                IconButton(
                  onPressed: () {
                    // Confirm delete?
                    ref
                        .read(journalControllerProvider.notifier)
                        .deleteEntry(widget.existingEntry!.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _pickImage,
            child: _imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          File(_imagePath!),
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, color: primary),
                        const SizedBox(width: 8),
                        Text('Attach Image',
                            style: GoogleFonts.inter(color: Colors.white70)),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            style: GoogleFonts.inter(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'How was your day?',
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 5,
            minLines: 3,
            autofocus: !isEditing,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_contentController.text.isEmpty && _imagePath == null)
                  return;

                if (isEditing) {
                  final updatedEntry = widget.existingEntry!
                    ..content = _contentController.text
                    ..imagePath = _imagePath;
                  // Note: Since Isar objects are just objects, modifying fields and put() works.
                  // But check if we need to set other fields. Date stays original? or updates?
                  // Usually journal date stays original.
                  ref
                      .read(journalControllerProvider.notifier)
                      .editEntry(updatedEntry);
                } else {
                  ref.read(journalControllerProvider.notifier).addEntry(
                        _contentController.text,
                        imagePath: _imagePath,
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
                isEditing ? 'UPDATE ENTRY' : 'SAVE ENTRY',
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
