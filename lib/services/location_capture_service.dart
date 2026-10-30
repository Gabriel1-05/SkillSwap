import 'dart:async';

import 'package:geolocator/geolocator.dart';

class CapturedLocation {
  const CapturedLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;
}

class LocationCaptureException implements Exception {
  const LocationCaptureException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class LocationCaptureService {
  Future<CapturedLocation> capture();
}

class GeolocatorLocationCaptureService implements LocationCaptureService {
  const GeolocatorLocationCaptureService();

  @override
  Future<CapturedLocation> capture() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationCaptureException(
        'Layanan lokasi mati. Aktifkan lokasi, lalu coba lagi.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationCaptureException(
        'Izin lokasi ditolak. Lokasi opsional; izinkan jika ingin menyimpannya.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationCaptureException(
        'Izin lokasi diblokir. Ubah izin lokasi di pengaturan browser/perangkat.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return CapturedLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      );
    } on LocationServiceDisabledException {
      throw const LocationCaptureException(
        'Layanan lokasi mati. Aktifkan lokasi, lalu coba lagi.',
      );
    } on PermissionDeniedException {
      throw const LocationCaptureException(
        'Izin lokasi ditolak. Lokasi opsional; izinkan jika ingin menyimpannya.',
      );
    } on TimeoutException {
      throw const LocationCaptureException(
        'Lokasi belum berhasil didapat. Coba lagi atau lanjut tanpa lokasi.',
      );
    }
  }
}
