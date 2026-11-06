// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skillswap/main.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/providers/booking_provider.dart';
import 'package:skillswap/providers/discover_provider.dart';
import 'package:skillswap/providers/local_data_provider.dart';
import 'package:skillswap/providers/profile_photo_provider.dart';
import 'package:skillswap/providers/request_provider.dart';
import 'package:skillswap/services/local_storage_service.dart';
import 'package:skillswap/services/profile_photo_service.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

void main() {
  testWidgets('renders the SkillSwap home screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = InMemorySkillSwapRepository();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SkillSwapRepository>.value(value: repository),
          ChangeNotifierProvider(create: (_) => DiscoverProvider()),
          ChangeNotifierProvider(
            create: (_) => ProfilePhotoProvider(
              storage: LocalStorageService(preferences),
              picker: CameraProfilePhotoPicker(),
            ),
          ),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(
            create: (_) => RequestProvider(repository: repository),
          ),
          ChangeNotifierProvider(
            create: (_) => BookingProvider(repository: repository),
          ),
          ChangeNotifierProvider(
            create: (_) => LocalDataProvider(repository: repository),
          ),
        ],
        child: const SkillSwapApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Halo, Gabriel.'), findsOneWidget);
    expect(find.text('Temukan'), findsOneWidget);
  });

  testWidgets('adapts navigation for narrow and wide layouts',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = InMemorySkillSwapRepository();

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SkillSwapRepository>.value(value: repository),
          ChangeNotifierProvider(create: (_) => DiscoverProvider()),
          ChangeNotifierProvider(
            create: (_) => ProfilePhotoProvider(
              storage: LocalStorageService(preferences),
              picker: CameraProfilePhotoPicker(),
            ),
          ),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(
            create: (_) => RequestProvider(repository: repository),
          ),
          ChangeNotifierProvider(
            create: (_) => BookingProvider(repository: repository),
          ),
          ChangeNotifierProvider(
            create: (_) => LocalDataProvider(repository: repository),
          ),
        ],
        child: const SkillSwapApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Data Lokal'));
    await tester.pumpAndSettle();
    expect(
      find.text('Persistence aktif — data bertahan setelah refresh/restart'),
      findsOneWidget,
    );
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.platformDispatcher.clearTextScaleFactorTestValue();

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
