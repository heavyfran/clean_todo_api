import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
  }) : _authDataSource = authDataSource;

  final AuthDataSource _authDataSource;

  @override
  FutureEither<User> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.signup(
        username: username,
        email: email,
        password: password,
      );

      return Right(user);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<User> signin({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.signin(
        email: email,
        password: password,
      );

      return Right(user);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  FutureEither<void> resetPassword({required String email}) async {
    try {
      await _authDataSource.resetPassword(email: email);
      return const Right(null);
    } on TodoApiException catch (e) {
      return Left(
        TodoApiFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }
}
