import '../../../../core/typedefs/typedefs.dart';
import '../dtos/response/todo_response_model.dart';
import '../entities/todo_entity.dart';

abstract interface class TodoPresenter {
  EitherOr<TodoResponseModel> createTodoPresenter(
    EitherOr<Todo> result,
  );

  EitherOr<List<TodoResponseModel>> fetchTodosPresenter(
    EitherOr<List<Todo>> result,
  );

  EitherOr<TodoResponseModel> fetchTodoPresenter(
    EitherOr<Todo> result,
  );

  EitherOr<TodoResponseModel> toggleTodoPresenter(
    EitherOr<Todo> result,
  );

  EitherOr<TodoResponseModel> updateTodoPresenter(
    EitherOr<Todo> result,
  );
}
