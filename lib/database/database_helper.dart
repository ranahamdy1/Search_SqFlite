import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DatabaseHelper {

  static const String _databaseName = 'users.db'; // Database Name
  static const int _databaseVersion = 1; // Database Version
  static const String _tableName = 'users'; // Table Name
  static const String _columnId = 'id'; // ID Column Name
  static const String _columnUserName = 'username'; //Username Column Name
  static const String _columnEmail = 'email'; //Email Column Name

  DatabaseHelper._internal(); //Private Constructor
  static final DatabaseHelper instance =
      DatabaseHelper._internal(); //Create Instance Of Private Constructor
  static Database? _db; //Database Variable


  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }


  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final String path = '$dbPath/$_databaseName';
    log(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  _onCreate(Database db, int version) async {
    db.execute('''
CREATE TABLE $_tableName (
  $_columnId INTEGER PRIMARY KEY,
  $_columnUserName TEXT NOT NULL,
  $_columnEmail TEXT NOT NULL
)
''');
  }


  Future<List<User>> getAllUsers() async {
    Database db = await instance._database;
    List<Map<String, dynamic>> response = await db.query(_tableName, columns: [
      _columnId,
      _columnUserName,
      _columnEmail,
    ]);
    return response.map((e) => User.fromMap(e)).toList();
  }


  Future<int> insertToDatabase(User user) async {
    Database db = await instance._database;
    return await db.insert(_tableName, user.toMap());
  }


  Future<int> deleteFromDatabase(int id) async {
    Database db = await instance._database;
    return await db
        .delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }

  /*Future<List<User>> searchUsers(String pattern) async {
    Database db = await instance._database;
    final response = await db.query(_tableName,
        columns: [
          _columnId,
          _columnUserName,
          _columnEmail,
        ],
        where: '$_columnUserName LIKE ?',
        whereArgs: ['%$pattern%']);
    return response.map((e) => User.fromMap(e)).toList();
  }*/
}
