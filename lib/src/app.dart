import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:level_up/src/routing/app_router.dart';
import 'dart:async';
import 'package:level_up/src/features/reminders/services/notification_service.dart';
import 'package:level_up/src/features/profile/data/profile_provider.dart';

class LevelUpApp extends ConsumerStatefulWidget {
  const LevelUpApp({super.key});

  @override
  ConsumerState<LevelUpApp> createState() => _LevelUpAppState();
}

class _LevelUpAppState extends ConsumerState<LevelUpApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final ns = NotificationService();
    // Initialize in parallel with UI
    await ns.init();
    ns.requestPermissions(); // Don't await permission request

    if (!mounted) return;

    _sub = ns.onNotificationTap.listen(_handlePayload);

    // Check for pending payload from cold start
    final pending = ns.pendingPayload;
    if (pending != null) {
      if (mounted) {
        _handlePayload(pending);
        ns.pendingPayload = null;
      }
    }
  }

  void _handlePayload(String? payload) {
    if (payload != null && payload.startsWith('custom_media')) {
      final parts = payload.split('|');
      if (parts.length >= 3) {
        final type = parts[1];
        final path = parts.sublist(2).join('|');
        final isVideo = type == 'video';

        ref.read(goRouterProvider).push(
              Uri(
                path: '/media_viewer',
                queryParameters: {
                  'path': path,
                  'is_video': isVideo.toString(),
                },
              ).toString(),
            );
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
