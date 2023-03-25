// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, no_logic_in_create_state, annotate_overrides

import 'package:flutter/material.dart';

import '../model/getdata.dart';

class UserListTile extends StatefulWidget {
  final Users users;

  UserListTile({required this.users, Key? key}) : super(key: key);

  UserListTileState createState() => UserListTileState(users);
}

class UserListTileState extends State<UserListTile> {
  final Users users;

  UserListTileState(this.users);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: (){},
          child: Card(
            child: ListTile(
              leading: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  shape: CircleBorder(),
                ),
                child: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onPressed: (){},
              ),
              title: Text("Label: ${users.label}",
                  style: TextStyle(fontSize: 16.5)),
              subtitle: Text(
                //Jarak untuk Three Lines
                "jenis: ${users.jenishartaDesc}                                                                                                     Lokasi: ${users.lokasiPenempatan}",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15.0),
              ),
              isThreeLine: true,
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }
}
