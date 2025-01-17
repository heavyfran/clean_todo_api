import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/user_presenter.dart';
import '../repositories/user_repository.dart';

class UpdateMeUsecase
    implements Usecase<UserResponseModel, UpdateMeRequestModel> {
  UpdateMeUsecase({
    required UserRepository userRepository,
    required UserPresenter userPresenter,
  })  : _userRepository = userRepository,
        _userPresenter = userPresenter;

  final UserRepository _userRepository;
  final UserPresenter _userPresenter;

  @override
  FutureEither<UserResponseModel> call(UpdateMeRequestModel params) async {
    final result = await _userRepository.updateMe(
      userId: params.userId,
      username: params.username,
      email: params.email,
    );

    final response = _userPresenter.updateMePresenter(result);

    return response;
  }
}
