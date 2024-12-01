import 'package:client/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _repository;
  bool isLoading = false;
  String? error;

  AuthController(this._repository);

  Future<bool> signUp(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _repository.signUp(email, password);
      isLoading = false;
      notifyListeners();
      return result;
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
      final result = await _repository.signIn(email, password);
      isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      isLoading = false;
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
