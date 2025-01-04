part of '../network.dart';

abstract class NetworkResult {
  bool isSuccess() {
    return this is Success;
  }

  bool isError() {
    return this is Failure;
  }
}

class Success<T> extends NetworkResult {
  final T value;

  Success(this.value);
}

class Failure extends NetworkResult {
  final CommonException exception;

  Failure(this.exception);

  @override
  String toString() {
    return exception.message;
  }
}
