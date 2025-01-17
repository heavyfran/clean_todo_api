import 'package:postgres/postgres.dart';

import '../../env/env.dart';
import 'db_connection.dart';

class PostgresDbConnection implements DbConnection {
  Connection? _db;

  @override
  Connection get db =>
      _db ??= throw Exception('Postgres DB connection not initialized');

  @override
  Future<void> connect() async {
    if (_db == null || _db!.isOpen == false) {
      try {
        _db = await Connection.open(
          Endpoint(
            host: env[Env.pgHost]!,
            port: int.parse(env[Env.pgPort]!),
            database: env[Env.pgDb]!,
            username: env[Env.pgUsername],
            password: env[Env.pgPassword],
          ),
          settings: env[Env.mode] == 'dev'
              ? const ConnectionSettings(sslMode: SslMode.disable)
              : null,
        );
      } catch (e) {
        print('PostgreSQL connection failed');
        rethrow;
      }
    }
  }

  @override
  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
  }
}
