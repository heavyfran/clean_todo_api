import 'dart:io';

import 'package:clean_todo_api/core/db/db_connection.dart';
import 'package:clean_todo_api/core/db/mongo_db_connection.dart';
import 'package:clean_todo_api/core/db/postgres_db_connection.dart';
import 'package:clean_todo_api/env/env.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

late DbConnection _dbConnection;

Future<void> init(InternetAddress ip, int port) async {
  if (env[Env.activeDb] == 'postgres') {
    _dbConnection = PostgresDbConnection();

    try {
      await _dbConnection.connect();
      print('Successfully connected to ${env[Env.activeDb]}');
    } catch (e) {
      print('${env[Env.activeDb]} initialization error');
      exit(1);
    }
  } else {
    _dbConnection = MongoDbConnection();

    try {
      await _dbConnection.connect();
      print('Successfully connected to ${env[Env.activeDb]}');
      final mongoDb = _dbConnection.db as Db;
      await mongoDb.collection('users').createIndex(
            key: 'email',
            unique: true,
          );
      print('Index on email created');
    } catch (e) {
      print('${env[Env.activeDb]} initialization error');
      exit(1);
    }
  }
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  return serve(handler.use(dbHandler()), ip, port);
}

Middleware dbHandler() {
  return provider<DbConnection>((context) => _dbConnection);
}
