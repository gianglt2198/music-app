import 'dart:convert';

import 'package:client/core/constants/constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/core/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
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
      return Right(
          UserModel.fromMap(body['user']).copyWith(token: body['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUserData(String token) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.baseUrl}/auth/'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });

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
