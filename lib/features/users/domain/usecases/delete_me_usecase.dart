import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/usecases/usecases.dart';
import '../dtos/request/request.dart';
import '../repositories/user_repository.dart';

class DeleteMeUsecase implements Usecase<void, DeleteMeRequestModel> {
  DeleteMeUsecase({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  final UserRepository _userRepository;

  @override
  FutureEither<void> call(DeleteMeRequestModel params) async {
    final response = await _userRepository.deleteMe(userId: params.userId);

    return response;
  }
}
