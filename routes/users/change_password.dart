import 'dart:io';

import 'package:clean_todo_api/features/users/presentation/controllers/user_controller.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final userController = context.read<UserController>();

  switch (context.request.method) {
    case HttpMethod.put:
      return userController.changePassword(context);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
