import 'package:get/get.dart';

abstract class CommonException implements Exception {
  String? _message;

  CommonException({required String? message}) {
    _message = message;
  }

  String get message => (_message == null || _message!.isEmpty)
      ? 'exception_unexpected'.tr
      : _message!;

  @override
  String toString() => message;
}

class NetworkNotConnectedException extends CommonException {
  NetworkNotConnectedException() : super(message: 'exception_network'.tr);
}

class UnExpectedException extends CommonException {
  UnExpectedException() : super(message: null);
}

class SessionExpiredException extends CommonException {
  final CommonException? originException;

  SessionExpiredException({this.originException})
      : super(message: '세션이 만료되었습니다.\n다시 로그인해주세요.');
}

class NotFoundUserException extends CommonException {
  NotFoundUserException() : super(message: 'exception_not_found_user'.tr);
}
