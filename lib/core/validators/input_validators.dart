import 'package:string_validator/string_validator.dart';

class InputValidators {
  bool username(String username) {
    return !isLength(username.trim(), 2, 12) || false;
  }

  bool email(String email) {
    return !isEmail(email.trim()) || false;
  }

  bool password(String password) {
    return !isLength(password.trim(), 6, 20) || false;
  }
}
