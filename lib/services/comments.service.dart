import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/dtos/comments/create_comment/create_comment.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';


class CommentsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createNewComment(CreateCommentDto createCommentDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
    await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/comment");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      body: createCommentDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      print(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

}