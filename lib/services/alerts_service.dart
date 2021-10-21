import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:http/http.dart' as http;

class AlertsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> toggleSubscribeToSOSTopic(bool subscribe) async {
    if (subscribe)
      await this._firebaseMessaging.subscribeToTopic('sos');
    else
      await this._firebaseMessaging.unsubscribeFromTopic('sos');
  }

  Future<void> sendSOSResponseNotification(String threadId) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/notification/sos/response");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      Map<String, String> body = {
        "threadId": threadId,
      };

      // Send the post request to the server.
      http.Response response = await http.post(
        uri,
        body: body,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error) {
      print(error);
    }
  }
}
