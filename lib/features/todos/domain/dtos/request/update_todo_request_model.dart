import 'package:equatable/equatable.dart';

class UpdateTodoRequestModel extends Equatable {
  const UpdateTodoRequestModel({
    required this.todoId,
    required this.description,
    required this.userId,
  });

  final String todoId;
  final String description;
  final String userId;

  @override
  List<Object> get props => [todoId, description, userId];
}
