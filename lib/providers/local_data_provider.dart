/// ============================================================
/// LOCAL DATA PROVIDER — State Management untuk Local Persistence
/// ============================================================
/// Provider ini mengelola state operasi CRUD pada data lokal.
/// Digunakan oleh halaman Riwayat untuk membaca, mengedit, dan
/// menghapus data request & booking yang tersimpan secara lokal.
///
/// Lokasi kode:  lib/providers/local_data_provider.dart
/// ============================================================
library;

import 'package:flutter/foundation.dart';

import '../models/workflow_models.dart';
import '../services/skill_swap_repository.dart';

class LocalDataProvider extends ChangeNotifier {
  LocalDataProvider({required SkillSwapRepository repository})
      : _repository = repository;

  final SkillSwapRepository _repository;

  List<SkillSwapRequestDraft> requests = [];
  List<SessionBookingDraft> bookings = [];
  bool isLoading = false;
  String? errorMessage;

  // ===== READ =====
  /// Memuat semua data request & booking dari local storage.
  Future<void> loadAll() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      requests = await _repository.getCreatedRequests();
      bookings = await _repository.getCreatedBookings();
    } catch (error) {
      errorMessage = 'Data lokal gagal dimuat: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===== UPDATE =====
  /// Memperbarui request pada index tertentu.
  Future<void> updateRequest(int index, SkillSwapRequestDraft request) =>
      _runMutation(
        () => _repository.updateRequest(index, request),
        'Permintaan gagal diperbarui',
      );

  /// Memperbarui booking pada index tertentu.
  Future<void> updateBooking(int index, SessionBookingDraft booking) =>
      _runMutation(
        () => _repository.updateBooking(index, booking),
        'Booking gagal diperbarui',
      );

  // ===== DELETE =====
  /// Menghapus request pada index tertentu.
  Future<void> deleteRequest(int index) => _runMutation(
        () => _repository.deleteRequest(index),
        'Permintaan gagal dihapus',
      );

  /// Menghapus booking pada index tertentu.
  Future<void> deleteBooking(int index) => _runMutation(
        () => _repository.deleteBooking(index),
        'Booking gagal dihapus',
      );

  // ===== CLEAR ALL =====
  /// Menghapus seluruh data lokal (reset).
  Future<void> clearAllData() => _runMutation(
        _repository.clearAllData,
        'Data lokal gagal dihapus',
      );

  Future<void> _runMutation(
    Future<void> Function() mutation,
    String failureMessage,
  ) async {
    errorMessage = null;
    String? mutationError;
    try {
      await mutation();
    } catch (error) {
      mutationError = '$failureMessage: $error';
    }
    await loadAll();
    if (mutationError != null) {
      errorMessage = mutationError;
      notifyListeners();
    }
  }
}
