import 'package:equatable/equatable.dart';

class FetchTodoRequestModel extends Equatable {
  const FetchTodoRequestModel({
    required this.userId,
    required this.todoId,
  });

  final String userId;
  final String todoId;

  @override
  List<Object> get props => [userId, todoId];
}
