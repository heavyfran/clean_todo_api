import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/sendgrid.dart';
import 'package:password_generator/password_generator.dart';
import 'package:postgres/postgres.dart';

import '../../../../core/db/db_connection.dart';
import '../../../../core/db/db_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/password_manager.dart';
import '../../../../env/env.dart';
import 'auth_data_source.dart';

class PostgresAuthDataSource implements AuthDataSource {
  PostgresAuthDataSource({
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
  Future<UserModel> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final foundUser = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE email=@email
        '''),
        parameters: {'email': email},
      );

      if (foundUser.isNotEmpty) {
        throw const TodoApiException(
          message: 'Email already taken',
          statusCode: HttpStatus.badRequest,
        );
      }

      final hashedPassword = _passwordManager.encryptPassword(password);

      final result = await db.execute(
        Sql.named('''
          INSERT INTO ${DbConstants.usersTable}
            (username, email, password)
          VALUES
            (@username, @email, @password)
          RETURNING *
        '''),
        parameters: {
          'username': username,
          'email': email,
          'password': hashedPassword,
        },
      );

      if (result.affectedRows != 1) {
        throw const TodoApiException(message: 'Failed to create a user');
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
  Future<UserModel> signin({
    required String email,
    required String password,
  }) async {
    try {
      final result = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE email=@email
        '''),
        parameters: {'email': email},
      );

      if (result.isEmpty) {
        throw const TodoApiException(
          message: 'Invalid credential',
          statusCode: HttpStatus.unauthorized,
        );
      }

      final userMap = result.first.toColumnMap();
      final savedPassword = userMap['password'] as String;
      final matched = _passwordManager.checkPassword(password, savedPassword);

      if (!matched) {
        throw const TodoApiException(
          message: 'Invalid credential',
          statusCode: HttpStatus.unauthorized,
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
  Future<void> resetPassword({required String email}) async {
    try {
      final foundUser = await db.execute(
        Sql.named('''
          SELECT * FROM ${DbConstants.usersTable}
          WHERE email=@email
        '''),
        parameters: {'email': email},
      );

      if (foundUser.isEmpty) {
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

      final result = await db.execute(
        Sql.named('''
          UPDATE ${DbConstants.usersTable}
          SET
            password=@password,
            updated_at=current_timestamp
          WHERE
            email=@email
          RETURNING *
        '''),
        parameters: {
          'password': hashedPassword,
          'email': email,
        },
      );

      if (result.affectedRows != 1) {
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
