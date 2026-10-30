import 'package:flutter/foundation.dart';

import '../models/view_state.dart';
import '../models/workflow_models.dart';
import '../services/location_capture_service.dart';
import '../services/skill_swap_repository.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({
    required SkillSwapRepository repository,
    LocationCaptureService locationService =
        const GeolocatorLocationCaptureService(),
  })  : _repository = repository,
        _locationService = locationService;

  final SkillSwapRepository _repository;
  final LocationCaptureService _locationService;
  List<AcceptedSkillSwap> acceptedSkillSwaps = [];
  ViewState state = ViewState.idle;
  bool isSubmitting = false;
  bool isCapturingLocation = false;
  CapturedLocation? capturedLocation;
  String? errorMessage;
  String? submitError;
  String? locationErrorMessage;
  bool didSubmit = false;

  Future<void> captureCurrentLocation() async {
    if (isCapturingLocation || isSubmitting) return;
    isCapturingLocation = true;
    locationErrorMessage = null;
    notifyListeners();
    try {
      capturedLocation = await _locationService.capture();
    } on LocationCaptureException catch (error) {
      locationErrorMessage = error.message;
    } on Object catch (error) {
      locationErrorMessage = 'Lokasi gagal didapat: $error';
    } finally {
      isCapturingLocation = false;
      notifyListeners();
    }
  }

  void clearCapturedLocation() {
    capturedLocation = null;
    locationErrorMessage = null;
    notifyListeners();
  }

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
