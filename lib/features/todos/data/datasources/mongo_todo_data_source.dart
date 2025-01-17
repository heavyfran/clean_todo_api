import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/db/db_connection.dart';
import '../../../../core/db/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../models/todo_model.dart';
import 'todo_data_source.dart';

class MongoTodoDataSource implements TodoDataSource {
  MongoTodoDataSource({
    required DbConnection dbConnection,
  }) : _dbConnection = dbConnection {
    db = _dbConnection.db as Db;
  }

  final DbConnection _dbConnection;
  late Db db;

  @override
  Future<TodoModel> createTodo({
    required String description,
    required String userId,
  }) async {
    try {
      final todosColl = db.collection(DbConstants.todosCollection);

      final uid = UuidValue.withValidation(userId);

      final currentTime = DateTime.now();
      final response = await todosColl.insertOne({
        '_id': const Uuid().v4obj(),
        'description': description,
        'completed': false,
        'userId': uid,
        'createdAt': currentTime,
        'updatedAt': currentTime,
      });

      if (response.nInserted != 1) {
        throw const TodoApiException(
          message: 'Fail to create todo',
        );
      }

      final todoModel = TodoModel.fromJson(response.document!);

      return todoModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<List<TodoModel>> fetchTodos({
    required String userId,
    required MapData match,
    required MapData sort,
  }) async {
    try {
      final todosColl = db.collection(DbConstants.todosCollection);

      final uid = UuidValue.withValidation(userId);

      var selector = where.eq('userId', uid);

      if (match['completed'] != null) {
        selector = selector.eq('completed', match['completed'] as bool);
      }

      if (sort.isNotEmpty) {
        final key = sort.keys.toList()[0];
        var value = sort.values.toList()[0];
        value = value == 'DESC' || false;
        selector = selector.sortBy(key, descending: value as bool);
      } else {
        selector = selector.sortBy('updatedAt', descending: true);
      }

      if (match['limit'] != null) {
        selector = selector.limit(match['limit'] as int);
      }
      if (match['skip'] != null) {
        selector = selector.skip(match['skip'] as int);
      }

      final response = await todosColl.find(selector).toList();

      final todos = [for (final todo in response) TodoModel.fromJson(todo)];
      return todos;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<TodoModel> fetchTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      final todosColl = db.collection(DbConstants.todosCollection);

      final tid = UuidValue.withValidation(todoId);
      final uid = UuidValue.withValidation(userId);

      final response =
          await todosColl.findOne(where.eq('_id', tid).eq('userId', uid));

      if (response == null) {
        throw const TodoApiException(
          message: 'Not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final todoModel = TodoModel.fromJson(response);

      return todoModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<TodoModel> toggleTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      final todoTobeToggled = await fetchTodo(todoId: todoId, userId: userId);

      final todosColl = db.collection(DbConstants.todosCollection);

      final tid = UuidValue.withValidation(todoId);
      final uid = UuidValue.withValidation(userId);

      final response = await todosColl.modernFindAndModify(
        query: where.eq('_id', tid).eq('userId', uid),
        update: modify
            .set('completed', !todoTobeToggled.completed)
            .set('updatedAt', DateTime.now()),
        returnNew: true,
      );

      if (response.lastErrorObject?.updatedExisting != true) {
        throw const TodoApiException(
          message: 'Fail to toggle todo',
        );
      }

      final todoModel = TodoModel.fromJson(response.value!);

      return todoModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<TodoModel> updateTodo({
    required String todoId,
    required String description,
    required String userId,
  }) async {
    try {
      final todosColl = db.collection(DbConstants.todosCollection);

      final tid = UuidValue.withValidation(todoId);
      final uid = UuidValue.withValidation(userId);

      final response = await todosColl.modernFindAndModify(
        query: where.eq('_id', tid).eq('userId', uid),
        update: modify
            .set('description', description)
            .set('updatedAt', DateTime.now()),
        returnNew: true,
      );

      if (response.lastErrorObject?.updatedExisting != true) {
        throw const TodoApiException(
          message: 'Fail to update todo',
        );
      }

      final todoModel = TodoModel.fromJson(response.value!);

      return todoModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<void> deleteTodo({
    required String todoId,
    required String userId,
  }) async {
    try {
      final todosColl = db.collection(DbConstants.todosCollection);

      final tid = UuidValue.withValidation(todoId);
      final uid = UuidValue.withValidation(userId);

      final response = await todosColl.deleteOne(
        where.eq('_id', tid).eq('userId', uid),
      );

      if (response.nRemoved != 1) {
        throw const TodoApiException(
          message: 'Fail to delete todo',
        );
      }
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }
}
