import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:level_up/src/routing/app_router.dart';
import 'package:level_up/src/features/profile/data/profile_provider.dart';

class LevelUpApp extends ConsumerWidget {
  const LevelUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final profileAsync = ref.watch(profileControllerProvider);

    return profileAsync.when(
      data: (profile) => MaterialApp.router(
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        title: 'Level Up',
        themeMode: profile.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFF0F0F0),
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF00C853),
            secondary: const Color(0xFF00B0FF),
            surface: Colors.white,
            background: const Color(0xFFF0F0F0),
            onPrimary: Colors.white,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00FF9D), // Neon Green
            secondary: Color(0xFF00E5FF), // Neon Cyan
            surface: Color(0xFF111111),
            background: Colors.black,
            onPrimary: Colors.black,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error: $err'))),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
