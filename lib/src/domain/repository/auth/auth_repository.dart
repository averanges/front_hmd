import 'package:haimdall/src/common/alias/alias.dart';

abstract class AuthRepository {
  Future<Result<Map<String, dynamic>>> loginWithApple(
      String idToken, String authCode);

  Future<Result<Map<String, dynamic>>> loginWithGoogle(String idToken);

  Future<Result<void>> withdraw();

  Future<Result<void>> updateFcmToken(String token);

  Future<Result<void>> changeAlarmControl(bool isOn);
}
