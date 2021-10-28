import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/chat/chat_page.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/chat_service.dart';

class NotificationsHandler extends StatefulWidget {
  final Widget child;

  const NotificationsHandler({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _NotificationsHandlerState createState() => _NotificationsHandlerState();
}

class _NotificationsHandlerState extends State<NotificationsHandler> {
  late final FirebaseMessaging _firebaseMessaging;
  late final ChatService _chatService;
  late final AlertsService _alertsService;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await this._firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['type'] == 'chat') {
      Navigator.pushNamed(
        context,
        ChatPage.routeName,
        arguments: message.data['thread'],
      );
    }
    if (message.data['type'] == 'sos') {
      String userId = message.data['userId'];
      String threadId = await this._chatService.createNewThread(userId);
      await this._alertsService.sendSOSResponseNotification(threadId);

      Navigator.pushNamed(
        context,
        ChatPage.routeName,
        arguments: threadId,
      );
    }

    if (message.data['type'] == 'appointment') {
      Navigator.pushNamed(context, AppointmentList.routeName);
    }
  }

  @override
  void initState() {
    super.initState();

    this._firebaseMessaging = FirebaseMessaging.instance;
    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);

    setupInteractedMessage()
        .then((_) => print('FIREBASE MESSAGING HAS BEEN SETUP'))
        .catchError((error) => print("FIREBASE MESSAGING ERROR: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
