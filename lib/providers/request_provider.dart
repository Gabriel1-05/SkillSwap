import 'package:flutter/foundation.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../services/skill_swap_repository.dart';

class RequestProvider extends ChangeNotifier {
  RequestProvider({required SkillSwapRepository repository})
      : _repository = repository;

  final SkillSwapRepository _repository;
  List<RequestCandidate> candidates = [];
  ViewState state = ViewState.idle;
  bool isSubmitting = false;
  String? errorMessage;
  String? submitError;
  bool didSubmit = false;

  Future<void> loadCandidates() async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      candidates = await _repository.getRequestCandidates();
      state = candidates.isEmpty ? ViewState.empty : ViewState.loaded;
    } catch (_) {
      state = ViewState.error;
      errorMessage = 'Rekomendasi belum dapat dimuat.';
    }
    notifyListeners();
  }

  Future<bool> submitRequest(SkillSwapRequestDraft request) async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    didSubmit = false;
    notifyListeners();
    try {
      await _repository.createRequest(request);
      didSubmit = true;
      return true;
    } catch (_) {
      submitError = 'Permintaan gagal dikirim. Silakan coba lagi.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
