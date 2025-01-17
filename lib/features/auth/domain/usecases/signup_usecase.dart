import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/auth_presenter.dart';
import '../repositories/auth_repository.dart';

class SignupUsecase
    implements Usecase<SignupResponseModel, SignupRequestModel> {
  SignupUsecase({
    required AuthRepository authRepository,
    required AuthPresenter authPresenter,
  })  : _authRepository = authRepository,
        _authPresenter = authPresenter;

  final AuthRepository _authRepository;
  final AuthPresenter _authPresenter;

  @override
  FutureEither<SignupResponseModel> call(SignupRequestModel params) async {
    final result = await _authRepository.signup(
      username: params.username,
      email: params.email,
      password: params.password,
    );

    final response = _authPresenter.signupPresenter(result);

    return response;
  }
}
