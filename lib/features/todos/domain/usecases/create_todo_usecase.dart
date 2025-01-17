import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/create_todo_request_model.dart';
import '../dtos/response/response.dart';
import '../presenters/todo_presenter.dart';
import '../repositories/todo_repository.dart';

class CreateTodoUsecase
    implements Usecase<TodoResponseModel, CreateTodoRequestModel> {
  CreateTodoUsecase({
    required TodoRepository todoRepository,
    required TodoPresenter todoPresenter,
  })  : _todoRepository = todoRepository,
        _todoPresenter = todoPresenter;

  final TodoRepository _todoRepository;
  final TodoPresenter _todoPresenter;

  @override
  FutureEither<TodoResponseModel> call(CreateTodoRequestModel params) async {
    final result = await _todoRepository.createTodo(
      description: params.description,
      userId: params.userId,
    );

    final response = _todoPresenter.createTodoPresenter(result);

    return response;
  }
}
