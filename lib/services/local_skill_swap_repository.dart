/// ============================================================
/// LOCAL SKILL SWAP REPOSITORY — Implementasi Persistence
/// ============================================================
/// Repository ini menggantikan InMemorySkillSwapRepository.
/// Semua operasi CRUD disimpan secara lokal menggunakan
/// LocalStorageService (shared_preferences) sehingga data
/// tetap tersedia setelah aplikasi ditutup dan dibuka kembali.
///
/// Lokasi kode:  lib/services/local_skill_swap_repository.dart
/// ============================================================
library;

import '../models/workflow_models.dart';
import 'local_storage_service.dart';
import 'skill_swap_repository.dart';

/// Key yang digunakan di shared_preferences
class StorageKeys {
  StorageKeys._();

  /// Collection untuk daftar kandidat permintaan skill swap
  static const String candidates = 'local_candidates';

  /// Collection untuk skill swap yang sudah diterima
  static const String acceptedSwaps = 'local_accepted_swaps';

  /// Collection untuk permintaan skill swap yang dibuat user (CREATE)
  static const String createdRequests = 'local_created_requests';

  /// Collection untuk booking sesi yang dibuat user (CREATE)
  static const String createdBookings = 'local_created_bookings';
}

/// Repository yang menyimpan data ke local storage (shared_preferences).
///
/// Data yang disimpan:
/// - Kandidat permintaan (seed data + data baru)
/// - Accepted skill swaps
/// - Request draft yang dibuat user
/// - Booking draft yang dibuat user
///
/// Semua data tetap persist setelah app di-restart.
class LocalSkillSwapRepository implements SkillSwapRepository {
  LocalSkillSwapRepository(this._storage);

  final LocalStorageService _storage;

  /// Seed data awal hanya ketika collection belum pernah dibuat.
  Future<void> initialize() async {
    if (!_storage.hasCollection(StorageKeys.candidates)) {
      const defaultCandidates = [
        RequestCandidate(
          id: 'seed_andi',
          name: 'Andi Pratama',
          teachSkillIds: ['python', 'data-science'],
        ),
        RequestCandidate(
          id: 'seed_sarah',
          name: 'Sarah',
          teachSkillIds: ['photoshop'],
        ),
        RequestCandidate(
          id: 'seed_kevin',
          name: 'Kevin',
          teachSkillIds: ['photoshop'],
        ),
      ];
      for (final candidate in defaultCandidates) {
        await _storage.addItem(StorageKeys.candidates, candidate.toJson());
      }
    }

    if (!_storage.hasCollection(StorageKeys.acceptedSwaps)) {
      const defaultAccepted = [
        AcceptedSkillSwap(
          id: 'accepted_andi_python',
          partnerName: 'Andi Pratama',
          skillId: 'python',
          skillName: 'Python',
          teacherId: 'seed_andi',
          learnerId: 'seed_gabriel',
        ),
      ];
      for (final swap in defaultAccepted) {
        await _storage.addItem(StorageKeys.acceptedSwaps, swap.toJson());
      }
    }
  }

  // ----- READ -----

  @override
  Future<List<RequestCandidate>> getRequestCandidates() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final items = _storage.getItems(StorageKeys.candidates);
    return items.map((json) => RequestCandidate.fromJson(json)).toList();
  }

  @override
  Future<List<AcceptedSkillSwap>> getAcceptedSkillSwaps() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final items = _storage.getItems(StorageKeys.acceptedSwaps);
    return items.map((json) => AcceptedSkillSwap.fromJson(json)).toList();
  }

  /// Membaca semua request yang sudah dibuat user dari local storage.
  @override
  Future<List<SkillSwapRequestDraft>> getCreatedRequests() async {
    final items = _storage.getItems(StorageKeys.createdRequests);
    return items.map((json) => SkillSwapRequestDraft.fromJson(json)).toList();
  }

  /// Membaca semua booking yang sudah dibuat user dari local storage.
  @override
  Future<List<SessionBookingDraft>> getCreatedBookings() async {
    final items = _storage.getItems(StorageKeys.createdBookings);
    return items.map((json) => SessionBookingDraft.fromJson(json)).toList();
  }

  // ----- CREATE -----

  @override
  Future<void> createRequest(SkillSwapRequestDraft request) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    await _storage.addItem(StorageKeys.createdRequests, request.toJson());
  }

  @override
  Future<void> createBooking(SessionBookingDraft booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _validateBooking(booking);
    await _storage.addItem(StorageKeys.createdBookings, booking.toJson());
  }

  void _validateBooking(SessionBookingDraft booking) {
    if (!booking.endTime.isAfter(booking.startTime)) {
      throw const FormatException('Waktu selesai harus setelah waktu mulai.');
    }
    final uri = Uri.tryParse(booking.meetingLink);
    if (booking.mode == 'online' &&
        (uri == null ||
            !uri.hasAuthority ||
            !['http', 'https'].contains(uri.scheme))) {
      throw const FormatException('Tautan meeting tidak valid.');
    }
  }

  // ----- UPDATE -----

  /// Memperbarui request pada index tertentu di local storage.
  @override
  Future<void> updateRequest(int index, SkillSwapRequestDraft request) async {
    await _storage.updateItem(
        StorageKeys.createdRequests, index, request.toJson());
  }

  /// Memperbarui booking pada index tertentu di local storage.
  @override
  Future<void> updateBooking(int index, SessionBookingDraft booking) async {
    _validateBooking(booking);
    await _storage.updateItem(
        StorageKeys.createdBookings, index, booking.toJson());
  }

  // ----- DELETE -----

  /// Menghapus request pada index tertentu dari local storage.
  @override
  Future<void> deleteRequest(int index) async {
    await _storage.deleteItem(StorageKeys.createdRequests, index);
  }

  /// Menghapus booking pada index tertentu dari local storage.
  @override
  Future<void> deleteBooking(int index) async {
    await _storage.deleteItem(StorageKeys.createdBookings, index);
  }

  // ----- CLEAR ALL -----

  /// Menghapus semua data lokal (untuk testing/reset).
  @override
  Future<void> clearAllData() async {
    await _storage.clearCollection(StorageKeys.candidates);
    await _storage.clearCollection(StorageKeys.acceptedSwaps);
    await _storage.clearCollection(StorageKeys.createdRequests);
    await _storage.clearCollection(StorageKeys.createdBookings);
  }
}
