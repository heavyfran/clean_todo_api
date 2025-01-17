import 'dart:io';

import 'package:equatable/equatable.dart';

class TodoApiException extends Equatable implements Exception {
  const TodoApiException({
    required this.message,
    this.statusCode = HttpStatus.internalServerError,
  });

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];

  @override
  String toString() =>
      'TodoApiException(message: $message, statusCode: $statusCode)';
}
