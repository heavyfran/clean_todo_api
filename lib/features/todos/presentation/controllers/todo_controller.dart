import 'package:dart_frog/dart_frog.dart';

abstract interface class TodoController {
  Future<Response> createTodo(RequestContext context);

  Future<Response> fetchTodos(RequestContext context);

  Future<Response> fetchTodo(RequestContext context, String todoId);

  Future<Response> toggleTodo(RequestContext context, String todoId);

  Future<Response> updateTodo(RequestContext context, String todoId);

  Future<Response> deleteTodo(RequestContext context, String todoId);
}
