import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUsecase implements Usecase<void, DeleteTodoRequestModel> {
  DeleteTodoUsecase({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  final TodoRepository _todoRepository;

  @override
  FutureEither<void> call(DeleteTodoRequestModel params) async {
    final result = await _todoRepository.deleteTodo(
      todoId: params.todoId,
      userId: params.userId,
    );

    return result;
  }
}
