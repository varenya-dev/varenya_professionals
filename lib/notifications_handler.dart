import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/arguments/chat.argument.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/chat/chat.page.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/chat.service.dart';
import 'package:varenya_professionals/services/user_service.dart';

import 'pages/common/loading_page.dart';

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
  late final UserService _userService;
  late final AlertsService _alertsService;

  bool loading = false;

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
      String userId = message.data['byUser'];
      String threadId = message.data['thread'];
      ServerUser serverUser = await this._userService.findUserById(userId);

      Navigator.pushNamed(
        context,
        Chat.routeName,
        arguments: ChatArgument(
          serverUser: serverUser,
          threadId: threadId,
        ),
      );
    }
    if (message.data['type'] == 'sos') {
      String userId = message.data['userId'];
      String threadId = await this._chatService.createNewThread(userId);
      await this._alertsService.sendSOSResponseNotification(threadId);

      Navigator.pushNamed(
        context,
        Chat.routeName,
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
    this._userService = Provider.of<UserService>(context, listen: false);

    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? LoadingPage() : widget.child;
  }
}
