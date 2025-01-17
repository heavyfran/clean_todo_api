abstract interface class DbConnection {
  dynamic get db;

  Future<void> connect();

  Future<void> close();
}
