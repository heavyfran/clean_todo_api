import 'package:equatable/equatable.dart';

class CreateTodoRequestModel extends Equatable {
  const CreateTodoRequestModel({
    required this.description,
    required this.userId,
  });

  final String description;
  final String userId;

  @override
  List<Object> get props => [description, userId];
}
