// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'db_helper.dart';
import 'model.dart';

final String apiUrl = 'https://your-api-url.com/users';

Future<void> fetchDataAndInsertIntoDatabase() async {
  final response = await http.get(Uri.parse(apiUrl));
  final List<dynamic> data = jsonDecode(response.body);

  for (var userJson in data) {
    final User user = User.fromJson(userJson);
    await DatabaseHelper.instance.insert(user);
  }
}