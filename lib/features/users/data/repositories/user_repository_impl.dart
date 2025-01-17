import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required UserDataSource userDataSource,
  }) : _userDataSource = userDataSource;

  final UserDataSource _userDataSource;

  @override
  FutureEither<User> findUserById({
    required String userId,
  }) async {
    try {
      final user = await _userDataSource.findUserById(userId: userId);
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
  FutureEither<User> updateMe({
    required String userId,
    String? username,
    String? email,
  }) async {
    try {
      final user = await _userDataSource.updateMe(
        userId: userId,
        username: username,
        email: email,
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
  FutureEither<User> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = await _userDataSource.changePassword(
        userId: userId,
        oldPassword: oldPassword,
        newPassword: newPassword,
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
  FutureEither<void> deleteMe({required String userId}) async {
    try {
      await _userDataSource.deleteMe(userId: userId);
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
