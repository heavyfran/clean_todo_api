import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/user_presenter.dart';
import '../repositories/user_repository.dart';

class FindUserByIdUsecase
    implements Usecase<UserResponseModel, FindUserByIdRequestModel> {
  FindUserByIdUsecase({
    required UserRepository userRepository,
    required UserPresenter userPresenter,
  })  : _userRepository = userRepository,
        _userPresenter = userPresenter;

  final UserRepository _userRepository;
  final UserPresenter _userPresenter;

  @override
  FutureEither<UserResponseModel> call(
    FindUserByIdRequestModel params,
  ) async {
    final result = await _userRepository.findUserById(userId: params.userId);

    final response = _userPresenter.findUserByIdPresenter(result);

    return response;
  }
}
