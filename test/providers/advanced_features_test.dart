import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillswap/providers/booking_provider.dart';
import 'package:skillswap/providers/profile_photo_provider.dart';
import 'package:skillswap/services/local_storage_service.dart';
import 'package:skillswap/services/location_capture_service.dart';
import 'package:skillswap/services/profile_photo_service.dart';
import 'package:skillswap/services/skill_swap_repository.dart';

class _FakePhotoPicker implements ProfilePhotoPicker {
  _FakePhotoPicker(this.result);

  Uint8List? result;
  Object? error;

  @override
  Future<Uint8List?> capture() async {
    final failure = error;
    if (failure != null) throw failure;
    return result;
  }
}

class _FakeLocationService implements LocationCaptureService {
  _FakeLocationService(this.result);

  CapturedLocation? result;
  Object? error;

  @override
  Future<CapturedLocation> capture() async {
    final failure = error;
    if (failure != null) throw failure;
    return result!;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('camera photo is stored locally and restored by a new provider',
      () async {
    final picker = _FakePhotoPicker(Uint8List.fromList([1, 2, 3]));
    final storage = LocalStorageService(await SharedPreferences.getInstance());
    final provider = ProfilePhotoProvider(storage: storage, picker: picker);

    expect(await provider.capture(), isTrue);
    expect(provider.photoBytes, [1, 2, 3]);

    final reopened = ProfilePhotoProvider(
      storage: LocalStorageService(await SharedPreferences.getInstance()),
      picker: picker,
    );
    await reopened.load();

    expect(reopened.photoBytes, [1, 2, 3]);
  });

  test('cancelled camera picker leaves the profile unchanged', () async {
    final picker = _FakePhotoPicker(null);
    final provider = ProfilePhotoProvider(
      storage: LocalStorageService(await SharedPreferences.getInstance()),
      picker: picker,
    );

    expect(await provider.capture(), isFalse);
    expect(provider.photoBytes, isNull);
    expect(provider.errorMessage, isNull);
    expect(provider.isLoading, isFalse);
  });

  test('camera permission denial is shown without a silent fallback', () async {
    final picker = _FakePhotoPicker(null)
      ..error = PlatformException(code: 'camera_access_denied');
    final provider = ProfilePhotoProvider(
      storage: LocalStorageService(await SharedPreferences.getInstance()),
      picker: picker,
    );

    expect(await provider.capture(), isFalse);
    expect(provider.errorMessage, contains('Izin kamera ditolak'));
  });

  test('booking location is optional and user can clear a captured location',
      () async {
    final location = _FakeLocationService(
      const CapturedLocation(
        latitude: -6.2,
        longitude: 106.8,
        accuracyMeters: 20,
      ),
    );
    final provider = BookingProvider(
      repository: InMemorySkillSwapRepository(),
      locationService: location,
    );

    await provider.captureCurrentLocation();
    expect(provider.capturedLocation?.latitude, -6.2);
    expect(provider.locationErrorMessage, isNull);

    provider.clearCapturedLocation();
    expect(provider.capturedLocation, isNull);
  });

  test('location permission denial is visible and retryable', () async {
    final location = _FakeLocationService(null)
      ..error = const LocationCaptureException(
        'Izin lokasi ditolak. Lokasi opsional.',
      );
    final provider = BookingProvider(
      repository: InMemorySkillSwapRepository(),
      locationService: location,
    );

    await provider.captureCurrentLocation();

    expect(provider.capturedLocation, isNull);
    expect(provider.locationErrorMessage, contains('Izin lokasi ditolak'));
    expect(provider.isCapturingLocation, isFalse);
  });
}
