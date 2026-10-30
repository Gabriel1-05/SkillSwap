/// ============================================================
/// MAIN.DART — Entry Point Aplikasi SkillSwap
/// ============================================================
/// Perubahan untuk Local Data & Persistence:
///   - Inisialisasi SharedPreferences sebelum runApp
///   - Mengganti InMemorySkillSwapRepository dengan
///     LocalSkillSwapRepository agar data di-persist ke
///     shared_preferences
///   - Menambahkan LocalDataProvider ke MultiProvider
/// ============================================================
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'providers/booking_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/discover_provider.dart';
import 'providers/local_data_provider.dart';
import 'providers/profile_photo_provider.dart';
import 'providers/request_provider.dart';
import 'providers/sent_request_provider.dart';
import 'screens/app_shell.dart';
import 'services/local_skill_swap_repository.dart';
import 'services/local_storage_service.dart';
import 'services/profile_photo_service.dart';
import 'services/skill_swap_request_api.dart';

/// Entry point: menunggu SharedPreferences siap, lalu baru runApp.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi shared_preferences — local storage
  final prefs = await SharedPreferences.getInstance();
  final storage = LocalStorageService(prefs);
  final repository = LocalSkillSwapRepository(storage);
  await repository.initialize();
  final requestApi = SkillSwapRequestApi(
    FirestoreSkillSwapRequestDataSource(FirebaseFirestore.instance),
  );

  runApp(
    MultiProvider(
      providers: [
        // Repository yang sekarang pakai local storage
        Provider<LocalSkillSwapRepository>(
          create: (_) => repository,
        ),
        Provider<LocalStorageService>.value(value: storage),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
        ChangeNotifierProvider(
          create: (_) => ProfilePhotoProvider(
            storage: storage,
            picker: CameraProfilePhotoPicker(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestProvider(
            repository: context.read<LocalSkillSwapRepository>(),
            requestApi: requestApi,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SentRequestProvider(api: requestApi),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingProvider(
            repository: context.read<LocalSkillSwapRepository>(),
          ),
        ),
        // Provider baru untuk mengelola data lokal (CRUD)
        ChangeNotifierProvider(
          create: (context) => LocalDataProvider(
            repository: context.read<LocalSkillSwapRepository>(),
          ),
        ),
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
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
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
