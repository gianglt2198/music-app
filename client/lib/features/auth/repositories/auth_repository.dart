import 'dart:convert';

import 'package:client/core/constants/constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  Future<Either<AppFailure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.baseUrl}/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 201) {
        return Left(AppFailure(body['detail']));
      }
      return Right(UserModel.fromMap(body));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      final body = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 201) {
        return Left(AppFailure(body['detail']));
      }
      return Right(UserModel.fromMap(body));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
