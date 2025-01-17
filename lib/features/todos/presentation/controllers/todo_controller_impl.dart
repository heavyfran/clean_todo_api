import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../core/typedefs/typedefs.dart';
import '../../../users/domain/dtos/response/user_response_model.dart';
import '../../domain/dtos/request/request.dart';
import '../../domain/usecases/usecases.dart';
import 'todo_controller.dart';

class TodoControllerImpl implements TodoController {
  TodoControllerImpl({
    required CreateTodoUsecase createTodoUsecase,
    required FetchTodosUsecase fetchTodosUsecase,
    required FetchTodoUsecase fetchTodoUsecase,
    required ToggleTodoUsecase toggleTodoUsecase,
    required UpdateTodoUsecase updateTodoUsecase,
    required DeleteTodoUsecase deleteTodoUsecase,
  })  : _createTodoUsecase = createTodoUsecase,
        _fetchTodosUsecase = fetchTodosUsecase,
        _fetchTodoUsecase = fetchTodoUsecase,
        _toggleTodoUsecase = toggleTodoUsecase,
        _updateTodoUsecase = updateTodoUsecase,
        _deleteTodoUsecase = deleteTodoUsecase;

  final CreateTodoUsecase _createTodoUsecase;
  final FetchTodosUsecase _fetchTodosUsecase;
  final FetchTodoUsecase _fetchTodoUsecase;
  final ToggleTodoUsecase _toggleTodoUsecase;
  final UpdateTodoUsecase _updateTodoUsecase;
  final DeleteTodoUsecase _deleteTodoUsecase;

  @override
  Future<Response> createTodo(RequestContext context) async {
    final body = await context.request.json() as MapData;
    final description = body['description'] as String?;

    if (description == null || description.trim().isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'message': 'Please provide valid todo description',
        },
      );
    }

    final user = context.read<UserResponseModel>();

    final result = await _createTodoUsecase(
      CreateTodoRequestModel(
        description: description,
        userId: user.id,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (todo) {
        return Response.json(
          statusCode: HttpStatus.created,
          body: {'todo': todo},
        );
      },
    );
  }

  @override
  Future<Response> fetchTodos(RequestContext context) async {
    final params = context.request.uri.queryParameters;
    print(params);

    final MapData match = {};
    final MapData sort = {};

    if (params['completed'] != null) {
      match['completed'] = params['completed'] == 'true';
    }

    if (params['sortBy'] != null) {
      final parts = params['sortBy']!.split(':');
      if (parts.length == 1) parts.add('asc');
      sort[parts[0]] = parts[1].toLowerCase() == 'desc' ? 'DESC' : 'ASC';
    }

    if (params['limit'] != null) {
      final limit = int.tryParse(params['limit']!);
      if (limit != null && limit > 0) {
        match['limit'] = limit;
      }
    }

    if (params['skip'] != null) {
      final skip = int.tryParse(params['skip']!);
      if (skip != null && skip > 0) {
        match['skip'] = skip;
      }
    }

    final user = context.read<UserResponseModel>();

    final result = await _fetchTodosUsecase(
      FetchTodosRequestModel(
        userId: user.id,
        match: match,
        sort: sort,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (todos) {
        return Response.json(
          body: {'todos': todos},
        );
      },
    );
  }

  @override
  Future<Response> fetchTodo(
    RequestContext context,
    String todoId,
  ) async {
    final user = context.read<UserResponseModel>();

    final result = await _fetchTodoUsecase(
      FetchTodoRequestModel(userId: user.id, todoId: todoId),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (todo) {
        return Response.json(
          body: {'todo': todo},
        );
      },
    );
  }

  @override
  Future<Response> toggleTodo(
    RequestContext context,
    String todoId,
  ) async {
    final user = context.read<UserResponseModel>();

    final result = await _toggleTodoUsecase(
      ToggleTodoRequestModel(todoId: todoId, userId: user.id),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (todo) {
        return Response.json(
          body: {'todo': todo},
        );
      },
    );
  }

  @override
  Future<Response> updateTodo(
    RequestContext context,
    String todoId,
  ) async {
    final body = await context.request.json() as MapData;
    final description = body['description'] as String?;

    if (description == null || description.trim().isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Please provide valid todo description'},
      );
    }

    final user = context.read<UserResponseModel>();

    final result = await _updateTodoUsecase(
      UpdateTodoRequestModel(
        todoId: todoId,
        description: description,
        userId: user.id,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (todo) {
        return Response.json(
          body: {'todo': todo},
        );
      },
    );
  }

  @override
  Future<Response> deleteTodo(
    RequestContext context,
    String todoId,
  ) async {
    final user = context.read<UserResponseModel>();

    final result = await _deleteTodoUsecase(
      DeleteTodoRequestModel(todoId: todoId, userId: user.id),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (_) {
        return Response.json(
          statusCode: HttpStatus.noContent,
          body: {'message': 'Successfully deleted todo'},
        );
      },
    );
  }
}
