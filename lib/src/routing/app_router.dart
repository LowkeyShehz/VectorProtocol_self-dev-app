import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:level_up/src/features/dashboard/presentation/dashboard_screen.dart';
import 'package:level_up/src/features/habits/presentation/habits_screen.dart';
import 'package:level_up/src/features/journal/presentation/journal_screen.dart';
import 'package:level_up/src/features/reminders/presentation/reminder_screen.dart';
import 'package:level_up/src/features/profile/presentation/profile_screen.dart';
import 'package:level_up/src/features/shell/presentation/scaffold_with_navigation.dart';
import 'package:level_up/src/features/todo/presentation/todo_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/dashboard',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavigation(navigationShell: navigationShell);
        },
        branches: [
          // 1. Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // 2. Habits
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/habits',
                builder: (context, state) => const HabitsScreen(),
              ),
            ],
          ),
          // 3. To-Do
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/todo',
                builder: (context, state) => const TodoScreen(),
              ),
            ],
          ),
          // 4. Reminder
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reminders',
                builder: (context, state) => const ReminderScreen(),
              ),
            ],
          ),
          // 5. Journal
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journal',
                builder: (context, state) => const JournalScreen(),
              ),
            ],
          ),
          // 6. Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
