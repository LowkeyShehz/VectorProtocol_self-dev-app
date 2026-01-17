import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../habits/data/habit_provider.dart';
import '../../habits/domain/habit_model.dart';
import '../../todo/data/todo_provider.dart';
import '../../todo/domain/todo_model.dart';
import '../../reminders/data/reminder_provider.dart';
import '../../reminders/domain/reminder_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cyberpunk colors
    final primaryColor = Theme.of(context).colorScheme.primary;
    final gridColor = Colors.white.withOpacity(0.1);

    final habitsAsync = ref.watch(habitControllerProvider);
    final todosAsync = ref.watch(todoControllerProvider);
    final remindersAsync = ref.watch(reminderControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black, // Deep dark background
      appBar: AppBar(
        title: Text(
          'DASHBOARD',
          style: GoogleFonts.jetBrainsMono(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BIO-METRICS',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: RadarChart(
                  RadarChartData(
                    radarTouchData: RadarTouchData(enabled: true),
                    dataSets: [
                      RadarDataSet(
                        fillColor: primaryColor.withOpacity(0.2),
                        borderColor: primaryColor,
                        entryRadius: 3,
                        dataEntries: [
                          const RadarEntry(value: 80), // Health
                          const RadarEntry(value: 60), // Intellect
                          const RadarEntry(value: 70), // Social
                          const RadarEntry(value: 90), // Spirit
                          const RadarEntry(value: 50), // Finance
                          const RadarEntry(value: 75), // Creativity
                        ],
                        borderWidth: 2,
                      ),
                    ],
                    radarBackgroundColor: Colors.transparent,
                    borderData: FlBorderData(show: false),
                    radarBorderData: const BorderSide(
                      color: Colors.transparent,
                    ),
                    titlePositionPercentageOffset: 0.2,
                    titleTextStyle: GoogleFonts.jetBrainsMono(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    getTitle: (index, angle) {
                      switch (index) {
                        case 0:
                          return const RadarChartTitle(text: 'Health');
                        case 1:
                          return const RadarChartTitle(text: 'Intellect');
                        case 2:
                          return const RadarChartTitle(text: 'Social');
                        case 3:
                          return const RadarChartTitle(text: 'Spirit');
                        case 4:
                          return const RadarChartTitle(text: 'Finance');
                        case 5:
                          return const RadarChartTitle(text: 'Creativity');
                        default:
                          return const RadarChartTitle(text: '');
                      }
                    },
                    tickCount: 1,
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    gridBorderData: BorderSide(color: gridColor, width: 1),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 400),
                ),
              ),
              const SizedBox(height: 20),
              // Stats Area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatItem('LEVEL', '42'),
                    _StatItem('XP', '8,903'),
                    _StatItem('STREAK', '12'),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Pending Habits
              Text(
                'PENDING PROTOCOLS',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              habitsAsync.when(
                data: (habits) {
                  final pending = habits
                      .where((h) {
                        final isToday = h.isCompletedOn(DateTime.now());
                        return !isToday; // Only show not completed purely for dashboard pending view? or maybe show top 3
                      })
                      .take(3)
                      .toList(); // Show top 3 pending

                  if (pending.isEmpty) {
                    return const Text('All protocols executed.',
                        style: TextStyle(color: Colors.white38));
                  }

                  return Column(
                    children: pending
                        .map((h) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _HabitItem(
                                label: h.title,
                                streak:
                                    0, // Need to implement streak logic later
                                primaryColor: h.type == HabitType.good
                                    ? primaryColor
                                    : Colors.red,
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error: $e',
                    style: const TextStyle(color: Colors.red)),
              ),

              const SizedBox(height: 30),

              // Today's To-Do
              Text(
                'ACTIVE MISSIONS',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              todosAsync.when(
                data: (todos) {
                  final active =
                      todos.where((t) => !t.isCompleted).take(3).toList();
                  if (active.isEmpty) {
                    return const Text('No missions active.',
                        style: TextStyle(color: Colors.white38));
                  }
                  return Column(
                    children: active
                        .map((t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _TodoItem(
                                label: t.title,
                                isDone: t.isCompleted,
                                primaryColor: primaryColor,
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 30),

              // Reminders
              Text(
                'INCOMING SIGNALS',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              remindersAsync.when(
                data: (reminders) {
                  final incoming = reminders
                      .where((r) =>
                          r.isActive && r.remindAt.isAfter(DateTime.now()))
                      .take(3)
                      .toList();
                  if (incoming.isEmpty) {
                    return const Text('No signals detected.',
                        style: TextStyle(color: Colors.white38));
                  }
                  return Column(
                    children: incoming
                        .map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: _ReminderItem(
                                time: DateFormat('HH:mm').format(r.remindAt),
                                label: r.title,
                                primaryColor: primaryColor,
                              ),
                            ))
                        .toList(),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 80), // Bottom padding for scrolling
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}

class _HabitItem extends StatelessWidget {
  final String label;
  final int streak;
  final Color primaryColor;

  const _HabitItem({
    required this.label,
    required this.streak,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.local_fire_department, color: primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                '$streak',
                style: GoogleFonts.jetBrainsMono(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final String label;
  final bool isDone;
  final Color primaryColor;

  const _TodoItem({
    required this.label,
    required this.isDone,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: Border(
          left: BorderSide(
            color: isDone ? Colors.grey : primaryColor,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            color: isDone ? Colors.grey : primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: isDone ? Colors.white38 : Colors.white,
                fontSize: 14,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderItem extends StatelessWidget {
  final String time;
  final String label;
  final Color primaryColor;

  const _ReminderItem({
    required this.time,
    required this.label,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Text(
              time,
              style: GoogleFonts.jetBrainsMono(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
