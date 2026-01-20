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
  Achievement(
    id: 'habit_1',
    title: 'First Step',
    description: 'Complete your first habit.',
    xpReward: 50,
  ),
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
    id: 'level_5',
    title: 'High Five',
    description: 'Reach Level 5.',
    xpReward: 500,
  ),
  Achievement(
    id: 'todo_10',
    title: 'Goal Getter',
    description: 'Complete 10 Todos.',
    xpReward: 150,
  ),
];
