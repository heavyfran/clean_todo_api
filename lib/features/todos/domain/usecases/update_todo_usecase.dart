import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/todo_presenter.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUsecase
    implements Usecase<TodoResponseModel, UpdateTodoRequestModel> {
  UpdateTodoUsecase({
    required TodoRepository todoRepository,
    required TodoPresenter todoPresenter,
  })  : _todoRepository = todoRepository,
        _todoPresenter = todoPresenter;

  final TodoRepository _todoRepository;
  final TodoPresenter _todoPresenter;

  @override
  FutureEither<TodoResponseModel> call(
    UpdateTodoRequestModel params,
  ) async {
    final result = await _todoRepository.updateTodo(
      todoId: params.todoId,
      description: params.description,
      userId: params.userId,
    );

    final response = _todoPresenter.updateTodoPresenter(result);

    return response;
  }
}
