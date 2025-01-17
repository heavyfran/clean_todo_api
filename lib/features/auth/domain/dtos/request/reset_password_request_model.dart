import 'package:equatable/equatable.dart';

class ResetPasswordRequestModel extends Equatable {
  const ResetPasswordRequestModel({required this.email});

  final String email;

  @override
  List<Object> get props => [email];
}
