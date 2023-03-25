// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'login_helper_db.dart';
import 'register_page.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
LoginPage({Key? key}) : super(key: key);

@override
_LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final _formKey = GlobalKey<FormState>();
final _scaffoldKey = GlobalKey<ScaffoldState>();
String? _email, _password;

@override
Widget build(BuildContext context) {
return Scaffold(
key: _scaffoldKey,
appBar: AppBar(
title: Text("Login"),
),
body: Form(
key: _formKey,
child: Column(
children: <Widget>[
TextFormField(
validator: (input) {
if (input!.isEmpty) {
return 'Please type an email';
}
return null;
},
onSaved: (input) => _email = input,
decoration: InputDecoration(labelText: 'Email'),
),
TextFormField(
validator: (input) {
if (input!.isEmpty) {
return 'Please type a password';
}
return null;
},
onSaved: (input) => _password = input,
decoration: InputDecoration(labelText: 'Password'),
obscureText: true,
),
// ignore: deprecated_member_use
RaisedButton(
onPressed: () async {
if (_formKey.currentState!.validate()) {
_formKey.currentState?.save();
User? user = await DBHelper()
.getUserByEmailAndPassword(_email!, _password!);
if (user != null) {
Navigator.pushNamed(context, '/home');
} else {
// ignore: deprecated_member_use
_scaffoldKey.currentState!.showSnackBar(
SnackBar(content: Text('Invalid email or password')));
}
}
},
child: Text('Login'),
),
// ignore: deprecated_member_use
FlatButton(
onPressed: () {
Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
},
child: Text('Create an account'),
),
// ignore: deprecated_member_use
 RaisedButton(
          onPressed: () {
            DBHelper().exportDatabase();
          },
          child: Text('Export Database'),
        ),
],
),
),
);
}
}