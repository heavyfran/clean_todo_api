import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/todo_presenter.dart';
import '../repositories/todo_repository.dart';

class ToggleTodoUsecase
    implements Usecase<TodoResponseModel, ToggleTodoRequestModel> {
  ToggleTodoUsecase({
    required TodoRepository todoRepository,
    required TodoPresenter todoPresenter,
  })  : _todoRepository = todoRepository,
        _todoPresenter = todoPresenter;

  final TodoRepository _todoRepository;
  final TodoPresenter _todoPresenter;

  @override
  FutureEither<TodoResponseModel> call(
    ToggleTodoRequestModel params,
  ) async {
    final result = await _todoRepository.toggleTodo(
      todoId: params.todoId,
      userId: params.userId,
    );

    final response = _todoPresenter.toggleTodoPresenter(result);

    return response;
  }
}
