import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../domain/dtos/response/signin_response_model.dart';
import '../../domain/dtos/response/signup_response_model.dart';
import '../../domain/presenters/auth_presenter.dart';

class AuthPresenterImpl implements AuthPresenter {
  @override
  EitherOr<SignupResponseModel> signupPresenter(EitherOr<User> result) {
    final EitherOr<SignupResponseModel> response = result.match(
      Left.new,
      (user) => Right(SignupResponseModel(id: user.id)),
    );

    return response;
  }

  @override
  EitherOr<SigninResponseModel> signinPresenter(EitherOr<User> result) {
    final EitherOr<SigninResponseModel> response = result.match(
      Left.new,
      (user) => Right(SigninResponseModel(id: user.id)),
    );

    return response;
  }
}
