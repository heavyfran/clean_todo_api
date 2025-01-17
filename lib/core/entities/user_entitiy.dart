import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String username;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object> get props {
    return [
      id,
      username,
      email,
      createdAt,
      updatedAt,
    ];
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
