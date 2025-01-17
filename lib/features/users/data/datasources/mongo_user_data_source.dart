import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/db/db_connection.dart';
import '../../../../core/db/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/password_manager.dart';
import 'user_data_source.dart';

class MongoUserDataSource implements UserDataSource {
  MongoUserDataSource({
    required DbConnection dbConnection,
    required PasswordManager passwordManager,
  })  : _dbConnection = dbConnection,
        _passwordManager = passwordManager {
    db = _dbConnection.db as Db;
  }

  final DbConnection _dbConnection;
  final PasswordManager _passwordManager;
  late Db db;

  @override
  Future<UserModel> findUserById({required String userId}) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);

      final uid = UuidValue.withValidation(userId);

      final response = await usersColl.findOne(where.eq('_id', uid));

      if (response == null) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final userModel = UserModel.fromJson(response);

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
      final usersColl = db.collection(DbConstants.usersCollection);

      var modifierBuilder = modify;

      if (username != null) {
        modifierBuilder = modifierBuilder.set('username', username);
      }
      if (email != null) {
        modifierBuilder = modifierBuilder.set('email', email);
      }

      modifierBuilder = modifierBuilder.set('updatedAt', DateTime.now());

      final uid = UuidValue.withValidation(userId);

      final updatedUser = await usersColl.findAndModify(
        query: where.eq('_id', uid),
        update: modifierBuilder,
        returnNew: true,
      );

      if (updatedUser == null) {
        throw const TodoApiException(
          message: 'Fail to modify user',
          statusCode: HttpStatus.notFound,
        );
      }

      final userModel = UserModel.fromJson(updatedUser);

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
  Future<UserModel> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);

      final uid = UuidValue.withValidation(userId);

      final foundUser = await usersColl.findOne(where.eq('_id', uid));

      if (foundUser == null) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final matched = _passwordManager.checkPassword(
        oldPassword,
        foundUser['password'] as String,
      );

      if (!matched) {
        throw const TodoApiException(
          message: 'oldPassword not match',
          statusCode: HttpStatus.badRequest,
        );
      }

      final hashedPassword = _passwordManager.encryptPassword(newPassword);

      final updatedUser = await usersColl.findAndModify(
        query: where.eq('_id', uid),
        update: modify
            .set('password', hashedPassword)
            .set('updatedAt', DateTime.now()),
        returnNew: true,
      );

      if (updatedUser == null) {
        throw const TodoApiException(
          message: 'Fail to change password',
          statusCode: HttpStatus.notFound,
        );
      }

      final userModel = UserModel.fromJson(updatedUser);

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
  Future<void> deleteMe({required String userId}) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);
      final todosColl = db.collection(DbConstants.todosCollection);

      final uid = UuidValue.withValidation(userId);

      await todosColl.deleteMany(where.eq('userId', uid));

      await usersColl.deleteOne(where.eq('_id', uid));
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
