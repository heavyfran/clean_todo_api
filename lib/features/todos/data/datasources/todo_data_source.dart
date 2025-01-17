import '../../../../core/typedefs/typedefs.dart';
import '../models/todo_model.dart';

abstract interface class TodoDataSource {
  Future<TodoModel> createTodo({
    required String description,
    required String userId,
  });

  Future<List<TodoModel>> fetchTodos({
    required String userId,
    required MapData match,
    required MapData sort,
  });

  Future<TodoModel> fetchTodo({
    required String todoId,
    required String userId,
  });

  Future<TodoModel> toggleTodo({
    required String todoId,
    required String userId,
  });

  Future<TodoModel> updateTodo({
    required String todoId,
    required String description,
    required String userId,
  });

  Future<void> deleteTodo({
    required String todoId,
    required String userId,
  });
}
