import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Doctor> fetchDoctorDetails() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/doctor/identity");

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
          message: 'Something went wrong, please try again later.');
    }

    Map<String, dynamic> doctorData = json.decode(response.body);
    Doctor doctor = Doctor.fromJson(doctorData);

    print(doctor);

    return doctor;
  }

  Future<Doctor> createPlaceholderData() async {
    User? firebaseUser = this._firebaseAuth.currentUser;

    if (firebaseUser != null) {
      try {
        String userId = firebaseUser.uid;
        Doctor doctor = new Doctor(
          id: userId,
        );

        doctor.fullName = firebaseUser.displayName ?? '';
        doctor.imageUrl = firebaseUser.photoURL ?? '';

        await this
            ._firebaseFirestore
            .collection('doctors')
            .doc(userId)
            .set(doctor.toJson());

        Doctor newDoctor = await this.fetchDoctorDetails();

        return newDoctor;
      } catch (error) {
        print(error);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    }
    throw new NotLoggedInException(
      message: 'Please log in to access this feature.',
    );
  }

  Future<Doctor> updateDoctor(
    Doctor doctor,
  ) async {
    User? firebaseUser = this._firebaseAuth.currentUser;

    if (firebaseUser != null) {
      try {
        String userId = firebaseUser.uid;
        doctor.imageUrl = firebaseUser.photoURL ?? '';

        await this
            ._firebaseFirestore
            .collection('doctors')
            .doc(userId)
            .set(doctor.toJson());

        Doctor newDoctor = await this.fetchDoctorDetails();

        return newDoctor;
      } catch (error) {
        print(error);
        throw GeneralException(
            message: "Something went wrong, please try again later");
      }
    }
    throw new NotLoggedInException(
      message: 'Please log in to access this feature.',
    );
  }
}
