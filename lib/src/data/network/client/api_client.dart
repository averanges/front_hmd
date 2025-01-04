part of '../network.dart';

class ApiClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final StorageManager storageManager;

  ApiClient(this.storageManager);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var loggerText = await _setupRequest(request);

    Log.i(loggerText);
    var result = await _client.send(request);

    if (result.statusCode == HttpStatus.unauthorized) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      final String? token = await user?.getIdToken(true);

      Log.i('response is ${result.statusCode}, start refresh and retry!!');
      Log.i('new token: $token');

      storageManager.updateUser(user);
      var newRequest = http.Request(request.method, request.url);
      await _setupRequest(newRequest);
      if (token != null && token.isNotEmpty) {
        newRequest.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
      result = await _client.send(newRequest);
    }
    return result;
  }

  Future<String> _setupRequest(http.BaseRequest request) async {
    var loggerText = '';

    if (Platform.isAndroid) {
      request.headers['X-Header-DeviceType'] = 'a';
    } else if (Platform.isIOS) {
      request.headers['X-Header-DeviceType'] = 'i';
    }

    request.headers['X-Header-Locale'] = Get.locale?.languageCode ?? 'kr';

    final accessToken = storageManager.accessToken;
    if (accessToken.isNotEmpty) {
      request.headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      request.headers['X-Header-AppVersion'] = packageInfo.version;
      request.headers['X-Header-AppVersionCode'] = packageInfo.buildNumber;
    } on Exception catch (e) {
      Log.e('packageInfoError', e);
    }

    loggerText += 'API Request ${request.toString()}\n';
    loggerText += 'API Request Headers ${request.headers.toString()}';
    if (request is http.Request && request.bodyBytes.isNotEmpty) {
      loggerText += '\nAPI Request body ${request.body}';
    }

    return loggerText;
  }
}
