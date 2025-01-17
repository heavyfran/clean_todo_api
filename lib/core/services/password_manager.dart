import 'package:bcrypt/bcrypt.dart';

abstract interface class PasswordManager {
  String encryptPassword(String plainPassword);

  bool checkPassword(String plainPassword, String hashedPassword);
}

class BcryptHashPassword implements PasswordManager {
  @override
  String encryptPassword(String plainPassword) {
    final hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    return hashedPassword;
  }

  @override
  bool checkPassword(String plainPassword, String hashedPassword) {
    final matched = BCrypt.checkpw(plainPassword, hashedPassword);
    return matched;
  }
}
