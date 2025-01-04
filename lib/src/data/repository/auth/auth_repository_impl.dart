import 'package:haimdall/src/common/alias/alias.dart';
import 'package:haimdall/src/common/either/either.dart';
import 'package:haimdall/src/data/network/network.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  late final AuthApi _authApi;

  AuthRepositoryImpl({required AuthApi authApi}) {
    _authApi = authApi;
  }

  @override
  Future<Result<Map<String, dynamic>>> loginWithApple(
    String idToken,
    String authCode,
  ) async {
    final result = await _authApi.loginWithApple(
      idToken: idToken,
      authCode: authCode,
    );

    if (result.isSuccess()) {
      return Right((result as Success).value);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> loginWithGoogle(String idToken) async {
    final result = await _authApi.loginWithGoogle(
      idToken: idToken,
    );

    if (result.isSuccess()) {
      return Right((result as Success).value);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> withdraw() async {
    final result = await _authApi.deleteUser();

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> updateFcmToken(String token) async {
    final result = await _authApi.patchFcmToken(token);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> changeAlarmControl(bool isOn) async {
    final result = await _authApi.patchAlarmControl(isOn);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }
}
