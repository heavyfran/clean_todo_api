import 'package:equatable/equatable.dart';

class UpdateMeRequestModel extends Equatable {
  const UpdateMeRequestModel({
    required this.userId,
    this.username,
    this.email,
  });

  final String userId;
  final String? username;
  final String? email;

  @override
  List<Object?> get props => [userId, username, email];
}
