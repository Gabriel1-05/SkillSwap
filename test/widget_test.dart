// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:skillswap/main.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/providers/booking_provider.dart';
import 'package:skillswap/providers/discover_provider.dart';
import 'package:skillswap/providers/request_provider.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

void main() {
  testWidgets('renders the SkillSwap home screen', (WidgetTester tester) async {
    final repository = InMemorySkillSwapRepository();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SkillSwapRepository>.value(value: repository),
          ChangeNotifierProvider(create: (_) => DiscoverProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(
            create: (_) => RequestProvider(repository: repository),
          ),
          ChangeNotifierProvider(
            create: (_) => BookingProvider(repository: repository),
          ),
        ],
        child: const SkillSwapApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Halo, Gabriel.'), findsOneWidget);
    expect(find.text('Temukan'), findsOneWidget);
  });
}
