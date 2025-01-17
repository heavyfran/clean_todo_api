import 'package:equatable/equatable.dart';

class SigninRequestModel extends Equatable {
  const SigninRequestModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
