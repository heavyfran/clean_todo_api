import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../dtos/response/user_response_model.dart';

abstract interface class UserPresenter {
  EitherOr<UserResponseModel> findUserByIdPresenter(
    EitherOr<User> result,
  );

  EitherOr<UserResponseModel> updateMePresenter(
    EitherOr<User> result,
  );

  EitherOr<UserResponseModel> changePasswordPresenter(
    EitherOr<User> result,
  );
}
