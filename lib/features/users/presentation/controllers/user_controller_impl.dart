import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/validators/input_validators.dart';
import '../../../../core/validators/validators_constants.dart';
import '../../domain/dtos/request/request.dart';
import '../../domain/dtos/response/user_response_model.dart';
import '../../domain/usecases/usecases.dart';
import 'user_controller.dart';

class UserControllerImpl implements UserController {
  UserControllerImpl({
    required InputValidators inputValidators,
    required UpdateMeUsecase updateMeUsecase,
    required ChangePasswordUsecase changePasswordUsecase,
    required DeleteMeUsecase deleteMeUsecase,
  })  : _inputValidators = inputValidators,
        _updateMeUsecase = updateMeUsecase,
        _changePasswordUsecase = changePasswordUsecase,
        _deleteMeUsecase = deleteMeUsecase;

  final InputValidators _inputValidators;
  final UpdateMeUsecase _updateMeUsecase;
  final ChangePasswordUsecase _changePasswordUsecase;
  final DeleteMeUsecase _deleteMeUsecase;

  @override
  Response getMe(RequestContext context) {
    final user = context.read<UserResponseModel>();

    return Response.json(
      body: {'user': user},
    );
  }

  @override
  Future<Response> updateMe(RequestContext context) async {
    final body = await context.request.json() as MapData;
    final user = context.read<UserResponseModel>();

    final username = body['username'] as String?;
    final email = body['email'] as String?;

    final errors = <String, String>{};

    if (username == null && email == null) {
      errors['username'] = ValidatorsConstants.invalidUsername;
      errors['email'] = ValidatorsConstants.invalidEmail;
    }
    if (username != null && _inputValidators.username(username)) {
      errors['username'] = ValidatorsConstants.invalidUsername;
    }
    if (email != null && _inputValidators.email(email)) {
      errors['email'] = ValidatorsConstants.invalidEmail;
    }

    if (errors.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errors,
      );
    }

    final result = await _updateMeUsecase(
      UpdateMeRequestModel(
        userId: user.id,
        username: username,
        email: email,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (updatedUser) {
        return Response.json(
          body: updatedUser,
        );
      },
    );
  }

  @override
  Future<Response> changePassword(RequestContext context) async {
    final body = await context.request.json() as MapData;

    final oldPassword = body['oldPassword'] as String?;
    final newPassword = body['newPassword'] as String?;

    final errors = <String, String>{};

    if (oldPassword == null || _inputValidators.password(oldPassword)) {
      errors['oldPassword'] = ValidatorsConstants.invalidPassword;
    }
    if (newPassword == null || _inputValidators.password(newPassword)) {
      errors['newPassword'] = ValidatorsConstants.invalidPassword;
    }

    if (errors.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errors,
      );
    }

    final user = context.read<UserResponseModel>();

    final result = await _changePasswordUsecase(
      ChangePasswordRequestModel(
        userId: user.id,
        oldPassword: oldPassword!,
        newPassword: newPassword!,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (user) {
        return Response.json(
          body: user,
        );
      },
    );
  }

  @override
  Future<Response> deleteMe(RequestContext context) async {
    final user = context.read<UserResponseModel>();

    final result = await _deleteMeUsecase(
      DeleteMeRequestModel(userId: user.id),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (_) {
        return Response(statusCode: HttpStatus.noContent);
      },
    );
  }
}
