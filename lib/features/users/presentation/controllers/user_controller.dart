import 'package:dart_frog/dart_frog.dart';

abstract interface class UserController {
  Response getMe(RequestContext context);

  Future<Response> updateMe(RequestContext context);

  Future<Response> changePassword(RequestContext context);

  Future<Response> deleteMe(RequestContext context);
}
