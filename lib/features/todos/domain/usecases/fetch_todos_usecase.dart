import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/todo_presenter.dart';
import '../repositories/todo_repository.dart';

class FetchTodosUsecase
    implements Usecase<List<TodoResponseModel>, FetchTodosRequestModel> {
  FetchTodosUsecase({
    required TodoRepository todoRepository,
    required TodoPresenter todoPresenter,
  })  : _todoRepository = todoRepository,
        _todoPresenter = todoPresenter;

  final TodoRepository _todoRepository;
  final TodoPresenter _todoPresenter;

  @override
  FutureEither<List<TodoResponseModel>> call(
    FetchTodosRequestModel params,
  ) async {
    final result = await _todoRepository.fetchTodos(
      userId: params.userId,
      match: params.match,
      sort: params.sort,
    );

    final response = _todoPresenter.fetchTodosPresenter(result);

    return response;
  }
}
