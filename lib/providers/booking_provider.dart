import 'package:flutter/foundation.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../services/skill_swap_repository.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({required SkillSwapRepository repository})
      : _repository = repository;

  final SkillSwapRepository _repository;
  List<AcceptedSkillSwap> acceptedSkillSwaps = [];
  ViewState state = ViewState.idle;
  bool isSubmitting = false;
  String? errorMessage;
  String? submitError;
  bool didSubmit = false;

  Future<void> loadAcceptedSkillSwaps() async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      acceptedSkillSwaps = await _repository.getAcceptedSkillSwaps();
      state = acceptedSkillSwaps.isEmpty ? ViewState.empty : ViewState.loaded;
    } catch (_) {
      state = ViewState.error;
      errorMessage = 'Permintaan diterima belum dapat dimuat.';
    }
    notifyListeners();
  }

  Future<bool> submitBooking(SessionBookingDraft booking) async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    didSubmit = false;
    notifyListeners();
    try {
      await _repository.createBooking(booking);
      didSubmit = true;
      return true;
    } catch (error) {
      submitError = error is FormatException
          ? error.message
          : 'Jadwal sesi gagal disimpan. Silakan coba lagi.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
