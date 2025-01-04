part of '../network.dart';

class NetworkError extends CommonException {
  @override
  final String message;

  NetworkError(this.message) : super(message: message) {
    // Do Nothing
  }

  factory NetworkError.fromJson(Map<String, dynamic> json) {
    return NetworkError(
      json.containsKey('message') ? json['message'] : '알 수 없는 에러가 발생했습니다.',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
      };

  @override
  String toString() {
    return message;
  }
}
