import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/skill_swap_request_record.dart';
import '../models/workflow_models.dart';

class SkillSwapRequestApiException implements Exception {
  const SkillSwapRequestApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class SkillSwapRequestDataSource {
  Future<List<Map<String, dynamic>>> getSentRequests(String senderId);
  Future<void> createRequest(Map<String, dynamic> request);
}

class FirestoreSkillSwapRequestDataSource
    implements SkillSwapRequestDataSource {
  FirestoreSkillSwapRequestDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<Map<String, dynamic>>> getSentRequests(String senderId) async {
    try {
      final snapshot = await _firestore
          .collection('requests')
          .where('sender_id', isEqualTo: senderId)
          .get();
      return snapshot.docs.map((document) {
        final data = document.data();
        final createdAt = data['created_at'];
        return {
          'id': document.id,
          ...data,
          if (createdAt is Timestamp) 'created_at': createdAt.toDate(),
        };
      }).toList();
    } on FirebaseException catch (error) {
      throw SkillSwapRequestApiException(_messageFor(error));
    }
  }

  @override
  Future<void> createRequest(Map<String, dynamic> request) async {
    try {
      await _firestore.collection('requests').add(request);
    } on FirebaseException catch (error) {
      throw SkillSwapRequestApiException(_messageFor(error));
    }
  }

  String _messageFor(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
      case 'unauthenticated':
        return 'Silakan masuk dengan akun Firebase sebelum mengakses request.';
      case 'unavailable':
      case 'deadline-exceeded':
      case 'network-request-failed':
        return 'Backend tidak dapat dijangkau. Periksa koneksi lalu coba lagi.';
      default:
        return 'Request gagal diproses oleh backend (${error.code}).';
    }
  }
}

class UnconfiguredSkillSwapRequestDataSource
    implements SkillSwapRequestDataSource {
  const UnconfiguredSkillSwapRequestDataSource();

  @override
  Future<List<Map<String, dynamic>>> getSentRequests(String senderId) =>
      Future.error(const SkillSwapRequestApiException(
        'Firebase belum dikonfigurasi. Tambahkan konfigurasi Firebase untuk memakai API request.',
      ));

  @override
  Future<void> createRequest(Map<String, dynamic> request) =>
      Future.error(const SkillSwapRequestApiException(
        'Firebase belum dikonfigurasi. Tambahkan konfigurasi Firebase untuk memakai API request.',
      ));
}

class SkillSwapRequestApi {
  SkillSwapRequestApi(this._dataSource);

  final SkillSwapRequestDataSource _dataSource;

  Future<List<SkillSwapRequestRecord>> getSentRequests(String senderId) async {
    try {
      final rows = await _dataSource.getSentRequests(senderId);
      final requests = rows.map(SkillSwapRequestRecord.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return requests;
    } on SkillSwapRequestApiException {
      rethrow;
    } on FormatException {
      rethrow;
    } catch (error) {
      throw SkillSwapRequestApiException(
        'Gagal memuat request dari backend: $error',
      );
    }
  }

  Future<void> createRequest({
    required String senderId,
    required SkillSwapRequestDraft request,
  }) async {
    if (senderId.trim().isEmpty) {
      throw const SkillSwapRequestApiException(
        'Akun Firebase diperlukan untuk mengirim request.',
      );
    }
    if (request.receiverId.trim().isEmpty ||
        request.receiverId == senderId ||
        request.teachSkill.trim().isEmpty ||
        request.learnSkill.trim().isEmpty ||
        request.message.trim().isEmpty ||
        request.message.trim().length > 300) {
      throw const FormatException('Data request tidak valid.');
    }
    try {
      await _dataSource.createRequest({
        'sender_id': senderId,
        'receiver_id': request.receiverId,
        'teach_skill_id': request.teachSkill,
        'learn_skill_id': request.learnSkill,
        'message': request.message.trim(),
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      });
    } on SkillSwapRequestApiException {
      rethrow;
    } catch (error) {
      throw SkillSwapRequestApiException(
        'Gagal menyimpan request ke backend: $error',
      );
    }
  }
}
