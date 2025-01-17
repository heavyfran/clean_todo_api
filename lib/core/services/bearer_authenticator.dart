import 'package:dart_frog/dart_frog.dart';

import '../../features/users/domain/dtos/request/request.dart';
import '../../features/users/domain/dtos/response/response.dart';
import '../../features/users/domain/usecases/usecases.dart';
import 'jwt_service.dart';

class BearerAuthenticator {
  BearerAuthenticator({
    required JwtService jwtService,
    required FindUserByIdUsecase findUserByIdUsecase,
  })  : _jwtService = jwtService,
        _findUserByIdUsecase = findUserByIdUsecase;

  final JwtService _jwtService;
  final FindUserByIdUsecase _findUserByIdUsecase;

  Future<UserResponseModel?> authenticator(
    RequestContext context,
    String token,
  ) async {
    final payload = _jwtService.verify(token);

    if (payload == null) return null;

    final foundUser = await _findUserByIdUsecase(
      FindUserByIdRequestModel(userId: payload['id'] as String),
    );

    return foundUser.match(
      (_) => null,
      (user) => user,
    );
  }
}
