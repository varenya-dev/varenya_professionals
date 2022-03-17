import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/models/chat/thread/thread.model.dart';
import 'package:varenya_professionals/services/chat.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/chat/single_thread.widget.dart';

class Threads extends StatefulWidget {
  const Threads({Key? key}) : super(key: key);

  static const routeName = "/threads";

  @override
  _ThreadsState createState() => _ThreadsState();
}

class _ThreadsState extends State<Threads> {
  late ChatService _chatService;
  List<Thread> _threads = [];

  @override
  void initState() {
    super.initState();

    // Injecting required services from context.
    this._chatService = Provider.of<ChatService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: this._chatService.fetchAllThreads(),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.hasError) {
              log.e("Threads Error", snapshot.error, snapshot.stackTrace);
              return Text('Something went wrong, please try again later.');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildThreadsPage(context);
            }

            this._threads.clear();
            snapshot.data!.docs.forEach((thread) {
              this._threads.add(Thread.fromJson(thread.data()));
            });

            return _buildThreadsPage(context);
          },
        ),
      ),
    );
  }

  Widget _buildThreadsPage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsiveConfig(
            context: context,
            large: MediaQuery.of(context).size.width * 0.25,
            medium: MediaQuery.of(context).size.width * 0.25,
            small: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.black54,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateTime.now().hour < 12
                        ? 'Good Morning,'
                        : DateTime.now().hour >= 12 && DateTime.now().hour < 16
                            ? 'Good Afternoon,'
                            : 'Good Evening,',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      color: Theme.of(context).textTheme.subtitle1!.color,
                    ),
                  ),
                  Text(
                    this._threads.isEmpty
                        ? 'You have no messages yet'
                        : 'Your\nmessages',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.05,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
            if (this._threads.isNotEmpty)
              Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.07,
                    top: MediaQuery.of(context).size.height * 0.04),
                child: Text(
                  'Recent:',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            this._threads.isNotEmpty
                ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: this._threads.length,
                    itemBuilder: (context, index) {
                      Thread thread = this._threads[index];
                      return SingleThread(
                        chatThread: thread,
                      );
                    },
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'No messages here',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
