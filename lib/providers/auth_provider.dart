import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../core/errors/app_exception.dart';
import '../models/view_state.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;
  User? user;
  ViewState state = ViewState.idle;
  String? errorMessage;

  Future<bool> login(String email, String password) => _run(() async {
        final credential = await _authService.login(email, password);
        user = credential.user;
      });

  Future<bool> register(String email, String password) => _run(() async {
        final credential = await _authService.register(email, password);
        user = credential.user;
      });

  Future<bool> sendPasswordReset(String email) => _run(() async {
        await _authService.sendPasswordReset(email);
      });

  Future<void> logout() async {
    await _authService.logout();
    user = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      state = ViewState.loaded;
      notifyListeners();
      return true;
    } on AppException catch (error) {
      state = ViewState.error;
      errorMessage = error.message;
      notifyListeners();
      return false;
    }
  }
}