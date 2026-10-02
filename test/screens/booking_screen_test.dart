import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/booking_provider.dart';
import 'package:skillswap/screens/booking_screen.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

import '../fakes/workflow_test_repository.dart';

Widget _bookingApp(WorkflowTestRepository repository) => MultiProvider(
      providers: [
        Provider<SkillSwapRepository>.value(value: repository),
        ChangeNotifierProvider(
          create: (_) => BookingProvider(repository: repository),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        home: const Scaffold(body: BookingScreen()),
      ),
    );

void main() {
  testWidgets('shows initial loading and then accepted request data',
      (tester) async {
    final repository = WorkflowTestRepository()..bookingLoadGate = Completer();
    await tester.pumpWidget(_bookingApp(repository));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.bookingLoadGate!.complete(repository.acceptedSkillSwaps);
    await tester.pumpAndSettle();

    expect(find.text('Andi Pratama · Python'), findsOneWidget);
    expect(find.text('Buat jadwal sesi'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no accepted requests',
      (tester) async {
    final repository = WorkflowTestRepository()..acceptedSkillSwaps = const [];
    await tester.pumpWidget(_bookingApp(repository));
    await tester.pumpAndSettle();

    expect(
      find.text('Belum ada permintaan yang diterima untuk dijadwalkan.'),
      findsOneWidget,
    );
  });

  testWidgets('shows an error and retries accepted request loading',
      (tester) async {
    final repository = WorkflowTestRepository()..bookingLoadFailures = 1;
    await tester.pumpWidget(_bookingApp(repository));
    await tester.pumpAndSettle();

    expect(
        find.text('Permintaan diterima belum dapat dimuat.'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(find.text('Andi Pratama · Python'), findsOneWidget);
  });

  testWidgets('validates required date and time fields', (tester) async {
    final repository = WorkflowTestRepository();
    await tester.pumpWidget(_bookingApp(repository));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Buat jadwal sesi'));
    await tester.tap(find.text('Buat jadwal sesi'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih tanggal sesi.'), findsOneWidget);
    expect(find.text('Pilih jam.'), findsNWidgets(2));
    expect(repository.bookings, isEmpty);
  });

  testWidgets('disables submit while booking is being saved', (tester) async {
    final repository = WorkflowTestRepository()
      ..bookingSubmitGate = Completer<void>();
    await tester.pumpWidget(_bookingApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('booking-date')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('booking-start-time')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('booking-end-time')));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextButton).last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('booking-meeting-link')),
      'https://meet.google.com/abc-defg-hij',
    );
    await tester.ensureVisible(find.text('Buat jadwal sesi'));
    await tester.tap(find.text('Buat jadwal sesi'));
    await tester.pump();

    expect(find.text('Menyimpan jadwal...'), findsOneWidget);
    final submit = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(submit.onPressed, isNull);
    expect(repository.bookings, isEmpty);

    repository.bookingSubmitGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Sesi berhasil dijadwalkan.'), findsOneWidget);
    expect(repository.bookings, hasLength(1));
  });
}
