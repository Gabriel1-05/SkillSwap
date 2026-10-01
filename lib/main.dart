import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/discover_provider.dart';
import 'screens/app_shell.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SkillSwapApp(),
    ),
  );
}

class SkillSwapApp extends StatelessWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF193A36);
    const green = Color(0xFF1F6B57);

    return MaterialApp(
      title: 'SkillSwap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          primary: green,
          onPrimary: Colors.white,
          secondary: const Color(0xFFE9A64A),
          surface: const Color(0xFFF7F7F2),
          onSurface: ink,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: ink,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.08,
          ),
          titleLarge: TextStyle(color: ink, fontWeight: FontWeight.w700),
          bodyMedium: TextStyle(color: Color(0xFF68736E), height: 1.45),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7F2),
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const AppShell(),
    );
  }
}