import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl({
    required TodoDataSource todoDataSource,
  }) : _todoDataSource = todoDataSource;

  final TodoDataSource _todoDataSource;

  @override
  FutureEither<Todo> createTodo({
    required String description,
    required String userId,
  }) async {
    try {
      final todo = await _todoDataSource.createTodo(
        description: description,
        userId: userId,
      );
      return Right(todo);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<List<Todo>> fetchTodos({
    required String userId,
    required MapData match,
    required MapData sort,
  }) async {
    try {
      final todos = await _todoDataSource.fetchTodos(
        userId: userId,
        match: match,
        sort: sort,
      );
      return Right(todos);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<Todo> fetchTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      final todo = await _todoDataSource.fetchTodo(
        todoId: todoId,
        userId: userId,
      );
      return Right(todo);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<Todo> toggleTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      final todo = await _todoDataSource.toggleTodo(
        todoId: todoId,
        userId: userId,
      );
      return Right(todo);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<Todo> updateTodo({
    required String todoId,
    required String description,
    required String userId,
  }) async {
    try {
      final todo = await _todoDataSource.updateTodo(
        todoId: todoId,
        description: description,
        userId: userId,
      );
      return Right(todo);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<void> deleteTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      await _todoDataSource.deleteTodo(
        todoId: todoId,
        userId: userId,
      );
      return const Right(null);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }
}
