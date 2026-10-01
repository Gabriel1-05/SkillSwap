import 'package:firebase_auth/firebase_auth.dart';

import '../core/errors/app_exception.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _providedAuth = auth;

  final FirebaseAuth? _providedAuth;

  FirebaseAuth get _auth => _providedAuth ?? FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AppException(error.code, _mapError(error.code));
    } catch (_) {
      throw const AppException('unknown', 'Terjadi kesalahan, silakan coba lagi.');
    }
  }

  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AppException(error.code, _mapError(error.code));
    } catch (_) {
      throw const AppException('unknown', 'Terjadi kesalahan, silakan coba lagi.');
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      throw AppException(error.code, _mapError(error.code));
    }
  }

  Future<void> logout() => _auth.signOut();

  String _mapError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Email atau kata sandi salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar, silakan login.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah, minimal 8 karakter.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan, coba lagi beberapa saat.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah, coba lagi.';
      default:
        return 'Terjadi kesalahan, silakan coba lagi.';
    }
  }
}