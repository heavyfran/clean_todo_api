import 'dart:io';

import 'package:clean_todo_api/features/todos/presentation/controllers/todo_controller.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final todoController = context.read<TodoController>();

  switch (context.request.method) {
    case HttpMethod.post:
      return todoController.createTodo(context);
    case HttpMethod.get:
      return todoController.fetchTodos(context);
    case _:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
