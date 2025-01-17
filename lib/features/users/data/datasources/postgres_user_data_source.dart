import 'dart:io';

import 'package:postgres/postgres.dart';

import '../../../../core/db/db_connection.dart';
import '../../../../core/db/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/password_manager.dart';
import 'user_data_source.dart';

class PostgresUserDataSource implements UserDataSource {
  PostgresUserDataSource({
    required DbConnection dbConnection,
    required PasswordManager passwordManager,
  })  : _dbConnection = dbConnection,
        _passwordManager = passwordManager {
    db = _dbConnection.db as Connection;
  }

  final DbConnection _dbConnection;
  final PasswordManager _passwordManager;
  late Connection db;

  @override
  Future<UserModel> findUserById({required String userId}) async {
    try {
      final result = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE id=@id
        '''),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final userModel = UserModel.fromJson(result.first.toColumnMap());

      return userModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<UserModel> updateMe({
    required String userId,
    String? username,
    String? email,
  }) async {
    try {
      final foundUser = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE id=@id
        '''),
        parameters: {'id': userId},
      );

      if (foundUser.isEmpty) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final result = await db.execute(
        Sql.named('''
          UPDATE ${DbConstants.usersTable}
          SET
            username=COALESCE(@new_username, username),
            email=COALESCE(@new_email, email),
            updated_at=current_timestamp
          WHERE
            id=@id
          RETURNING *
        '''),
        parameters: {
          'new_username': username,
          'new_email': email,
          'id': userId,
        },
      );

      if (result.isEmpty) {
        throw const TodoApiException(
          message: 'Fail to update user',
          statusCode: HttpStatus.notFound,
        );
      }

      final updatedUserModel = UserModel.fromJson(result.first.toColumnMap());

      return updatedUserModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<UserModel> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final foundUser = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE id=@id
        '''),
        parameters: {'id': userId},
      );

      if (foundUser.isEmpty) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final savedPassword = foundUser.first.toColumnMap()['password'] as String;

      final matched =
          _passwordManager.checkPassword(oldPassword, savedPassword);

      if (!matched) {
        throw const TodoApiException(
          message: 'oldPassword not match',
          statusCode: HttpStatus.badRequest,
        );
      }

      final hashedPassword = _passwordManager.encryptPassword(newPassword);

      final result = await db.execute(
        Sql.named('''
          UPDATE ${DbConstants.usersTable}
          SET
            password=@password,
            updated_at=current_timestamp
          WHERE
            id=@id
          RETURNING *
        '''),
        parameters: {
          'id': userId,
          'password': hashedPassword,
        },
      );

      if (result.affectedRows != 1) {
        throw const TodoApiException(
          message: 'Fail to change password',
          statusCode: HttpStatus.notFound,
        );
      }

      final updatedUserModel = UserModel.fromJson(result.first.toColumnMap());

      return updatedUserModel;
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }

  @override
  Future<void> deleteMe({required String userId}) async {
    try {
      final foundUser = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE id=@id
        '''),
        parameters: {'id': userId},
      );

      if (foundUser.isEmpty) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final result = await db.execute(
        Sql.named('''
          DELETE FROM ${DbConstants.usersTable}
          WHERE id=@id
          RETURNING *
        '''),
        parameters: {'id': userId},
      );

      if (result.isEmpty) {
        throw const TodoApiException(
          message: 'Fail to delete user',
          statusCode: HttpStatus.notFound,
        );
      }
    } on TodoApiException catch (e) {
      throw TodoApiException(
        message: e.message,
        statusCode: e.statusCode,
      );
    } catch (e) {
      throw TodoApiException(message: e.toString());
    }
  }
}
