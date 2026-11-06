import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/screens/auth_screen.dart';

void main() {
  testWidgets('keeps the password field visible above the keyboard',
      (tester) async {
    tester.view.physicalSize = const Size(390, 560);
    tester.view.devicePixelRatio = 1;
    final keyboardInsets = ValueNotifier(EdgeInsets.zero);
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          builder: (context, child) => ValueListenableBuilder(
            valueListenable: keyboardInsets,
            child: child,
            builder: (context, insets, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(viewInsets: insets),
              child: child!,
            ),
          ),
          home: const AuthScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(tester.takeException(), isNull);
    final passwordField = find.byType(TextFormField).last;
    await tester.showKeyboard(passwordField);
    keyboardInsets.value = const EdgeInsets.only(bottom: 300);
    await tester.pumpAndSettle();

    expect(tester.getRect(passwordField).bottom, lessThanOrEqualTo(260));
    expect(tester.takeException(), isNull);
    keyboardInsets.dispose();
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
