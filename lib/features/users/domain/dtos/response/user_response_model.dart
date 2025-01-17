import 'package:equatable/equatable.dart';

import '../../../../../core/typedefs/typedefs.dart';

class UserResponseModel extends Equatable {
  const UserResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String username;
  final String email;
  final String createdAt;
  final String updatedAt;

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

  MapData toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
