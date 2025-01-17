import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUsecase implements Usecase<void, ResetPasswordRequestModel> {
  ResetPasswordUsecase({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  FutureEither<void> call(ResetPasswordRequestModel params) async {
    final response = await _authRepository.resetPassword(email: params.email);

    return response;
  }
}
