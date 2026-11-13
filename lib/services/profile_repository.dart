import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/utils/validators.dart';
import '../models/profile_details.dart';

abstract interface class ProfileRepository {
  Future<ProfileDetails> loadCurrentProfile();
  Future<void> saveCurrentProfile(ProfileDetails profile);
}

abstract interface class ProfileDataSource {
  Future<Map<String, dynamic>?> getProfile(String uid);
  Future<void> createProfile(String uid, Map<String, dynamic> profile);
  Future<void> updateProfile(String uid, Map<String, dynamic> fields);
}

abstract interface class ProfileIdentity {
  String? get uid;
  String? get email;
  String? get displayName;
}

class FirebaseProfileIdentity implements ProfileIdentity {
  FirebaseProfileIdentity(this._auth);

  final FirebaseAuth _auth;

  @override
  String? get uid => _auth.currentUser?.uid;

  @override
  String? get email => _auth.currentUser?.email;

  @override
  String? get displayName => _auth.currentUser?.displayName;
}

class ProfileRepositoryException implements Exception {
  const ProfileRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}

class FirestoreProfileDataSource implements ProfileDataSource {
  FirestoreProfileDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    try {
      final snapshot = await _firestore.collection('users').doc(uid).get();
      return snapshot.data();
    } on FirebaseException catch (error) {
      throw ProfileRepositoryException(_messageFor(error, writing: false));
    }
  }

  @override
  Future<void> createProfile(String uid, Map<String, dynamic> profile) async {
    try {
      await _firestore.collection('users').doc(uid).set(profile);
    } on FirebaseException catch (error) {
      throw ProfileRepositoryException(_messageFor(error, writing: true));
    }
  }

  @override
  Future<void> updateProfile(String uid, Map<String, dynamic> fields) async {
    try {
      await _firestore.collection('users').doc(uid).update(fields);
    } on FirebaseException catch (error) {
      throw ProfileRepositoryException(_messageFor(error, writing: true));
    }
  }

  String _messageFor(FirebaseException error, {required bool writing}) {
    if (error.code == 'permission-denied' || error.code == 'unauthenticated') {
      return 'Anda tidak memiliki akses ke profil ini.';
    }
    if (error.code == 'unavailable' || error.code == 'deadline-exceeded') {
      return 'Koneksi ke server bermasalah. Coba lagi saat jaringan tersedia.';
    }
    return writing ? 'Profil gagal disimpan.' : 'Profil gagal dimuat.';
  }
}

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository({
    required ProfileDataSource dataSource,
    required ProfileIdentity identity,
  })  : _dataSource = dataSource,
        _identity = identity;

  final ProfileDataSource _dataSource;
  final ProfileIdentity _identity;

  @override
  Future<ProfileDetails> loadCurrentProfile() async {
    final uid = _requireSignedInUser();
    try {
      final data = await _dataSource.getProfile(uid);
      if (data == null) return _newProfileDefaults();
      if (data['id'] != uid) {
        throw const FormatException('ID profil tidak cocok dengan akun.');
      }
      return ProfileDetails.fromMap(data);
    } on ProfileRepositoryException {
      rethrow;
    } on FormatException {
      throw const ProfileRepositoryException(
        'Data profil tidak lengkap. Periksa kembali data profil Anda.',
      );
    } on Object {
      throw const ProfileRepositoryException('Profil gagal dimuat.');
    }
  }

  @override
  Future<void> saveCurrentProfile(ProfileDetails profile) async {
    _validate(profile);
    final uid = _requireSignedInUser();
    final email = _identity.email?.trim();
    if (email == null || email.isEmpty) {
      throw const ProfileRepositoryException(
        'Akun Firebase perlu memiliki email untuk menyimpan profil.',
      );
    }

    try {
      final existing = await _dataSource.getProfile(uid);
      if (existing == null) {
        await _dataSource.createProfile(
          uid,
          profile.toNewDocument(uid: uid, email: email),
        );
      } else {
        await _dataSource.updateProfile(uid, profile.toEditableFields());
      }
    } on ProfileRepositoryException {
      rethrow;
    } on Object {
      throw const ProfileRepositoryException('Profil gagal disimpan.');
    }
  }

  String _requireSignedInUser() {
    final uid = _identity.uid?.trim();
    if (uid == null || uid.isEmpty) {
      throw const ProfileRepositoryException(
        'Silakan masuk terlebih dahulu untuk mengelola profil.',
      );
    }
    return uid;
  }

  ProfileDetails _newProfileDefaults() {
    final displayName = _identity.displayName?.trim() ?? '';
    final email = _identity.email?.trim() ?? '';
    final emailName = email.contains('@') ? email.split('@').first : '';
    return ProfileDetails(
      name: displayName.isNotEmpty ? displayName : emailName,
      university: '',
      major: '',
    );
  }

  void _validate(ProfileDetails profile) {
    final errors = [
      validateName(profile.name),
      validateUniversity(profile.university),
      validateMajor(profile.major),
    ].whereType<String>();
    if (errors.isNotEmpty) {
      throw ProfileRepositoryException(errors.first);
    }
  }
}
