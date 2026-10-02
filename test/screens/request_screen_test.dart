import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:skillswap/providers/discover_provider.dart';
import 'package:skillswap/providers/request_provider.dart';
import 'package:skillswap/screens/request_screen.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

import '../fakes/workflow_test_repository.dart';

Widget _requestApp(WorkflowTestRepository repository) => MultiProvider(
      providers: [
        Provider<SkillSwapRepository>.value(value: repository),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
        ChangeNotifierProvider(
          create: (_) => RequestProvider(repository: repository),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: RequestScreen())),
    );

void main() {
  testWidgets('shows initial loading and then loaded candidate data',
      (tester) async {
    final repository = WorkflowTestRepository()
      ..candidateLoadGate = Completer();
    await tester.pumpWidget(_requestApp(repository));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repository.candidateLoadGate!.complete(repository.candidates);
    await tester.pumpAndSettle();

    expect(find.text('Andi Pratama'), findsOneWidget);
    expect(
        find.widgetWithText(FilledButton, 'Kirim permintaan'), findsOneWidget);
  });

  testWidgets('shows empty state when repository has no candidates',
      (tester) async {
    final repository = WorkflowTestRepository()..candidates = const [];
    await tester.pumpWidget(_requestApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada teman yang bisa diajak bertukar skill.'),
        findsOneWidget);
  });

  testWidgets('shows an error and retries candidate loading', (tester) async {
    final repository = WorkflowTestRepository()..candidateLoadFailures = 1;
    await tester.pumpWidget(_requestApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Rekomendasi belum dapat dimuat.'), findsOneWidget);
    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(find.text('Andi Pratama'), findsOneWidget);
  });

  testWidgets('validates the required request message', (tester) async {
    final repository = WorkflowTestRepository();
    await tester.pumpWidget(_requestApp(repository));
    await tester.pumpAndSettle();
    final submitButton = find.widgetWithText(FilledButton, 'Kirim permintaan');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Pesan tidak boleh kosong.'), findsOneWidget);
    expect(repository.requests, isEmpty);
  });

  testWidgets('disables submit while a request is being sent', (tester) async {
    final repository = WorkflowTestRepository()
      ..requestSubmitGate = Completer<void>();
    await tester.pumpWidget(_requestApp(repository));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Ayo belajar bareng!');
    final submitButton = find.widgetWithText(FilledButton, 'Kirim permintaan');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    expect(find.text('Mengirim...'), findsOneWidget);
    final submit = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(submit.onPressed, isNull);
    expect(repository.requests, isEmpty);

    repository.requestSubmitGate!.complete();
    await tester.pumpAndSettle();
    expect(find.text('Permintaan terkirim.'), findsOneWidget);
    expect(repository.requests, hasLength(1));
  });
}
