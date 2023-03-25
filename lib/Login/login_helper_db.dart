// ignore_for_file: avoid_print, prefer_is_empty, unnecessary_new, constant_identifier_names

import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'user.dart';

class DBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PASSWORD = 'password';
  static const String TABLE = 'User';
  static const String DB_NAME = 'users.db';

  Future<void> exportDatabase() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String databasePath = join(documentsDirectory.path, 'users.db');
  Database database = await openDatabase(databasePath);

  List<Map> data = await database.rawQuery('SELECT * FROM $TABLE');
  List<int> bytes = Uint8List.fromList(data.toString().codeUnits);

  io.Directory? backupDirectory = await getExternalStorageDirectory();
  String backupPath = join(backupDirectory!.path, 'users.db');
  File backupFile = File(backupPath);

  await backupFile.writeAsBytes(bytes);
  await database.close();
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentDirectory =
        await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, DB_NAME);
    print(documentDirectory.path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $NAME TEXT, $EMAIL TEXT, $PASSWORD TEXT)");
  }

  Future<User> saveUser(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert(TABLE, user.toMap());
    return user;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE, columns: [ID, NAME, EMAIL, PASSWORD]);
    List<User> users = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        users.add(User.fromMap(maps[i]));
      }
    }
    return users;
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, user.toMap(),
        where: '$ID = ?', whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<User?> getUserByEmailAndPassword(
      String email, String password) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $TABLE WHERE $EMAIL = '$email' AND $PASSWORD = '$password'");
    if (result.length > 0) {
      return new User.fromMap(result.first);
    }
    return null;
  }
}
