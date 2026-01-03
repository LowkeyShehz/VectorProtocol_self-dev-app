import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _PlaceholderView(title: 'JOURNAL', icon: Icons.book_outlined);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const _PlaceholderView(title: 'SETTINGS', icon: Icons.settings_outlined);
}

// Common Placeholder Widget
class _PlaceholderView extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderView({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white54,
              fontSize: 20,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '[UNDER CONSTRUCTION]',
            style: GoogleFonts.inter(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
