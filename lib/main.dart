import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialization moved to App.dart for faster startup
  runApp(
    const ProviderScope(
      child: LevelUpApp(),
    ),
  );
}
