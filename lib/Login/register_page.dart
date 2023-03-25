// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'login_helper_db.dart';
import 'user.dart';

class RegisterPage extends StatefulWidget {
RegisterPage({Key? key}) : super(key: key);

@override
_RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

DBHelper? dbHelper;
bool isLoading = false;

@override
void initState() {
super.initState();
dbHelper = DBHelper();
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text("Register"),
),
body: Form(
key: _formKey,
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
TextFormField(
controller: _nameController,
decoration: InputDecoration(
labelText: 'Name',
),
validator: (value) {
if (value!.isEmpty) {
return 'Please enter your name';
}
return null;
},
),
TextFormField(
controller: _emailController,
keyboardType: TextInputType.emailAddress,
decoration: InputDecoration(
labelText: 'Email',
),
validator: (value) {
if (value!.isEmpty) {
return 'Please enter your email';
}
return null;
},
),
TextFormField(
controller: _passwordController,
obscureText: true,
decoration: InputDecoration(
labelText: 'Password',
),
validator: (value) {
if (value!.isEmpty) {
return 'Please enter your password';
}
return null;
},
),
SizedBox(
height: 24.0,
),
isLoading
? CircularProgressIndicator()
// ignore: deprecated_member_use
: RaisedButton(
onPressed: () {
if (_formKey.currentState!.validate()) {
_registerUser();
}
},
child: Text('Register'),
),
],
),
),
),
);
}

_registerUser() async {
setState(() {
isLoading = true;
});

User user = User(
    name: _nameController.text,
    email: _emailController.text,
    password: _passwordController.text);

await dbHelper!.saveUser(user);

setState(() {
  isLoading = false;
});

Navigator.pop(context);

}
}