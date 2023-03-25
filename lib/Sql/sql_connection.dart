// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe, unused_import
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/material.dart';

class SqlTestPage extends StatefulWidget {

  const SqlTestPage(
      {Key? key,
      })
      : super(key: key);
  @override
  SqlTestPageState createState() => SqlTestPageState();
}

class SqlTestPageState extends State<SqlTestPage> {
  

Future main() async {
  // Open a connection (testdb should already exist)
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '192.168.68.182',
      port: 3306,
      user: 'root',
      db: 'dm_mbs',
      password: 'root1234'));

  // Create a table
  await conn.query(
      'CREATE TABLE test_user (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), age int)');

  // Insert some data
  var result = await conn.query(
      'insert into test_user (name, email, age) values (?, ?, ?)',
      ['Bob', 'bob@bob.com', 25]);
  print('Inserted row id=${result.insertId}');

  // Query the database using a parameterized query
  var results = await conn.query(
      'select name, email, age from test_user where id = ?', [result.insertId]);
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Update some data
  await conn.query('update test_users set age=? where name=?', [26, 'Bob']);

  // Query again database using a parameterized query
  var results2 = await conn.query(
      'select name, email, age from test_user where id = ?', [result.insertId]);
  for (var row in results2) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Finally, close the connection
  await conn.close();
}

@override
  void initState() {
    super.initState();
    main();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          // ignore: avoid_unnecessary_containers
          body: Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                    ]),
              ),
            ),
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: BottomAppBar(
          //   shape: const CircularNotchedRectangle(),
          //   // ignore: avoid_unnecessary_containers
          //   child: Container(
          //     child: Row(
          //       mainAxisSize: MainAxisSize.max,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         Container(
          //           padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
          //           child: IconButton(
          //               icon: Icon(
          //                 Icons.center_focus_strong,
          //                 color: Colors.blueAccent[700],
          //               ),
          //               iconSize: 30, onPressed: (){}),
          //         ),
          //         const SizedBox(height: 30),
          //         Container(
          //           padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
          //           child: IconButton(
          //             icon: Icon(
          //               Icons.camera_alt,
          //               color: Colors.redAccent[700],
          //             ),
          //             iconSize: 30,
          //             onPressed: () {},
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // // ignore: sized_box_for_whitespace
          // floatingActionButton: Container(
          //   height: 50.0,
          //   width: 50.0,
          //   child: FittedBox(
          //     child: FloatingActionButton(
          //       backgroundColor: Colors.purpleAccent[700],
          //       onPressed: () {
          //         // ignore: unnecessary_null_comparison
          //         if (_webViewController != null) {
          //           _webViewController.reload();
          //         }
          //       },
          //       child: const Icon(
          //         Icons.home,
          //         color: Colors.white,
          //       ),
          //       // elevation: 5.0,
          //     ),
          //   ),
          // ),
        );
  }
}
