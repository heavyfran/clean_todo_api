import 'dart:io';

import 'package:clean_todo_api/features/auth/presentation/controllers/auth_controller.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final authController = context.read<AuthController>();

  switch (context.request.method) {
    case HttpMethod.post:
      return authController.resetPassword(context);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
