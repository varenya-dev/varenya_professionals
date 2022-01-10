import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/models/chat/chat_thread/chat_thread_model.dart';
import 'package:varenya_professionals/services/chat_service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

import 'chat_page.dart';

class ThreadsPage extends StatefulWidget {
  const ThreadsPage({Key? key}) : super(key: key);

  static const routeName = "/threads";

  @override
  _ThreadsPageState createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  late ChatService _chatService;
  List<ChatThread> _threads = [];

  @override
  void initState() {
    super.initState();

    // Injecting required services from context.
    this._chatService = Provider.of<ChatService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Threads'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: this._chatService.fetchAllThreads(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (snapshot.hasError) {
            log.e("ThreadsPage Error", snapshot.error, snapshot.stackTrace);

            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          this._threads.clear();
          snapshot.data!.docs.forEach((thread) {
            this._threads.add(ChatThread.fromJson(thread.data()));
          });

          return ListView.builder(
            itemCount: this._threads.length,
            itemBuilder: (context, index) {
              ChatThread thread = this._threads[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(thread.id),
                subtitle: Text(thread.participants.join(", ")),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ChatPage.routeName,
                    arguments: thread.id,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
