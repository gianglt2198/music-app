import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthRemoteRepository _repository;
  bool isLoading = false;
  String? error;

  AuthController(this._repository);

  Future<bool> signUp(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // final result = await _repository.signUp();
      isLoading = false;
      notifyListeners();
      // return result;
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // final result = await _repository.signIn(email, password);
      isLoading = false;
      notifyListeners();
      // return result;
      return true;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
