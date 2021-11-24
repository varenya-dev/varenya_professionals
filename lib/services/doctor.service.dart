import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/dtos/doctor/create_update_doctor.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:http/http.dart' as http;

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

    return doctor;
  }

  Future<Doctor> createPlaceholderData() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/doctor/placeholder");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
    };

    // Send the post request to the server.
    http.Response response = await http.post(
      uri,
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      print(body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    Map<String, dynamic> doctorData = json.decode(response.body);
    Doctor doctor = Doctor.fromJson(doctorData);

    return doctor;
  }

  Future<Doctor> updateDoctor(
    CreateOrUpdateDoctorDto createOrUpdateDoctorDto,
  ) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/doctor");

    // Prepare authorization headers.
    Map<String, String> headers = {
      "Authorization": "Bearer $firebaseAuthToken",
      'Content-type': 'application/json',
    };

    // Send the post request to the server.
    http.Response response = await http.put(
      uri,
      body: json.encode(createOrUpdateDoctorDto.toJson()),
      headers: headers,
    );

    // Check for any errors.
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      print(body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    Map<String, dynamic> doctorData = json.decode(response.body);
    Doctor doctor = Doctor.fromJson(doctorData);

    return doctor;
  }
}
