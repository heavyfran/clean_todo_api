import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../../../../core/services/jwt_service.dart';
import '../../../../core/typedefs/typedefs.dart';
import '../../../../core/validators/input_validators.dart';
import '../../../../core/validators/validators_constants.dart';
import '../../domain/dtos/request/request.dart';
import '../../domain/usecases/usecases.dart';
import 'auth_controller.dart';

class AuthControllerImpl implements AuthController {
  AuthControllerImpl({
    required SignupUsecase signupUsecase,
    required SigninUsecase signinUsecase,
    required ResetPasswordUsecase resetPasswordUsecase,
    required JwtService jwtService,
    required InputValidators inputValidators,
  })  : _signupUsecase = signupUsecase,
        _signinUsecase = signinUsecase,
        _resetPasswordUsecase = resetPasswordUsecase,
        _jwtService = jwtService,
        _inputValidators = inputValidators;

  final SignupUsecase _signupUsecase;
  final SigninUsecase _signinUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final JwtService _jwtService;
  final InputValidators _inputValidators;

  @override
  Future<Response> signup(RequestContext context) async {
    final body = await context.request.json() as MapData;

    final username = body['username'] as String?;
    final email = body['email'] as String?;
    final password = body['password'] as String?;

    final errors = <String, String>{};

    if (username == null || _inputValidators.username(username)) {
      errors['username'] = ValidatorsConstants.invalidUsername;
    }

    if (email == null || _inputValidators.email(email)) {
      errors['email'] = ValidatorsConstants.invalidEmail;
    }

    if (password == null || _inputValidators.password(password)) {
      errors['password'] = ValidatorsConstants.invalidPassword;
    }

    if (errors.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errors,
      );
    }

    final result = await _signupUsecase(
      SignupRequestModel(
        username: username!,
        email: email!,
        password: password!,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {
            'message': failure.message,
          },
        );
      },
      (user) {
        final payload = user.toJson();

        final token = _jwtService.sign(payload);

        return Response.json(
          statusCode: HttpStatus.created,
          body: {
            'token': token,
            'id': user.id,
          },
        );
      },
    );
  }

  @override
  Future<Response> signin(RequestContext context) async {
    final body = await context.request.json() as MapData;

    final email = body['email'] as String?;
    final password = body['password'] as String?;

    final errors = <String, String>{};

    if (email == null || _inputValidators.email(email)) {
      errors['email'] = ValidatorsConstants.invalidEmail;
    }

    if (password == null || _inputValidators.password(password)) {
      errors['password'] = ValidatorsConstants.invalidPassword;
    }

    if (errors.isNotEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: errors,
      );
    }

    final result = await _signinUsecase(
      SigninRequestModel(
        email: email!,
        password: password!,
      ),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {
            'message': failure.message,
          },
        );
      },
      (user) {
        final payload = user.toJson();

        final token = _jwtService.sign(payload);

        return Response.json(
          body: {
            'token': token,
            'id': user.id,
          },
        );
      },
    );
  }

  @override
  Future<Response> resetPassword(RequestContext context) async {
    final body = await context.request.json() as MapData;
    final email = body['email'] as String?;

    if (email == null || _inputValidators.email(email)) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'message': 'Enter valid email'},
      );
    }

    final result = await _resetPasswordUsecase(
      ResetPasswordRequestModel(email: email),
    );

    return result.match(
      (failure) {
        return Response.json(
          statusCode: failure.statusCode,
          body: {'message': failure.message},
        );
      },
      (_) {
        return Response.json(
          body: {
            'message': 'Check your email for temporary password',
          },
        );
      },
    );
  }
}
