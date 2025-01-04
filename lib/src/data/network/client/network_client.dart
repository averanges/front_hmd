part of '../network.dart';

class NetworkClient extends BaseNetworkClient {
  static const String _contentJson = 'application/json';
  static const defaultHeaders = {
    HttpHeaders.contentTypeHeader: _contentJson,
  };

  late http.BaseClient _client;

  NetworkClient._internal({required http.BaseClient client}) {
    _client = client;
  }

  factory NetworkClient.getApiClient() {
    final storageManager = Get.find<StorageManager>();
    return NetworkClient._internal(client: ApiClient(storageManager));
  }

  @override
  Future<NetworkResult> get({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
  }) async {
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final response = await _client.get(Uri.parse(fullUrl), headers: headers);
      return _parseResponse(response);
    } on Exception catch (e) {
      Log.e('Api[GET] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> readBytes({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
  }) async {
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final result =
          await _client.readBytes(Uri.parse(fullUrl), headers: headers);
      return Success(result);
    } on Exception catch (e) {
      Log.e('Api[GET] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> post({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
    required Map<String, dynamic> body,
  }) async {
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final response = await _client.post(
        Uri.parse(fullUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      return _parseResponse(response);
    } on Exception catch (e) {
      Log.e('Api[POST] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> multipartRequest({
    String? url,
    required String uri,
    required HttpMethod method,
    Map<String, String> headers = defaultHeaders,
    required Map<String, dynamic> body,
    required http.MultipartFile file,
  }) async {
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      var headers = {
        HttpHeaders.contentTypeHeader: 'multipart/form-data',
      };

      if (Platform.isAndroid) {
        headers['X-Header-DeviceType'] = 'a';
      } else if (Platform.isIOS) {
        headers['X-Header-DeviceType'] = 'i';
      }

      headers['X-Header-Locale'] = Get.locale?.languageCode ?? 'kr';

      final accessToken = Get.find<StorageManager>().accessToken;
      if (accessToken.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
      }

      try {
        final packageInfo = await PackageInfo.fromPlatform();
        headers['X-Header-AppVersion'] = packageInfo.version;
        headers['X-Header-AppVersionCode'] = packageInfo.buildNumber;
      } on Exception catch (e) {
        Log.e('packageInfoError', e);
      }

      final request = http.MultipartRequest(method.value, Uri.parse(fullUrl));
      request.headers.addAll(headers);
      request.files.add(file);
      request.fields.addAll(
        body.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await request.send();

      return await _parseMultipartResponse(response);
    } on Exception catch (e) {
      Log.e('Api[POST] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> put({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
    required Map<String, dynamic> body,
  }) async {
    assert(url.isNotNullNotEmpty() || uri.isNotNullNotEmpty());
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final response = await _client.put(
        Uri.parse(fullUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      return _parseResponse(response);
    } on Exception catch (e) {
      Log.e('Api[PUT] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> patch({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
    required Map<String, dynamic> body,
  }) async {
    assert(url.isNotNullNotEmpty() || uri.isNotNullNotEmpty());
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final response = await _client.patch(
        Uri.parse(fullUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      return _parseResponse(response);
    } on Exception catch (e) {
      Log.e('Api[PATCH] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  @override
  Future<NetworkResult> delete({
    String? url,
    required String uri,
    Map<String, String> headers = defaultHeaders,
  }) async {
    assert(url.isNotNullNotEmpty() || uri.isNotNullNotEmpty());
    try {
      final fullUrl = _getUrl(url: url, uri: uri);

      final response = await _client.delete(
        Uri.parse(fullUrl),
        headers: headers,
      );

      return _parseResponse(response);
    } on Exception catch (e) {
      Log.e('Api[DELETE] Error: $e', e);
      return Failure(NetworkNotConnectedException());
    }
  }

  String _getUrl({String? url, required String uri}) {
    var fullUrl = '';
    if (url.isNotNullNotEmpty() && url?.contains('http') == true) {
      fullUrl = url!;
    } else {
      fullUrl = Environment.buildType.baseUrl;
    }

    if (uri.isNotNullNotEmpty()) {
      fullUrl += uri;
    }

    return fullUrl;
  }

  NetworkResult _parseResponse(http.Response response) {
    dynamic jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body);
    } on Exception {
      jsonResponse = response.body;
    }

    Log.i(
        '[${response.request?.method}] ${response.request?.url}\nAPI Response[${response.statusCode}]: ${jsonEncode(jsonResponse).toString()}');

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse.containsKey('errorCode')) {
          final error = NetworkError.fromJson(jsonResponse);
          return Failure(error);
        }
      }
      return Success(jsonResponse);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final error = NetworkError.fromJson(jsonResponse);

      return Failure(SessionExpiredException(originException: error));
    } else {
      try {
        final error = NetworkError.fromJson(jsonResponse);
        return Failure(error);
      } on Exception {
        return Failure(NetworkError('알 수 없는 오류가 발생했습니다.'));
      }
    }
  }

  Future<NetworkResult> _parseMultipartResponse(
      http.StreamedResponse response) async {
    dynamic jsonResponse;
    try {
      jsonResponse = json
          .decode(await response.stream.bytesToString()); // json 응답 값을 decode
    } on Exception {
      jsonResponse = response.stream.bytesToString();
    }

    Log.i(
        '[${response.request?.method}] ${response.request?.url}\nAPI Response[${response.statusCode}]: ${jsonEncode(jsonResponse).toString()}');

    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      if (jsonResponse is Map<String, dynamic>) {
        if (jsonResponse.containsKey('errorCode')) {
          final error = NetworkError.fromJson(jsonResponse);
          return Failure(error);
        }
      }
      return Success(jsonResponse);
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final error = NetworkError.fromJson(jsonResponse);

      return Failure(SessionExpiredException(originException: error));
    } else {
      try {
        final error = NetworkError.fromJson(jsonResponse);
        return Failure(error);
      } on Exception {
        return Failure(NetworkError('알 수 없는 오류가 발생했습니다.'));
      }
    }
  }
}

enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete;

  String get value {
    switch (this) {
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.delete:
        return 'DELETE';
    }
  }
}
