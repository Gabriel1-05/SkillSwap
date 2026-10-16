import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/models/workflow_models.dart';
import 'package:skillswap/providers/local_data_provider.dart';
import 'package:skillswap/screens/local_data_screen.dart';

import '../fakes/workflow_test_repository.dart';

Widget _localDataApp(WorkflowTestRepository repository) =>
    ChangeNotifierProvider(
      create: (_) => LocalDataProvider(repository: repository),
      child: const MaterialApp(
        home: Scaffold(body: LocalDataScreen()),
      ),
    );

void main() {
  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  testWidgets('request records can be edited and deleted from local data',
      (tester) async {
    final repository = WorkflowTestRepository()
      ..requests.add(const SkillSwapRequestDraft(
        receiverId: 'andi',
        teachSkill: 'ui-ux',
        learnSkill: 'python',
        message: 'Belajar bersama',
      ));
    await tester.pumpWidget(_localDataApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Jadwal diperbarui');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(repository.requests.single.message, 'Jadwal diperbarui');

    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(repository.requests, isEmpty);
  });

  testWidgets('booking records can be edited and deleted from local data',
      (tester) async {
    final booking = SessionBookingDraft(
      requestId: 'accepted-1',
      skillId: 'python',
      teacherId: 'andi',
      learnerId: 'gabriel',
      date: DateTime(2026, 10, 20),
      startTime: DateTime(2026, 10, 20, 9),
      endTime: DateTime(2026, 10, 20, 10),
      mode: 'online',
      meetingLink: 'https://meet.google.com/abc-defg-hij',
    );
    final repository = WorkflowTestRepository()..bookings.add(booking);
    await tester.pumpWidget(_localDataApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Booking (1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).last,
      'https://meet.google.com/new-link',
    );
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(repository.bookings.single.meetingLink,
        'https://meet.google.com/new-link');

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(repository.bookings, isEmpty);
  });
}
