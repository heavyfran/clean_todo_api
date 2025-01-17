import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../domain/dtos/response/user_response_model.dart';
import '../../domain/presenters/user_presenter.dart';

class UserPresenterImpl implements UserPresenter {
  UserResponseModel _convertUserEntityToUserResponseModel(User user) {
    return UserResponseModel(
      id: user.id,
      username: user.username,
      email: user.email,
      createdAt:
          DateFormat('E,MMM dd,yyyy - HH:mm:ss a').format(user.createdAt),
      updatedAt:
          DateFormat('E,MMM dd,yyyy - HH:mm:ss a').format(user.updatedAt),
    );
  }

  @override
  EitherOr<UserResponseModel> findUserByIdPresenter(EitherOr<User> result) {
    final EitherOr<UserResponseModel> response = result.match(
      Left.new,
      (user) => Right(_convertUserEntityToUserResponseModel(user)),
    );

    return response;
  }

  @override
  EitherOr<UserResponseModel> updateMePresenter(EitherOr<User> result) {
    final EitherOr<UserResponseModel> response = result.match(
      Left.new,
      (user) => Right(_convertUserEntityToUserResponseModel(user)),
    );

    return response;
  }

  @override
  EitherOr<UserResponseModel> changePasswordPresenter(EitherOr<User> result) {
    final EitherOr<UserResponseModel> response = result.match(
      Left.new,
      (user) => Right(_convertUserEntityToUserResponseModel(user)),
    );

    return response;
  }
}
