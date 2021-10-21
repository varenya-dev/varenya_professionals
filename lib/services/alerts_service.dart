import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AlertsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> toggleSubscribeToSOSTopic(bool subscribe) async {
    if (subscribe)
      await this._firebaseMessaging.subscribeToTopic('sos');
    else
      await this._firebaseMessaging.unsubscribeFromTopic('sos');
  }
}
