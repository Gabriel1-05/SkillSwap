import 'package:flutter/foundation.dart';

import '../models/skill_swap_request_record.dart';
import '../models/view_state.dart';
import '../services/skill_swap_request_api.dart';

class SentRequestProvider extends ChangeNotifier {
  SentRequestProvider({required SkillSwapRequestApi api}) : _api = api;

  final SkillSwapRequestApi _api;
  List<SkillSwapRequestRecord> requests = [];
  ViewState state = ViewState.idle;
  String? errorMessage;

  Future<void> load(String? senderId) async {
    if (senderId == null || senderId.trim().isEmpty) {
      state = ViewState.error;
      errorMessage = 'Masuk dengan akun Firebase untuk memuat request.';
      notifyListeners();
      return;
    }
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      requests = await _api.getSentRequests(senderId);
      state = requests.isEmpty ? ViewState.empty : ViewState.loaded;
    } on FormatException catch (error) {
      state = ViewState.error;
      errorMessage = 'Data dari backend tidak valid: ${error.message}';
    } on SkillSwapRequestApiException catch (error) {
      state = ViewState.error;
      errorMessage = error.message;
    } catch (error) {
      state = ViewState.error;
      errorMessage = 'Request gagal dimuat: $error';
    }
    notifyListeners();
  }
}
