import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/user_presenter.dart';
import '../repositories/user_repository.dart';

class ChangePasswordUsecase
    implements Usecase<UserResponseModel, ChangePasswordRequestModel> {
  ChangePasswordUsecase({
    required UserRepository userRepository,
    required UserPresenter userPresenter,
  })  : _userRepository = userRepository,
        _userPresenter = userPresenter;

  final UserRepository _userRepository;
  final UserPresenter _userPresenter;

  @override
  FutureEither<UserResponseModel> call(
    ChangePasswordRequestModel params,
  ) async {
    final result = await _userRepository.changePassword(
      userId: params.userId,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );

    final response = _userPresenter.changePasswordPresenter(result);

    return response;
  }
}
