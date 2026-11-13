import 'package:flutter/foundation.dart';

import '../models/profile_details.dart';
import '../services/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider({required ProfileRepository repository})
      : _repository = repository;

  final ProfileRepository _repository;

  ProfileDetails? profile;
  bool isLoading = false;
  bool isSaving = false;
  String? errorMessage;
  String? statusMessage;
  String? _loadedForUid;
  String? _attemptedUid;
  int _accountGeneration = 0;
  int _loadGeneration = 0;

  Future<void> loadCurrentProfile(
    String uid, {
    bool force = false,
  }) async {
    if (uid.trim().isEmpty) {
      clear();
      return;
    }
    if (isLoading && _attemptedUid == uid) return;
    if (!force && _attemptedUid == uid && _loadedForUid == uid) return;

    final accountGeneration = _accountGeneration;
    final loadGeneration = ++_loadGeneration;
    _attemptedUid = uid;
    isLoading = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();

    try {
      final loadedProfile = await _repository.loadCurrentProfile();
      if (accountGeneration != _accountGeneration ||
          loadGeneration != _loadGeneration) {
        return;
      }
      profile = loadedProfile;
      _loadedForUid = uid;
    } on ProfileRepositoryException catch (error) {
      if (accountGeneration != _accountGeneration ||
          loadGeneration != _loadGeneration) {
        return;
      }
      profile = null;
      _loadedForUid = null;
      errorMessage = error.message;
    } on Object {
      if (accountGeneration != _accountGeneration ||
          loadGeneration != _loadGeneration) {
        return;
      }
      profile = null;
      _loadedForUid = null;
      errorMessage = 'Profil gagal dimuat. Coba lagi.';
    } finally {
      if (accountGeneration == _accountGeneration &&
          loadGeneration == _loadGeneration) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> saveCurrentProfile(String uid, ProfileDetails details) async {
    if (isSaving || uid.trim().isEmpty) return false;
    final accountGeneration = _accountGeneration;
    isSaving = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();

    try {
      await _repository.saveCurrentProfile(details);
      if (accountGeneration != _accountGeneration) return false;
      profile = details;
      _loadedForUid = uid;
      _attemptedUid = uid;
      statusMessage = 'Profil berhasil disimpan.';
      return true;
    } on ProfileRepositoryException catch (error) {
      if (accountGeneration == _accountGeneration) {
        errorMessage = error.message;
      }
      return false;
    } on Object {
      if (accountGeneration == _accountGeneration) {
        errorMessage = 'Profil gagal disimpan. Coba lagi.';
      }
      return false;
    } finally {
      if (accountGeneration == _accountGeneration) {
        isSaving = false;
        notifyListeners();
      }
    }
  }

  void clear() {
    _accountGeneration++;
    _loadGeneration++;
    _loadedForUid = null;
    _attemptedUid = null;
    profile = null;
    isLoading = false;
    isSaving = false;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();
  }
}
