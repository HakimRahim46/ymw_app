import 'package:flutter/material.dart';
import 'database_helper.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(onPressed: () async {
              final dbHelper = DatabaseHelper();

              // Insert a new message with status 0 (unread)
              await dbHelper.insertMessage('Hello, world!', 0);

              // Refresh the UI
              setState(() {});
          }, 
          icon: const Icon(Icons.save),
          )
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getMessages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final message = snapshot.data![index];
                final statusText = message[DatabaseHelper.COLUMN_STATUS] == 0 ? 'Unread' : 'Read';
                return ListTile(
                  title: Text(message[DatabaseHelper.COLUMN_MESSAGE]),
                  subtitle: Text(statusText),
                  onTap: () {
                    dbHelper.updateMessageStatus(message[DatabaseHelper.COLUMN_ID]);
                    setState(() {});
                      },
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator(); // or any other placeholder widget
              }
            },
          )
        );
          
  }
}