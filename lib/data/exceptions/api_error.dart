import 'dart:developer';

abstract class ApiErrors implements Exception {
  final String message = "";
  ApiErrors({String? name}) {
    log(message, name: name ?? "");
  }
}

class UnknownError extends ApiErrors {
  @override
  String get message => "Terjadi kesalahan.";
  UnknownError() : super(name: 'UnknownError');
}

class TimeoutError extends ApiErrors {
  @override
  String get message => "Request Timeout";
  TimeoutError() : super(name: 'TimeoutError');
}

class NoConnectionError extends ApiErrors {
  @override
  String get message => "Connection Error";
  NoConnectionError() : super(name: 'NoConnectionError');
}

class UnauthorizedError extends ApiErrors {
  @override
  String get message => "User Not Authorized";
  UnauthorizedError() : super(name: 'authorizeError');
}

class ServerResError extends ApiErrors {
  @override
  // ignore: overridden_fields
  final String message;
  ServerResError(this.message) : super(name: 'ServerResError');
}
