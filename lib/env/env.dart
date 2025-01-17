import 'package:dotenv/dotenv.dart';

final env = DotEnv(includePlatformEnvironment: true)..load();

abstract class Env {
  static const String mode = 'MODE';
  static const String pgHost = 'PG_HOST';
  static const String pgPort = 'PG_PORT';
  static const String pgDb = 'PG_DB';
  static const String pgUsername = 'PG_USERNAME';
  static const String pgPassword = 'PG_PASSWORD';
  static const String mongoHost = 'MONGO_HOST';
  static const String mongoPort = 'MONGO_PORT';
  static const String mongoDb = 'MONGO_DB';
  static const String mongoUsername = 'MONGO_USERNAME';
  static const String mongoPassword = 'MONGO_PASSWORD';
  static const String activeDb = 'ACTIVE_DB';
  static const String jwtSecret = 'JWT_SECRET';
  static const String sendgridApiKey = 'SENDGRID_API_KEY';
  static const String senderEmail = 'SENDER_EMAIL';
  static const String senderName = 'SENDER_NAME';
}
