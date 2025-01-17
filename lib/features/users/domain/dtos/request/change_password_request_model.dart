import 'package:equatable/equatable.dart';

class ChangePasswordRequestModel extends Equatable {
  const ChangePasswordRequestModel({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  final String userId;
  final String oldPassword;
  final String newPassword;

  @override
  List<Object> get props => [userId, oldPassword, newPassword];
}
