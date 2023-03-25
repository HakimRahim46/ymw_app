// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, unused_import, deprecated_member_use, prefer_const_literals_to_create_immutables, unnecessary_const

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ywmapp/Message/message_page.dart';
import 'package:ywmapp/Webview/webview_dashboard.dart';


import 'ListView/list_view_page.dart';
import 'home_test.dart';
import 'login_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await insertData();

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebViewPageLogin(),
      // initialRoute: '/login',
      // routes: {
      //   '/login': (context) => LoginPage(),
      //   '/home': (context) => HomePage(),
      // },
    );
  }
}

class AuthService {
  Future<bool> login(String email, String password) async {
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  if (!emailRegex.hasMatch(email)) {
    // show error message indicating that the email is invalid
    return false;
  }

  final response = await http.post(
    Uri.parse('http://192.168.68.158/test/login.json/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    // Login successful
    final jsonResponse = json.decode(response.body);
    final token = jsonResponse['token'];
    _saveToken(token);
    return true;
  } else {
    // Login failed
    return false;
  }
}
Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _data = [];
  int _limit = 10;
  final PageController _pageController = PageController();
  // ignore: unused_field
  int _currentPageIndex = 0;

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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: size.width,
                height: size.height / 3,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff8d70fe),
                      Color(0xff2da9ef),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Mesej',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height / 4.5,
              left: 16,
              child: Container(
                width: size.width - 32,
                height: size.height / 1.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Expanded(
                    child: Column(
              children: [
                Row(
            children: [
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    _pageController.jumpToPage(0);
                    setState(() {
                      _currentPageIndex = 0;
                    });
                  },
                  child: const Text('INBOX'),
                ),
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () {
                    _pageController.jumpToPage(1);
                    setState(() {
                      _currentPageIndex = 1;
                    });
                  },
                  child: const Text('READ'),
                ),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                // Tab 1 content
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
                // Tab 2 content
                const Center(
                  child: const Text('Tab 2 content'),
                ),
              ],
            ),
          ),
                
        ],
      ),
                  ),),))
            
      ]),
      )
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