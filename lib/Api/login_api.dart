import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://192.168.68.158/test/login.json'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  if (response.statusCode == 200) {
    // The API call was successful, parse the response
    final jsonResponse = jsonDecode(response.body);
    final token = jsonResponse['token'] as String; // use a string key to access the 'token' value
    return token;
  } else {
    // The API call was unsuccessful, throw an error
    throw Exception('Failed to log in');
  }
}