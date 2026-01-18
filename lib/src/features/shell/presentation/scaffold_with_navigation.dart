import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:level_up/src/features/reminders/services/notification_service.dart';

class ScaffoldWithNavigation extends StatefulWidget {
  const ScaffoldWithNavigation({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavigation> createState() => _ScaffoldWithNavigationState();
}

class _ScaffoldWithNavigationState extends State<ScaffoldWithNavigation> {
  @override
  void initState() {
    super.initState();
    // Request permissions on app launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Colors.white54,
            );
          }),
          indicatorColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.15),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return const IconThemeData(color: Colors.white54);
          }),
        ),
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          backgroundColor: Colors.black, // Cyberpunk black
          surfaceTintColor: Colors.transparent,
          height: 70,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.graph_circle),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.square_grid_2x2),
              label: 'Habits',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.checkmark_square),
              label: 'Tasks',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.bell),
              label: 'Remind',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.book),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
