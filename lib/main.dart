import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'package:level_up/src/features/reminders/services/notification_service.dart'; // Assuming this path for NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await NotificationService().requestPermissions();
  runApp(
    ProviderScope(
      child: const LevelUpApp(),
    ),
  );
}
