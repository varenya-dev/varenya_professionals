import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:varenya_professionals/dtos/auth/login_account_dto/login_account_dto.dart';
import 'package:varenya_professionals/dtos/auth/register_account_dto/register_account_dto.dart';
import 'package:varenya_professionals/dtos/auth/user_details_dto/user_details_dto.dart';
import 'package:varenya_professionals/exceptions/auth/user_already_exists_exception.dart';
import 'package:varenya_professionals/exceptions/auth/user_not_found_exception.dart';
import 'package:varenya_professionals/exceptions/auth/wrong_password_exception.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final Uuid uuid = Uuid();

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
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
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
        throw Exception("Something went wrong, please try again later");
      }
    } catch (error) {
      print(error);
      throw Exception("Something went wrong, please try again later");
    }
  }

  /*
   * Method to update the existing user with a name and profile picture.
   * @param userDetailsDto DTO for user details
   */
  Future<void> saveUserDetails(UserDetailsDto userDetailsDto) async {
    try {
      // Fetching the currently logged in user.
      User? firebaseUser = firebaseAuth.currentUser;

      // Check if user is not null
      if (firebaseUser != null) {
        // Update the name for the user.
        await firebaseUser.updateDisplayName(userDetailsDto.fullName);

        // If an image link has been given as well,
        // update the user's profile picture.
        if (userDetailsDto.image != null) {
          await firebaseUser.updatePhotoURL(userDetailsDto.image);
        }
      }
    } catch (error) {
      print(error);
    }
  }

  /*
   * Method to log out from firebase.
   */
  Future<void> logOut() async {
    await this.firebaseAuth.signOut();
    await this.googleSignIn.signOut();
  }

  /*
   * Method to upload image to firebase.
   * @param imageFile File object for the image itself.
   */
  Future<String> uploadImageToFirebase(File imageFile) async {
    String uid = uuid.v4();

    // Upload image to firebase.
    await this
        .firebaseStorage
        .ref("profilePictures/$uid.png")
        .putFile(imageFile);

    // Generate a URL for the uploaded image.
    return await this
        .firebaseStorage
        .ref("profilePictures/$uid.png")
        .getDownloadURL();
  }
}
