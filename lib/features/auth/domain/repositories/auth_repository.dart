import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';

abstract interface class AuthRepository {
  FutureEither<User> signup({
    required String username,
    required String email,
    required String password,
  });

  FutureEither<User> signin({
    required String email,
    required String password,
  });

  FutureEither<void> resetPassword({
    required String email,
  });
}
