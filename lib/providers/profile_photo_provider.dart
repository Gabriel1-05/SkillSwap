import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../services/local_storage_service.dart';
import '../services/profile_photo_service.dart';

class ProfilePhotoProvider extends ChangeNotifier {
  ProfilePhotoProvider({
    required LocalStorageService storage,
    required ProfilePhotoPicker picker,
  })  : _storage = storage,
        _picker = picker;

  static const _storageKey = 'profile_photo_jpeg_base64';
  static const _maxPhotoBytes = 256 * 1024;

  final LocalStorageService _storage;
  final ProfilePhotoPicker _picker;

  Uint8List? photoBytes;
  bool isLoading = false;
  String? errorMessage;
  String? statusMessage;

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();
    try {
      final encoded = _storage.getString(_storageKey);
      photoBytes = encoded == null ? null : base64Decode(encoded);
    } on FormatException catch (error) {
      errorMessage = 'Foto profil lokal tidak valid: ${error.message}';
    } on Object catch (error) {
      errorMessage = 'Foto profil gagal dimuat: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> capture() async {
    if (isLoading) return false;
    isLoading = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();
    try {
      final image = await _picker.capture();
      if (image == null) {
        statusMessage = 'Pemilihan foto dibatalkan; foto tidak diubah.';
        return false;
      }
      if (image.lengthInBytes > _maxPhotoBytes) {
        errorMessage =
            'Foto terlalu besar. Ambil ulang dengan resolusi lebih kecil.';
        return false;
      }
      await _storage.setString(_storageKey, base64Encode(image));
      photoBytes = Uint8List.fromList(image);
      statusMessage = 'Foto profil berhasil disimpan di perangkat ini.';
      return true;
    } on PlatformException catch (error) {
      errorMessage = switch (error.code) {
        'camera_access_denied' ||
        'cameraPermission' =>
          'Izin kamera ditolak. Izinkan kamera di pengaturan browser/perangkat lalu coba lagi.',
        _ => 'Kamera tidak dapat digunakan. Periksa izin lalu coba lagi.',
      };
      return false;
    } on Object catch (error) {
      errorMessage = 'Foto profil gagal disimpan: $error';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removePhoto() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();
    try {
      await _storage.remove(_storageKey);
      photoBytes = null;
      statusMessage = 'Foto profil lokal berhasil dihapus.';
    } on Object catch (error) {
      errorMessage = 'Foto profil gagal dihapus: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
