import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/dtos/user/update_email_dto/update_email_dto.dart';
import 'package:varenya_professionals/dtos/user/update_password_dto/update_password_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/auth/weak_password_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:http/http.dart' as http;

/*
 * Service implementation for User module.
 */
class UserService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /*
   * Update profile picture for the given user.
   * @param imageUrl updated URL of the new profile picture.
   */
  Future<User> updateProfilePicture(String imageUrl) async {
    // Fetch the currently logged in user.
    User firebaseUser = this._firebaseAuth.currentUser!;

    // Update profile picture URL for the user.
    await firebaseUser.updatePhotoURL(imageUrl);

    // Return updated user.
    return this._firebaseAuth.currentUser!;
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
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
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
    } on FirebaseAuthException catch (error) {
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
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
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
    } on FirebaseAuthException catch (error) {
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
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
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
    } on FirebaseAuthException catch (error) {
      // Firebase Error: If the user has typed the wrong password.
      if (error.code == 'wrong-password') {
        throw WrongPasswordException(
          message: 'Wrong password provided for the specified user account.',
        );
      }

      // Handle other unknown errors
      else {
        print(error);
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Send a server request for setting roles for the user.
   */
  Future<void> _deleteUserFromServer() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/user");

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
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error) {
      print(error);
    }
  }
}
