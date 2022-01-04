import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';

class PostService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<Post>> fetchNewPosts() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<Post> posts = jsonResponse.map((json) => Post.fromJson(json)).toList();

    return posts;
  }

  Future<List<Post>> fetchPostsByCategory(String category) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
    await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      RAW_ENDPOINT,
      "/v1/api/post/category",
      {"category": category},
    );

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<Post> posts =
    jsonResponse.map((postJson) => Post.fromJson(postJson)).toList();

    return posts;
  }

  Future<List<PostCategory>> fetchCategories() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
    await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post/categories");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.get(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<PostCategory> categories =
    jsonResponse.map((json) => PostCategory.fromJson(json)).toList();

    return categories;
  }
}
