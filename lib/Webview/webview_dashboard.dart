// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class WebViewPageLogin extends StatefulWidget {

  const WebViewPageLogin(
      {Key? key,
      })
      : super(key: key);
  @override
  WebViewPageLoginState createState() => WebViewPageLoginState();
}

class WebViewPageLoginState extends State<WebViewPageLogin> {
  final TextEditingController _teController = TextEditingController();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  // ignore: unused_field
  late WebViewController _webViewController;
  bool showLoading = false;
  String qrResult = "";
  DateTime? backbuttonpress;

  void updateLoading(bool ls) {
    // ignore: unnecessary_this
    this.setState(() {
      showLoading = ls;
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          // ignore: avoid_unnecessary_containers
          body: Container(
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                        flex: 10,
                        child: WebView(
                          initialUrl:
                              "http://192.168.68.158/ywm/index_mobile.cfm",
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated:
                              (WebViewController webViewController) {
                            _controller.complete(webViewController);
                            _webViewController = webViewController;
                          },
                          // ignore: prefer_collection_literals
                          javascriptChannels: Set.from([
                            JavascriptChannel(
                                name: 'flutter',
                                onMessageReceived: (JavascriptMessage message) {
                                  if (message.message == 'open_flutter_page') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                                    );
                                  }
                                }),
                          ]),
                        ),
                      ),
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
        ));
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    // ignore: unnecessary_null_comparison
    bool backButton = backbuttonpress == null ||
        currentTime.difference(backbuttonpress!) > const Duration(seconds: 3);

    if (backButton) {
      backbuttonpress = currentTime;
      Fluttertoast.showToast(
          msg: 'Tekan Dua Kali Untuk Kembali',
          backgroundColor: Colors.lightBlue[700],
          textColor: Colors.white);

      return false;
    }
    return true;
  }

  clearTextInput() {
    _teController.clear();
  }
}
