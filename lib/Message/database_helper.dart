// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;
  static const String DB_NAME = 'my.db';
  static const String TABLE_NAME = 'messages';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_MESSAGE = 'message';
  static const String COLUMN_STATUS = 'status';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $TABLE_NAME (
        $COLUMN_ID INTEGER PRIMARY KEY,
        $COLUMN_MESSAGE TEXT,
        $COLUMN_STATUS INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    var dbClient = await db;
    var res = await dbClient!.query(TABLE_NAME, orderBy: '$COLUMN_ID DESC');
    return res;
  }

  Future<int> insertMessage(String message, int status) async {
  var dbClient = await db;
  return await dbClient!.insert(
    TABLE_NAME,
    {COLUMN_MESSAGE: message, COLUMN_STATUS: status},
  );
}

  Future<int> updateMessageStatus(int id) async {
    var dbClient = await db;
    return await dbClient!.update(
      TABLE_NAME,
      {COLUMN_STATUS: 1},
      where: '$COLUMN_ID = ?',
      whereArgs: [id],
    );
  }
}