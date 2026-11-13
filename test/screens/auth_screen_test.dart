import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/auth_provider.dart';
import 'package:skillswap/screens/auth_screen.dart';

Widget _authApp({TransitionBuilder? builder}) => ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(builder: builder, home: const AuthScreen()),
    );

void main() {
  testWidgets('keeps the password field visible above the keyboard',
      (tester) async {
    tester.view.physicalSize = const Size(390, 560);
    tester.view.devicePixelRatio = 1;
    final keyboardInsets = ValueNotifier(EdgeInsets.zero);
    await tester.pumpWidget(_authApp(
      builder: (context, child) => ValueListenableBuilder(
        valueListenable: keyboardInsets,
        child: child,
        builder: (context, insets, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(viewInsets: insets),
          child: child!,
        ),
      ),
    ));
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

  testWidgets('registration UI uses the shared field validators',
      (tester) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(_authApp());
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(3));
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    expect(find.text('Nama harus 2 sampai 50 karakter.'), findsOneWidget);
    expect(find.text('Format email tidak valid.'), findsOneWidget);
    expect(find.text('Kata sandi minimal 8 karakter.'), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
