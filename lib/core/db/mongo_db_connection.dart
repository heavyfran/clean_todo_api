import 'package:mongo_dart/mongo_dart.dart';

import '../../env/env.dart';
import 'db_connection.dart';

class MongoDbConnection implements DbConnection {
  Db? _db;

  @override
  Db get db => _db ??= throw Exception('MongoDB connection not initialized');

  @override
  Future<void> connect() async {
    if (_db == null || _db!.isConnected == false) {
      try {
        final mode = env[Env.mode];
        final host = env[Env.mongoHost];
        final port = env[Env.mongoPort];
        final username = env[Env.mongoUsername];
        final password = env[Env.mongoPassword];
        final database = env[Env.mongoDb];

        if (mode == 'prod' || mode == 'test') {
          _db = await Db.create(
            'mongodb+srv://$username:$password@$host/$database?retryWrites=true&w=majority&appName=Cluster0',
          );
        } else {
          _db = await Db.create('mongodb://$host:$port/$database');
        }
        await _db!.open();
      } catch (e) {
        print('MongoDB connection failed');
        rethrow;
      }
    }
  }

  @override
  Future<void> close() async {
    if (_db != null && _db!.isConnected == true) {
      await _db!.close();
    }
  }
}
