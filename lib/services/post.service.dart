import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/constants/hive_boxes.constant.dart';
import 'package:varenya_professionals/dtos/post/create_post/create_post.dto.dart';
import 'package:varenya_professionals/dtos/post/delete_post/delete_post.dto.dart';
import 'package:varenya_professionals/dtos/post/update_post/update_post.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class PostService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Box<List<dynamic>> _postsBox = Hive.box(VARENYA_POSTS_BOX);
  final Box<List<dynamic>> _categoriesBox = Hive.box(VARENYA_POST_CATEGORY_BOX);

  Future<Post> fetchPostsById(String postId) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      RAW_ENDPOINT,
      "/v1/api/post",
      {"postId": postId},
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
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:fetchPostsById Error", body['message']);
      throw ServerException(
        message: 'Something went wrong, please try again later.',
      );
    }

    dynamic jsonResponse = json.decode(response.body);
    Post post = Post.fromJson(jsonResponse);

    return post;
  }

  Future<List<Post>> fetchNewPosts() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/post/new");

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
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchNewPosts Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Post> posts =
          jsonResponse.map((json) => Post.fromJson(json)).toList();

      this._savePostsToDevice(posts, "NEW");

      return posts;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchPostsFromDevice("NEW");
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchPostsFromDevice("NEW");
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchPostsFromDevice("NEW");
      } else {
        throw error;
      }
    }
  }

  Future<List<Post>> fetchPostsByCategory(String category) async {
    try {
      if (category == 'NEW') {
        return await this.fetchNewPosts();
      }

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
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchPostsByCategory Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Post> posts =
          jsonResponse.map((postJson) => Post.fromJson(postJson)).toList();

      this._savePostsToDevice(posts, category);

      return posts;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchPostsFromDevice(category);
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchPostsFromDevice(category);
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchPostsFromDevice(category);
      } else {
        throw error;
      }
    }
  }

  Future<List<PostCategory>> fetchCategories() async {
    try {
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
        Map<String, dynamic> body = json.decode(response.body);
        log.e("PostService:fetchCategories Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<PostCategory> categories =
          jsonResponse.map((json) => PostCategory.fromJson(json)).toList();

      this._saveCategoriesToDevice(categories);

      return categories;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchCategoriesFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchCategoriesFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchCategoriesFromDevice();
      } else {
        throw error;
      }
    }
  }

  Future<void> createNewPost(CreatePostDto createPostDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
      'Content-type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      body: json.encode(createPostDto.toJson()),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      print(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:createNewPost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  Future<void> updatePost(UpdatePostDto updatePostDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/post");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
      'Content-type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.put(
      uri,
      body: json.encode(updatePostDto.toJson()),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:updatePost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  Future<void> deletePost(DeletePostDto deletePostDto) async {
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
    http.Response response = await http.delete(
      uri,
      body: deletePostDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("PostService:deletePost Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  void _savePostsToDevice(List<Post> posts, String category) {
    log.i("Saving Posts:$category to Device");
    this._postsBox.put(category, posts);
    log.i("Saved Posts:$category to Device");
  }

  List<Post> _fetchPostsFromDevice(String category) {
    log.i("Fetching Posts:$category From Device");
    return this._postsBox.get(category, defaultValue: [])!.cast<Post>();
  }

  void _saveCategoriesToDevice(List<PostCategory> categories) {
    log.i("Saving Categories to Device");
    this._categoriesBox.put(VARENYA_CATEGORY_LIST, categories);
    log.i("Saved Categories to Device");
  }

  List<PostCategory> _fetchCategoriesFromDevice() {
    log.i("Fetching Categories From Device");
    return this
        ._categoriesBox
        .get(VARENYA_CATEGORY_LIST, defaultValue: [])!.cast<PostCategory>();
  }
}
