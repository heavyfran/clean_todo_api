import 'package:equatable/equatable.dart';

class ToggleTodoRequestModel extends Equatable {
  const ToggleTodoRequestModel({
    required this.todoId,
    required this.userId,
  });

  final String todoId;
  final String userId;

  @override
  List<Object> get props => [todoId, userId];
}
