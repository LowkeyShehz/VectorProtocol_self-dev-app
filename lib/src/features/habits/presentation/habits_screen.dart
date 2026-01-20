import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../data/habit_provider.dart';
import '../domain/habit_model.dart';
import '../../profile/data/profile_provider.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitControllerProvider);

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
              'HABIT TRACKER',
              style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          habitsAsync.when(
            data: (habits) {
              if (habits.isEmpty) {
                return const SliverFillRemaining(
                  child: _EmptyState(),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = habits[index];
                      return _HabitCard(habit: habit)
                          .animate()
                          .fadeIn(delay: (50 * index).ms)
                          .slideX();
                    },
                    childCount: habits.length,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitModal(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _showAddHabitModal(BuildContext context, {Habit? existingHabit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CreateHabitModal(existingHabit: existingHabit),
    );
  }
}

class _HabitCard extends ConsumerWidget {
  final Habit habit;
  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGood = habit.type == HabitType.good;
    final color = isGood ? const Color(0xFF00FF9D) : Colors.redAccent;
    final isCompletedToday = habit.isCompletedOn(DateTime.now());

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF111111),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          builder: (context) => _HabitDetailsModal(habit: habit),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF111111),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) => _CreateHabitModal(existingHabit: habit),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.title,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration:
                          isCompletedToday ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getFrequencyText(habit),
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            // Streak & Check Button
            Row(
              children: [
                if (habit.currentStreak > 0) ...[
                  Text(
                    '🔥 ${habit.currentStreak}',
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color(0xFF00FF9D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                InkWell(
                  onTap: () {
                    ref
                        .read(habitControllerProvider.notifier)
                        .toggleCompletion(habit.id, DateTime.now());
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCompletedToday
                          ? color.withOpacity(0.2)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompletedToday ? color : Colors.white24,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 20,
                      color: isCompletedToday ? color : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFrequencyText(Habit habit) {
    String freq = habit.frequency.name.toUpperCase();
    if (habit.frequency == HabitFrequency.weekly) {
      if (habit.weeklyType == HabitWeeklyType.specificDays) {
        freq = 'WEEKLY (Specific Days)';
      } else {
        freq = 'WEEKLY (${habit.weeklyCount} days)';
      }
    }
    return '$freq • ${habit.category.name.toUpperCase()}';
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
          Icon(Icons.grid_off, size: 64, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            'NO PROTOCOLS FOUND',
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

class _CreateHabitModal extends ConsumerStatefulWidget {
  final Habit? existingHabit;
  const _CreateHabitModal({this.existingHabit});

  @override
  ConsumerState<_CreateHabitModal> createState() => _CreateHabitModalState();
}

class _CreateHabitModalState extends ConsumerState<_CreateHabitModal> {
  final _titleController = TextEditingController();
  HabitType _type = HabitType.good;
  HabitFrequency _frequency = HabitFrequency.daily;
  HabitWeeklyType _weeklyType = HabitWeeklyType.specificDays;
  HabitCategory _category = HabitCategory.health;
  final Set<int> _selectedDays = {};
  int _targetDaysCount = 1;
  String? _selectedRadarAttribute;

  @override
  void initState() {
    super.initState();
    if (widget.existingHabit != null) {
      final h = widget.existingHabit!;
      _titleController.text = h.title;
      _type = h.type;
      _frequency = h.frequency;
      _category = h.category;
      if (h.weeklyType != null) _weeklyType = h.weeklyType!;
      if (h.targetDays.isNotEmpty) _selectedDays.addAll(h.targetDays);
      _targetDaysCount = h.weeklyCount;
      _selectedRadarAttribute = h.relatedAttribute;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isEditing = widget.existingHabit != null;

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
                isEditing ? 'EDIT PROTOCOL' : 'NEW PROTOCOL',
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
                        .read(habitControllerProvider.notifier)
                        .deleteHabit(widget.existingHabit!.id);
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
              hintText: 'What do you want to achieve?',
              hintStyle: GoogleFonts.inter(color: Colors.white24),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            autofocus: !isEditing,
          ),
          const SizedBox(height: 24),

          SegmentedButton<HabitType>(
            segments: const [
              ButtonSegment(
                value: HabitType.good,
                label: Text('GOOD HABIT'),
                icon: Icon(Icons.arrow_upward),
              ),
              ButtonSegment(
                value: HabitType.bad,
                label: Text('BAD HABIT'),
                icon: Icon(Icons.arrow_downward),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (Set<HabitType> newSelection) {
              setState(() => _type = newSelection.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return _type == HabitType.good
                      ? const Color(0xFF00FF9D).withOpacity(0.2)
                      : Colors.redAccent.withOpacity(0.2);
                }
                return Colors.transparent;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return _type == HabitType.good
                      ? const Color(0xFF00FF9D)
                      : Colors.redAccent;
                }
                return Colors.white54;
              }),
            ),
          ).animate().slideY(begin: 0.2, end: 0, duration: 300.ms),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CATEGORY',
                        style: GoogleFonts.jetBrainsMono(
                            fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<HabitCategory>(
                      value: _category,
                      isExpanded: true, // Key property to prevent overflow
                      dropdownColor: const Color(0xFF222222),
                      style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13), // Reduce font slightly
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: HabitCategory.values
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _category = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FREQUENCY',
                        style: GoogleFonts.jetBrainsMono(
                            fontSize: 10, color: Colors.grey)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<HabitFrequency>(
                      value: _frequency,
                      isExpanded: true, // Key property
                      dropdownColor: const Color(0xFF222222),
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: HabitFrequency.values
                          .map((f) => DropdownMenuItem(
                                value: f,
                                child: Text(
                                  f.name.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _frequency = val!),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().slideY(begin: 0.2, end: 0, delay: 100.ms),

          const SizedBox(height: 16),
          // Radar Attribute
          Consumer(
            builder: (context, ref, child) {
              final profileAsync = ref.watch(profileControllerProvider);
              return profileAsync.maybeWhen(
                data: (profile) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RADAR LINK (Optional)',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedRadarAttribute,
                        dropdownColor: const Color(0xFF222222),
                        style: GoogleFonts.inter(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          hintText: 'None',
                          hintStyle: GoogleFonts.inter(color: Colors.white24),
                        ),
                        items: [
                          // Option to clear
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...profile.radarLabels.map((l) => DropdownMenuItem(
                                value: l,
                                child: Text(l),
                              )),
                        ],
                        onChanged: (val) =>
                            setState(() => _selectedRadarAttribute = val),
                      ),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),

          // Weekly Logic
          // 1. Sub-Type Selection (Specific Days vs Count)
          if (_frequency == HabitFrequency.weekly) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _WeeklyTypeButton(
                    isSelected: _weeklyType == HabitWeeklyType.specificDays,
                    label: 'Specific Days',
                    onTap: () => setState(
                        () => _weeklyType = HabitWeeklyType.specificDays),
                    primary: primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _WeeklyTypeButton(
                    isSelected: _weeklyType == HabitWeeklyType.countPerWeek,
                    label: 'Days / Week',
                    onTap: () => setState(
                        () => _weeklyType = HabitWeeklyType.countPerWeek),
                    primary: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_weeklyType == HabitWeeklyType.specificDays) ...[
              Text('SELECT DAYS',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index];
                  final isSelected = _selectedDays.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedDays.remove(index);
                        } else {
                          _selectedDays.add(index);
                        }
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected ? primary : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? primary : Colors.white24,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        dayName,
                        style: GoogleFonts.inter(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ).animate().fadeIn(),
            ] else ...[
              Text('TARGET COUNT: $_targetDaysCount DAYS',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 10, color: Colors.grey)),
              Slider(
                value: _targetDaysCount.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                activeColor: primary,
                inactiveColor: Colors.white24,
                label: '$_targetDaysCount',
                onChanged: (val) =>
                    setState(() => _targetDaysCount = val.toInt()),
              ),
            ],
          ],

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) return;

                if (isEditing) {
                  // We need to mutate the existing object
                  final updatedHabit = widget.existingHabit!
                    ..title = _titleController.text
                    ..type = _type
                    ..frequency = _frequency
                    ..weeklyType =
                        _frequency == HabitFrequency.weekly ? _weeklyType : null
                    ..targetDays = _selectedDays.toList()
                    ..weeklyCount = _targetDaysCount
                    ..color = _type == HabitType.good ? 0xFF00FF9D : 0xFFFF5252
                    ..category = _category
                    ..relatedAttribute = _selectedRadarAttribute;

                  ref
                      .read(habitControllerProvider.notifier)
                      .editHabit(updatedHabit);
                } else {
                  final newHabit = Habit.create(
                    title: _titleController.text,
                    type: _type,
                    frequency: _frequency,
                    weeklyType: _frequency == HabitFrequency.weekly
                        ? _weeklyType
                        : null,
                    targetDays: _selectedDays.toList(),
                    weeklyCount: _targetDaysCount,
                    color: _type == HabitType.good ? 0xFF00FF9D : 0xFFFF5252,
                    category: _category,
                    createdAt: DateTime.now(),
                  )..relatedAttribute = _selectedRadarAttribute;

                  ref.read(habitControllerProvider.notifier).addHabit(newHabit);
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
                isEditing ? 'UPDATE PROTOCOL' : 'INITIALIZE PROTOCOL',
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

class _WeeklyTypeButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;
  final Color primary;

  const _WeeklyTypeButton({
    required this.isSelected,
    required this.label,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? primary : Colors.white54,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _HabitDetailsModal extends StatefulWidget {
  final Habit habit;
  const _HabitDetailsModal({required this.habit});

  @override
  State<_HabitDetailsModal> createState() => _HabitDetailsModalState();
}

class _HabitDetailsModalState extends State<_HabitDetailsModal> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final habit = widget.habit;
    final completedDates = habit.completedDates;

    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Mon, 7 = Sun

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title.toUpperCase(),
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${habit.frequency.name.toUpperCase()} • ${habit.category.name.toUpperCase()}',
                          style: GoogleFonts.inter(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  if (habit.relatedAttribute != null)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: primary.withOpacity(0.5)),
                      ),
                      child: Text(
                        habit.relatedAttribute!,
                        style: GoogleFonts.jetBrainsMono(
                            color: primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Text('BEST STREAK',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('🔥 ${habit.bestStreak}',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Text('CURRENT STREAK',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 10, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('${habit.currentStreak}',
                            style: GoogleFonts.jetBrainsMono(
                                fontSize: 18,
                                color: primary,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Calendar Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month - 1);
                      });
                    },
                  ),
                  Text(
                    DateFormat.yMMMM().format(_focusedDay).toUpperCase(),
                    style: GoogleFonts.jetBrainsMono(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _focusedDay =
                            DateTime(_focusedDay.year, _focusedDay.month + 1);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Weekday Headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                    .map((day) => SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              day,
                              style: GoogleFonts.jetBrainsMono(
                                color: Colors.white30,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Calendar Grid
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  itemCount: daysInMonth + (firstWeekday - 1),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    if (index < firstWeekday - 1) {
                      return const SizedBox();
                    }
                    final day = index - (firstWeekday - 1) + 1;
                    final date =
                        DateTime(_focusedDay.year, _focusedDay.month, day);

                    final isCompleted = completedDates.any((d) =>
                        d.year == date.year &&
                        d.month == date.month &&
                        d.day == date.day);

                    final isToday = DateUtils.isSameDay(date, DateTime.now());

                    return Container(
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? (habit.type == HabitType.good
                                ? const Color(0xFF00FF9D).withOpacity(0.2)
                                : Colors.redAccent.withOpacity(0.2))
                            : (isToday
                                ? Colors.white.withOpacity(0.1)
                                : Colors.transparent),
                        shape: BoxShape.circle,
                        border: isCompleted || isToday
                            ? Border.all(
                                color: isCompleted
                                    ? (habit.type == HabitType.good
                                        ? const Color(0xFF00FF9D)
                                        : Colors.redAccent)
                                    : Colors.white24)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: GoogleFonts.inter(
                            color: isCompleted ? Colors.white : Colors.white24,
                            fontWeight: isCompleted || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
