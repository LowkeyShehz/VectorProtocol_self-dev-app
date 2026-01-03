import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  const ScaffoldWithNavigation({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
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
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
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
              icon: Icon(CupertinoIcons.settings),
              label: 'Config',
            ),
          ],
        ),
      ),
    );
  }
}
