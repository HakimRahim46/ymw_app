// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'task.dart';

class CardWidget extends StatefulWidget {
  final Task task;
  const CardWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  // Add any state variables and methods here
  Task? task;
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
    return  Card(
        elevation: 8,
        shadowColor: const Color(0xff2da9ef),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: ListView.builder(
              itemCount: min(_data.length, _limit),
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          minLeadingWidth: task!.isDone ? 0 : 2,
          leading: task!.isDone
              ? const SizedBox()
              : Container(
                  width: 2,
                  color: const Color(0xff2da9ef),
                ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _data[index]['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            _data[index]['body'],
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 16,
            ),
          ),
          trailing: Text(
            task!.isDone ? 'Done' : DateFormat('hh:mm a').format(task!.taskTime),
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 16,
            ),
          ),
        );
        }),
      
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
 