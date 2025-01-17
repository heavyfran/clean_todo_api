import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/sendgrid.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:password_generator/password_generator.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/db/db_connection.dart';
import '../../../../core/db/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/password_manager.dart';
import '../../../../env/env.dart';
import 'auth_data_source.dart';

class MongoAuthDataSource implements AuthDataSource {
  MongoAuthDataSource({
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
  Future<UserModel> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);

      final foundUser = await usersColl.findOne(where.eq('email', email));

      if (foundUser != null) {
        throw const TodoApiException(
          message: 'Email already taken',
          statusCode: HttpStatus.badRequest,
        );
      }

      final hashedPassword = _passwordManager.encryptPassword(password);

      final currentTime = DateTime.now();
      final response = await usersColl.insertOne({
        '_id': const Uuid().v4obj(),
        'username': username,
        'email': email,
        'password': hashedPassword,
        'createdAt': currentTime,
        'updatedAt': currentTime,
      });

      if (response.nInserted != 1) {
        throw const TodoApiException(
          message: 'Fail to create a user',
        );
      }

      final userModel = UserModel.fromJson(response.document!);

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
  Future<UserModel> signin({
    required String email,
    required String password,
  }) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);

      final response = await usersColl.findOne(where.eq('email', email));

      if (response == null) {
        throw const TodoApiException(
          message: 'Invalid credential',
          statusCode: HttpStatus.unauthorized,
        );
      }

      final savedPassword = response['password'] as String;

      final matched = _passwordManager.checkPassword(password, savedPassword);

      if (!matched) {
        throw const TodoApiException(
          message: 'Invalid credential',
          statusCode: HttpStatus.unauthorized,
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
  Future<void> resetPassword({required String email}) async {
    try {
      final usersColl = db.collection(DbConstants.usersCollection);

      final foundUser = await usersColl.findOne(where.eq('email', email));

      if (foundUser == null) {
        throw const TodoApiException(
          message: 'User not found',
          statusCode: HttpStatus.notFound,
        );
      }

      final newPassword = PasswordGenerator().generatePassword();

      final smtpServer = sendgrid(
        'apikey',
        env[Env.sendgridApiKey]!,
      );

      final message = Message()
        ..from = Address(env[Env.senderEmail]!, env[Env.senderName])
        ..recipients.add(email)
        ..subject = 'Your temporary password'
        ..html =
            '<h3>$newPassword</h3>\n<p>Please change your password after login</p>';

      await send(message, smtpServer);

      final hashedPassword = _passwordManager.encryptPassword(newPassword);

      final result = await usersColl.updateOne(
        where.eq('email', email),
        modify
            .set(
              'password',
              hashedPassword,
            )
            .set(
              'updatedAt',
              DateTime.now(),
            ),
      );

      if (result.nModified != 1) {
        throw const TodoApiException(
          message: 'Fail to change password',
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
