import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skillswap/models/skill_swap_request_record.dart';
import 'package:skillswap/models/workflow_models.dart';
import 'package:skillswap/services/skill_swap_request_api.dart';

final _now = DateTime.utc(2025, 1, 2, 3, 4);

Map<String, dynamic> _validJson({
  String id = 'request-1',
  DateTime? createdAt,
}) =>
    {
      'id': id,
      'sender_id': 'sender-1',
      'receiver_id': 'receiver-1',
      'teach_skill_id': 'ui-ux',
      'learn_skill_id': 'python',
      'message': 'Ayo belajar bersama.',
      'status': 'pending',
      'created_at': createdAt ?? _now,
    };

class _FakeRequestDataSource implements SkillSwapRequestDataSource {
  _FakeRequestDataSource({this.rows = const []});

  List<Map<String, dynamic>> rows;
  Object? readError;
  Map<String, dynamic>? createdRequest;

  @override
  Future<List<Map<String, dynamic>>> getSentRequests(String senderId) async {
    final error = readError;
    if (error != null) throw error;
    return rows;
  }

  @override
  Future<void> createRequest(Map<String, dynamic> request) async {
    createdRequest = request;
  }
}

void main() {
  group('SkillSwapRequestRecord', () {
    test('parses a valid backend model', () {
      final record = SkillSwapRequestRecord.fromJson(_validJson());

      expect(record.id, 'request-1');
      expect(record.senderId, 'sender-1');
      expect(record.createdAt, _now);
      expect(record.toJson()['status'], 'pending');
    });

    test('rejects an invalid backend model', () {
      final invalid = _validJson()..['sender_id'] = ' ';

      expect(
        () => SkillSwapRequestRecord.fromJson(invalid),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('SkillSwapRequestApi', () {
    test('loads valid requests and orders newest first', () async {
      final dataSource = _FakeRequestDataSource(rows: [
        _validJson(id: 'older', createdAt: _now),
        _validJson(
          id: 'newer',
          createdAt: _now.add(const Duration(hours: 1)),
        ),
      ]);
      final api = SkillSwapRequestApi(dataSource);

      final requests = await api.getSentRequests('sender-1');

      expect(requests.map((request) => request.id), ['newer', 'older']);
    });

    test('returns an empty list when the backend has no data', () async {
      final api = SkillSwapRequestApi(_FakeRequestDataSource());

      expect(await api.getSentRequests('sender-1'), isEmpty);
    });

    test('maps a Firestore unavailable error to an API failure', () async {
      final dataSource = _FakeRequestDataSource()
        ..readError = FirebaseException(
          plugin: 'cloud_firestore',
          code: 'unavailable',
          message: 'The service is currently unavailable.',
        );
      final api = SkillSwapRequestApi(dataSource);

      await expectLater(
        api.getSentRequests('sender-1'),
        throwsA(
          isA<SkillSwapRequestApiException>().having(
            (error) => error.message,
            'message',
            contains('Gagal memuat request dari backend'),
          ),
        ),
      );
    });

    test('rejects malformed backend JSON', () async {
      final api = SkillSwapRequestApi(
        _FakeRequestDataSource(rows: [
          _validJson()..['created_at'] = 'not-a-date',
        ]),
      );

      await expectLater(
        api.getSentRequests('sender-1'),
        throwsA(isA<FormatException>()),
      );
    });

    test('creates a validated request in the backend data source', () async {
      final dataSource = _FakeRequestDataSource();
      final api = SkillSwapRequestApi(dataSource);

      await api.createRequest(
        senderId: 'sender-1',
        request: const SkillSwapRequestDraft(
          receiverId: 'receiver-1',
          teachSkill: 'ui-ux',
          learnSkill: 'python',
          message: 'Ayo belajar bersama.',
        ),
      );

      expect(dataSource.createdRequest?['sender_id'], 'sender-1');
      expect(dataSource.createdRequest?['receiver_id'], 'receiver-1');
      expect(dataSource.createdRequest?['status'], 'pending');
    });
  });
}
