import '../../../../core/entities/user_entitiy.dart';
import '../../../../core/typedefs/typedefs.dart';

abstract interface class UserRepository {
  FutureEither<User> findUserById({required String userId});

  FutureEither<User> updateMe({
    required String userId,
    String? username,
    String? email,
  });

  FutureEither<User> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

  FutureEither<void> deleteMe({required String userId});
}
