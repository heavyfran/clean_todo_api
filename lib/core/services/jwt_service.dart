import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../env/env.dart';
import '../typedefs/typedefs.dart';

class JwtService {
  String sign(MapData payload) {
    final secret = env[Env.jwtSecret]!;
    final jwt = JWT(payload);
    return jwt.sign(
      SecretKey(secret),
      expiresIn: const Duration(days: 1),
    );
  }

  MapData? verify(String token) {
    try {
      final secret = env[Env.jwtSecret]!;
      final jwt = JWT.verify(token, SecretKey(secret));
      final payload = jwt.payload as MapData;
      return payload;
    } catch (e) {
      return null;
    }
  }
}
