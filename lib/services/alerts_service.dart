import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class AlertsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final String apiUrl;
  final String rawApiUrl;

  AlertsService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  Future<void> toggleSubscribeToSOSTopic(bool subscribe) async {
    if (subscribe)
      await this._firebaseMessaging.subscribeToTopic('sos');
    else
      await this._firebaseMessaging.unsubscribeFromTopic('sos');
  }

  Future<void> sendSOSResponseNotification(String threadId) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$apiUrl/notification/sos/response");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AlertsService:sendSOSResponseNotification Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }
}
