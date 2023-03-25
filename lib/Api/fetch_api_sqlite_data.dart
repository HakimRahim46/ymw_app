// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await insertData();

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter SQLite Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = [];
  int _limit = 10;

  Future<void> getData() async {
    // Get a location using getDatabasesPath
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'test.db');

    // Open the database
    final database = await openDatabase(path);

    // Query the table for up to `_limit` rows
    final List<Map<String, dynamic>> data = await database.rawQuery(
      'SELECT * FROM posts LIMIT $_limit',
    );

    setState(() {
      _data = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void loadMore() {
    setState(() {
      _limit += 10;
    });
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter SQLite Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: min(_data.length, _limit),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_data[index]['title']),
                  subtitle: Text(_data[index]['body']),
                );
              },
            ),
          ),
          if (_data.length > _limit)
  ElevatedButton(
    onPressed: loadMore,
    child: Text('See more'),
  ),
        ],
      ),
    );
  }
}

Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('http://192.168.68.158/test/data.json'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> insertData() async {
  // Get a location using getDatabasesPath
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'test.db');

  // Open the database
  final database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
        'CREATE TABLE posts (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT)',
      );
    },
  );

  // Fetch the data from the API
  final List<dynamic> data = await fetchData();

  // Insert the data into the database
  await database.transaction((txn) async {
    for (var item in data) {
      await txn.rawInsert(
        'INSERT INTO posts(title, body) VALUES("${item['title']}", "${item['body']}")',
      );
    }
  });
}