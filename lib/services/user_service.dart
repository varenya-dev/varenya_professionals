import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:varenya_professionals/dtos/user/update_email_dto/update_email_dto.dart';
import 'package:varenya_professionals/dtos/user/update_password_dto/update_password_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

/*
 * Service implementation for User module.
 */
class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final String apiUrl;
  final String rawApiUrl;

  UserService({
    required this.apiUrl,
    required this.rawApiUrl,
  });

  Future<ServerUser> findUserById(String userId) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
    await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(
      rawApiUrl,
      "/v1/api/user",
      {
        "id": userId,
      },
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
      log.e("AppointmentService:fetchAvailableSlots Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    // Decode JSON and create objects based on it.
    dynamic rawJson = json.decode(response.body);
    ServerUser serverUser = ServerUser.fromJson(rawJson);

    // Return User details
    return serverUser;
  }

  /*
   * Update profile picture for the given user.
   * @param imageUrl updated URL of the new profile picture.
   */
  Future<User> updateProfilePicture(String imageUrl) async {
    try {
      // Fetch the currently logged in user.
      User firebaseUser = this._firebaseAuth.currentUser!;

      // Update profile picture URL for the user.
      await firebaseUser.updatePhotoURL(imageUrl);

      // Return updated user.
      return this._firebaseAuth.currentUser!;
    } catch (error, stackTrace) {
      log.e("UserService:updateProfilePicture Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Update display name for the given user.
   * @param fullName Updated full name of the user.
   */
  Future<User> updateFullName(String fullName) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Updating the name of the user.
      await loggedInUser.updateDisplayName(fullName);

      // Returning updated user data.
      return this._firebaseAuth.currentUser!;
    } catch (error, stackTrace) {
      log.e("UserService:updateFullName Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Update email address for the given user.
   * @param updateEmailDto DTO for email address update.
   */
  Future<User> updateEmailAddress(UpdateEmailDto updateEmailDto) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: updateEmailDto.password,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Update email address for the user.
      await loggedInUser.updateEmail(updateEmailDto.newEmailAddress);

      // Returning updated user data.
      return this._firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (error, stackTrace) {
      // Firebase Error: If the user has typed a weak password.
      if (error.code == "email-already-in-use") {
        throw UserAlreadyExistsException(
          message: "There is an account associated with this email address.",
        );
      }

      // Firebase Error: If the user has typed the wrong password.
      else if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        log.e("UserService:updateEmailAddress Error", error, stackTrace);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    } catch (error, stackTrace) {
      log.e("UserService:updateEmailAddress Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Update password for the given user.
   * @param updateEmailDto DTO for password update.
   */
  Future<void> updatePassword(UpdatePasswordDto updatePasswordDto) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: updatePasswordDto.oldPassword,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Update password for the user.
      await loggedInUser.updatePassword(updatePasswordDto.newPassword);
    } on FirebaseAuthException catch (error, stackTrace) {
      // Firebase Error: If the user has typed a weak password.
      if (error.code == "weak-password") {
        throw WeakPasswordException(message: "Password provided is weak.");
      }

      // Firebase Error: If the user has typed the wrong password.
      else if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        log.e("UserService:updatePassword Error", error, stackTrace);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    } catch (error, stackTrace) {
      log.e("UserService:updatePassword Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Delete account of the logged in user.
   * @param password user password.
   */
  Future<void> deleteAccount(String password) async {
    try {
      // Fetch the currently logged in user.
      User loggedInUser = this._firebaseAuth.currentUser!;

      // Get the email address for the currently logged in user.
      String currentUserEmailAddress = loggedInUser.email!;

      // Prepare the auth credentials for re-authentication.
      AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUserEmailAddress,
        password: password,
      );

      // Re-authenticate the user with credential.
      await loggedInUser.reauthenticateWithCredential(authCredential);

      // Deleting user account.
      await this._deleteUserFromServer();
      await loggedInUser.delete();
    } on FirebaseAuthException catch (error, stackTrace) {
      // Firebase Error: If the user has typed the wrong password.
      if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        log.e("UserService:deleteAccount Error", error, stackTrace);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    } on ServerException catch (error) {
      throw ServerException(message: error.message);
    } catch (error, stackTrace) {
      log.e("UserService:deleteAccount Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Send a server request for setting roles for the user.
   */
  Future<void> _deleteUserFromServer() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$apiUrl/user");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.delete(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("UserService:_deleteUserFromServer Error", body['message']);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  /*
   * Save FCM token to database on each update.
   * @param token FCM Token to be saved.
   */
  Future<void> saveTokenToDatabase(String token) async {
    try {
      // Save token to the respective document collection.
      String userId = this._firebaseAuth.currentUser!.uid;
      await this._firebaseFirestore.collection('users').doc(userId).set({
        'id': userId,
        'token': token,
      });
    } catch (error, stackTrace) {
      log.e("UserService:saveTokenToDatabase Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong with notifications.");
    }
  }

  /*
   * Save token to the database on first run.
   */
  Future<void> generateAndSaveTokenToDatabase() async {
    try {
      //  Generate an FCM token and save it to firestore.
      String? token = await this._firebaseMessaging.getToken();
      this.saveTokenToDatabase(token!);

      log.i("Token Generated and Saved To Firestore.");
    } catch (error, stackTrace) {
      log.e("UserService:saveTokenToDatabase Error", error, stackTrace);
      throw GeneralException(
          message: "Something went wrong with notifications.");
    }
  }
}
