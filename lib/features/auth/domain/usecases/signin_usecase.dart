import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../dtos/response/response.dart';
import '../presenters/auth_presenter.dart';
import '../repositories/auth_repository.dart';

class SigninUsecase
    implements Usecase<SigninResponseModel, SigninRequestModel> {
  SigninUsecase({
    required AuthRepository authRepository,
    required AuthPresenter authPresenter,
  })  : _authRepository = authRepository,
        _authPresenter = authPresenter;

  final AuthRepository _authRepository;
  final AuthPresenter _authPresenter;

  @override
  FutureEither<SigninResponseModel> call(SigninRequestModel params) async {
    final result = await _authRepository.signin(
      email: params.email,
      password: params.password,
    );

    final response = _authPresenter.signinPresenter(result);

    return response;
  }
}
