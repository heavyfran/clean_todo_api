import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.description,
    this.completed = false,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String description;
  final bool completed;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props {
    return [
      id,
      description,
      completed,
      userId,
      createdAt,
      updatedAt,
    ];
  }

  @override
  String toString() {
    return 'Todo(id: $id, description: $description, completed: $completed, '
        'userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
