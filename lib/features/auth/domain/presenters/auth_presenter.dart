import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../dtos/response/response.dart';

abstract interface class AuthPresenter {
  EitherOr<SignupResponseModel> signupPresenter(
    EitherOr<User> result,
  );

  EitherOr<SigninResponseModel> signinPresenter(
    EitherOr<User> result,
  );
}
