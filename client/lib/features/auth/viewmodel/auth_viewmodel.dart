import 'package:client/features/auth/models/user_model.dart';
import 'package:client/features/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  final AuthRepository _authRepository = AuthRepository();

  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRepository.signUp(
        email: email, password: password, name: name);

    final val = switch (res) {
      Left(value: final l) => state = AsyncValue.error(l, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };

    print(val);
  }
}
