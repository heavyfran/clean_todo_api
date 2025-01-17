import '../../../../core/models/user_model.dart';

abstract interface class UserDataSource {
  Future<UserModel> findUserById({required String userId});

  Future<UserModel> updateMe({
    required String userId,
    String? username,
    String? email,
  });

  Future<UserModel> changePassword({
    required String userId,
    required String oldPassword,
    required String newPassword,
  });

  Future<void> deleteMe({required String userId});
}
