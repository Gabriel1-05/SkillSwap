import 'package:flutter/foundation.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../services/skill_swap_request_api.dart';
import '../services/skill_swap_repository.dart';

class RequestProvider extends ChangeNotifier {
  RequestProvider({
    required SkillSwapRepository repository,
    SkillSwapRequestApi? requestApi,
  })  : _repository = repository,
        _requestApi = requestApi;

  final SkillSwapRepository _repository;
  final SkillSwapRequestApi? _requestApi;
  bool get requiresAuthentication => _requestApi != null;
  SkillSwapRequestApi? get requestApi => _requestApi;
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

  Future<bool> submitRequest(
    SkillSwapRequestDraft request, {
    String? senderId,
  }) async {
    if (isSubmitting) return false;
    isSubmitting = true;
    submitError = null;
    didSubmit = false;
    notifyListeners();
    try {
      final requestApi = _requestApi;
      if (requestApi == null) {
        await _repository.createRequest(request);
      } else {
        await requestApi.createRequest(senderId: senderId ?? '', request: request);
      }
      didSubmit = true;
      return true;
    } on SkillSwapRequestApiException catch (error) {
      submitError = error.message;
      return false;
    } on FormatException catch (error) {
      submitError = error.message;
      return false;
    } catch (_) {
      submitError = 'Permintaan gagal dikirim. Silakan coba lagi.';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
