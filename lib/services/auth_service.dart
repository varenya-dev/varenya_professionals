import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/dtos/auth/login_account_dto/login_account_dto.dart';
import 'package:varenya_professionals/dtos/auth/register_account_dto/register_account_dto.dart';
import 'package:varenya_professionals/dtos/auth/server_register_dto/server_register.dto.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/auth/user_not_found_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final Uuid uuid = Uuid();

  /*
   * Method to check account availability.
   * @param registerAccountDto DTO for user registration.
   */
  Future<bool> checkAccountAvailability(
    String emailAddress,
  ) async {
    try {
      // Check for account existence.
      UserCredential userCredential =
          await this.firebaseAuth.createUserWithEmailAndPassword(
                email: emailAddress,
                password: 'check123',
              );

      // Delete the account and return false.
      await userCredential.user!.delete();
      return true;
    } on FirebaseException {
      return false;
    }
  }

  /*
   * Method to register the user with Firebase.
   * @param registerAccountDto DTO for user registration.
   */
  Future<User> registerWithEmailAndPassword(
    RegisterAccountDto registerAccountDto,
  ) async {
    try {
      // Register the user in firebase.
      await this.firebaseAuth.createUserWithEmailAndPassword(
            email: registerAccountDto.emailAddress,
            password: registerAccountDto.password,
          );

      // Fetching the currently logged in user.
      User? firebaseUser = firebaseAuth.currentUser;

      // Check if user is not null
      if (firebaseUser != null) {
        // Update the name for the user.
        await firebaseUser.updateDisplayName(registerAccountDto.fullName);

        // If an image link has been given as well,
        // update the user's profile picture.
        if (registerAccountDto.imageUrl.length > 0) {
          await firebaseUser.updatePhotoURL(registerAccountDto.imageUrl);
        }

        await this._setupFirebaseRoles();
        await this.firebaseAuth.currentUser!.getIdToken(true);
      }

      return this.firebaseAuth.currentUser!;
    } on FirebaseException catch (error) {
      // If email is already in use, throw an error.
      if (error.code == 'email-already-in-use') {
        throw new UserAlreadyExistsException(
          message: 'The account already exists for that email.',
        );
      }

      // Handle other unknown errors
      else {
        print(error);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    } on ServerException catch (error) {
      throw ServerException(message: error.message);
    } catch (error) {
      print(error);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Method to log the user in the application.
   * @param loginAccountDto DTO for user login
   */
  Future<User> loginWithEmailAndPassword(
      LoginAccountDto loginAccountDto) async {
    try {
      // Log the user in with firebase using their credentials.
      await firebaseAuth.signInWithEmailAndPassword(
        email: loginAccountDto.emailAddress,
        password: loginAccountDto.password,
      );

      return this.firebaseAuth.currentUser!;
    } on FirebaseAuthException catch (error) {
      // Firebase Error: If the user does not exist.
      if (error.code == 'user-not-found') {
        throw UserNotFoundException(
          message: 'No user found for that email.',
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
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw GeneralException(
          message: "Something went wrong, please try again later");
    }
  }

  /*
   * Method to log out from firebase.
   */
  Future<void> logOut() async {
    await this.firebaseAuth.signOut();
  }

  /*
   * Send a server request for setting roles for the user.
   */
  Future<void> _setupFirebaseRoles() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this.firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/auth/register");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    ServerRegisterDto serverRegisterDto = new ServerRegisterDto(
      uid: this.firebaseAuth.currentUser!.uid,
      role: Roles.PROFESSIONAL,
    );

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      body: serverRegisterDto.toJson(),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }
}
