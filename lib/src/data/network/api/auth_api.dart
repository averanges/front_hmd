part of '../network.dart';

class AuthApi {
  final _client = NetworkClient.getApiClient();

  Future<NetworkResult> loginWithApple({
    required String idToken,
    required String authCode,
  }) {
    final requestBody = AuthRequest(
      idToken: idToken,
      authCode: authCode,
    ).toJson();

    return _client.post(
      uri: NetworkConstants.uriAuthApple,
      body: requestBody,
    );
  }

  Future<NetworkResult> loginWithGoogle({
    required String idToken,
  }) {
    final requestBody = AuthRequest(
      idToken: idToken,
      authCode: null,
    ).toJson();

    return _client.post(
      uri: NetworkConstants.uriAuthGoogle,
      body: requestBody,
    );
  }

  Future<NetworkResult> deleteUser() {
    return _client.delete(
      uri: NetworkConstants.uriAuthUser,
    );
  }

  Future<NetworkResult> patchFcmToken(String token) {
    return _client.patch(
        uri: NetworkConstants.uriFCMToken,
        body: {
          'fcm_token': token,
        },
    );
  }

  Future<NetworkResult> patchAlarmControl(bool isOn) {
    return _client.patch(
      uri: NetworkConstants.uriUserAlarmControl,
      body: {
        'state': isOn,
      },
    );
  }
}
