class Achievement {
  final String id;
  final String title;
  final String description;
  final int xpReward;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
  });
}

final List<Achievement> allAchievements = [
  // --- HABITS ---
  Achievement(
    id: 'habit_1',
    title: 'First Step',
    description: 'Complete your first habit.',
    xpReward: 50,
  ),
  Achievement(
    id: 'habit_10',
    title: 'Habit Forming',
    description: 'Complete 10 habits.',
    xpReward: 100,
  ),
  Achievement(
    id: 'habit_50',
    title: 'Discipline',
    description: 'Complete 50 habits.',
    xpReward: 250,
  ),
  Achievement(
    id: 'habit_100',
    title: 'Centurion',
    description: 'Complete 100 habits.',
    xpReward: 500,
  ),
  Achievement(
    id: 'habit_500',
    title: 'Master of Self',
    description: 'Complete 500 habits.',
    xpReward: 1000,
  ),

  // --- STREAKS ---
  Achievement(
    id: 'streak_3',
    title: 'On a Roll',
    description: 'Reach a 3-day app streak.',
    xpReward: 100,
  ),
  Achievement(
    id: 'streak_7',
    title: 'Week Warrior',
    description: 'Reach a 7-day app streak.',
    xpReward: 250,
  ),
  Achievement(
    id: 'streak_30',
    title: 'Consistency King',
    description: 'Reach a 30-day app streak.',
    xpReward: 500,
  ),
  Achievement(
    id: 'streak_100',
    title: 'Unstoppable',
    description: 'Reach a 100-day app streak.',
    xpReward: 1500,
  ),
  Achievement(
    id: 'streak_365',
    title: 'Year of Growth',
    description: 'Reach a 365-day app streak.',
    xpReward: 5000,
  ),
  Achievement(
    id: 'streak_730',
    title: 'Legacy',
    description: 'Reach a 730-day app streak.',
    xpReward: 10000,
  ),

  // --- LEVELS ---
  Achievement(
    id: 'level_3',
    title: 'Rising Star',
    description: 'Reach Level 3.',
    xpReward: 150,
  ),
  Achievement(
    id: 'level_5',
    title: 'High Five',
    description: 'Reach Level 5.',
    xpReward: 300,
  ),
  Achievement(
    id: 'level_10',
    title: 'Veteran',
    description: 'Reach Level 10.',
    xpReward: 500,
  ),
  Achievement(
    id: 'level_25',
    title: 'Elite',
    description: 'Reach Level 25.',
    xpReward: 1000,
  ),
  Achievement(
    id: 'level_50',
    title: 'Grandmaster',
    description: 'Reach Level 50.',
    xpReward: 2500,
  ),
  Achievement(
    id: 'level_100',
    title: 'Legend',
    description: 'Reach Level 100.',
    xpReward: 5000,
  ),

  // --- TASKS (TODOS) ---
  Achievement(
    id: 'todo_1',
    title: 'Task Master',
    description: 'Complete your first task.',
    xpReward: 50,
  ),
  Achievement(
    id: 'todo_10',
    title: 'Goal Getter',
    description: 'Complete 10 tasks.',
    xpReward: 150,
  ),
  Achievement(
    id: 'todo_50',
    title: 'Executor',
    description: 'Complete 50 tasks.',
    xpReward: 300,
  ),
  Achievement(
    id: 'todo_100',
    title: 'Productivity Machine',
    description: 'Complete 100 tasks.',
    xpReward: 600,
  ),

  // --- JOURNAL ---
  Achievement(
    id: 'journal_1',
    title: 'Dear Diary',
    description: 'Write your first journal entry.',
    xpReward: 50,
  ),
  Achievement(
    id: 'journal_10',
    title: 'Self Reflector',
    description: 'Write 10 journal entries.',
    xpReward: 150,
  ),
  Achievement(
    id: 'journal_50',
    title: 'Chronicler',
    description: 'Write 50 journal entries.',
    xpReward: 400,
  ),

  // --- REMINDERS / SIGNALS ---
  Achievement(
    id: 'reminder_10',
    title: 'Organized',
    description: 'Set 10 active signals.',
    xpReward: 100,
  ),
  Achievement(
    id: 'reminder_50',
    title: 'Time Keeper',
    description: 'Set 50 active signals.',
    xpReward: 300,
  ),
];
