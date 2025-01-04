part of '../network.dart';

abstract class BaseNetworkClient {
  Future<NetworkResult> get({
    String? url,
    required String uri,
    Map<String, String> headers,
  });

  Future<NetworkResult> readBytes({
    String? url,
    required String uri,
    Map<String, String> headers,
  });

  Future<NetworkResult> post({
    String? url,
    required String uri,
    Map<String, String> headers,
    required Map<String, String> body,
  });

  Future<NetworkResult> put({
    String? url,
    required String uri,
    Map<String, String> headers,
    required Map<String, String> body,
  });

  Future<NetworkResult> patch({
    String? url,
    required String uri,
    Map<String, String> headers,
    required Map<String, String> body,
  });

  Future<NetworkResult> delete({
    String? url,
    required String uri,
    Map<String, String> headers,
  });

  Future<NetworkResult> multipartRequest({
    String? url,
    required String uri,
    required HttpMethod method,
    Map<String, String> headers,
    required Map<String, dynamic> body,
    required http.MultipartFile file,
  });
}
