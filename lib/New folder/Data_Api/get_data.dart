// ignore_for_file: depend_on_referenced_packages, unnecessary_import, unused_field, prefer_final_fields, avoid_unnecessary_containers

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../model/getdata.dart';
import 'fetch_data.dart';

// ignore: must_be_immutable
class SearchNama extends StatefulWidget {
  final String title = 'Senarai Aset Alih';


  const SearchNama({Key? key,}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchNamaState createState() => _SearchNamaState();
}


class _SearchNamaState extends State<SearchNama> {
  late String title;
  TextEditingController searchController = TextEditingController();
  TextEditingController searchScanController = TextEditingController();
  late String resultbarcode;
  bool _isSearch = false;
  bool _isSearchScan = false;

  late String barcodedata;

  Future<List<Users>> _getUsers() async {
    Map<String, String> querySearchFormParams = {
      'label': 'abc0',
      'cost': '1112',
    };

    String querySearchFormParamsString =
        Uri(queryParameters: querySearchFormParams).query;

    String barcodedata = searchController.text;

    Map<String, String> queryParams = {
      'fstart': '0',
      'flimit': '10',
      'barcode_data': barcodedata,
      'method': 'list',
      'formJson': querySearchFormParamsString,
    };

    var endpointUrl = 'http://mmzsystem.no-ip.org:8080/api_mobile/aset.cfc';

    String queryString = Uri(queryParameters: queryParams).query;
    var requestUrl = endpointUrl + '?' + queryString;
    print(requestUrl);
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      // print(response.statusCode);
      final usersResponse = json.decode(response.body);

      List<Users> users = [];
      for (var i = 0; i < usersResponse.length; i++) {
        final user = Users.fromJson(usersResponse[i]);
        users.add(user);
        // print(user.barcodedata);
      }

      return users;
    } else {
      throw Exception('Failed to load post');
    }
  }

  // String url = "http://mmzsystem.no-ip.org:8080/api_mobile/aset.cfc";
  // insertData() async {
  //   var response =
  //       await http.post(url, body: {"searchcontroller": searchController.text});

  //   // ignore: unused_local_variable
  //   var body = jsonDecode(response.body);

  //   if (response.statusCode == 200) {
  //     debugPrint("Data posted successfully");
  //     print(response.statusCode);
  //     print(response.body);
  //     Fluttertoast.showToast(
  //         msg: "${response.body}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.blueAccent[700],
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   } else {
  //     debugPrint(
  //         "Something went wrong! Status Code is: ${response.statusCode}");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _getUsers().then((userFromServer) => {
          setState(() {
            users = userFromServer;
          })
        });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ignore: deprecated_member_use
  List<Users> users = <Users>[];
  // ignore: deprecated_member_use
  List<Users> filtered = <Users>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 65,
        backgroundColor: Colors.blueAccent[700],
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(5.0),
          ),
          // if (_isSearchScan)
          //   TextField(
          //     onChanged: (text) {
          //       _debouncer.run(() {
          //         setState(() {
          //           filtered = users
          //               .where((u) => (u.label
          //                       .toLowerCase()
          //                       .contains(text.toLowerCase()) ||
          //                   // u.barcodedata
          //                   //     .toLowerCase()
          //                   //     .contains(text.toLowerCase()) ||
          //                   u.lokasiPenempatan
          //                       .toLowerCase()
          //                       .contains(text.toLowerCase())))
          //               .toList();
          //         });
          //       });
          //     },
          //     controller: this.searchScanController = TextEditingController()
          //       ..text = resultbarcode,
          //     decoration: InputDecoration(
          //         hintText: "Cari",
          //         prefixIcon: IconButton(
          //           icon: Icon(Icons.cancel),
          //           onPressed: () {
          //             clearTextInput();
          //           },
          //         ),
          //         suffixIcon: IconButton(
          //             icon: Icon(Icons.search),
          //             onPressed: () {
          //               setState(() {
          //                 _isSearchScan = false;
          //                 // resultbarcode = searchController.text;
          //                 // print(searchController.text);
          //               });
          //             }),
          //         border: OutlineInputBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          //   ),
          // if (_isSearch)
          //   TextField(
          //     onChanged: (text) {
          //       _debouncer.run(() {
          //         setState(() {
          //           filtered = users
          //               .where((u) => (u.label
          //                       .toLowerCase()
          //                       .contains(text.toLowerCase()) ||
          //                   u.barcodedata
          //                       .toLowerCase()
          //                       .contains(text.toLowerCase()) ||
          //                   u.lokasiPenempatan
          //                       .toLowerCase()
          //                       .contains(text.toLowerCase())))
          //               .toList();
          //         });
          //       });
          //     },
          //     controller: this.searchController = TextEditingController()
          //       ..text = resultbarcode,
          //     decoration: InputDecoration(
          //       prefixIcon: IconButton(
          //           icon: Icon(Icons.cancel),
          //           onPressed: () {
          //             setState(() {
          //               clearTextInput();
          //             });
          //           }),
          //       suffixIcon: IconButton(
          //           icon: Icon(Icons.search),
          //           onPressed: () {
          //             setState(() {
          //               _isSearch = false;
          //               print(searchController.text);
          //               insertData();
          //             });
          //           }),
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.all(Radius.circular(25.0))),
          //     ),
          //   ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  Users users = filtered[index];
                  return UserListTile(
                    users: users,
                  );
                }),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _isSearch = true;
            });
          },
          backgroundColor: Colors.blueAccent[900],
          child: const Icon(Icons.search)),
    );
  }

  clearTextInput() {
    searchController.text = "";
  }
}
