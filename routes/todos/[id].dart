import 'dart:io';

import 'package:clean_todo_api/features/todos/presentation/controllers/todo_controller.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:string_validator/string_validator.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (isUUID(id) == false) {
    return Response(
      statusCode: HttpStatus.badRequest,
      body: 'Invalid id',
    );
  }

  final todoController = context.read<TodoController>();

  switch (context.request.method) {
    case HttpMethod.get:
      return todoController.fetchTodo(context, id);
    case HttpMethod.patch:
      return todoController.toggleTodo(context, id);
    case HttpMethod.put:
      return todoController.updateTodo(context, id);
    case HttpMethod.delete:
      return todoController.deleteTodo(context, id);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
