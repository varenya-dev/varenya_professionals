import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/constants/hive_boxes.constant.dart';
import 'package:varenya_professionals/dtos/doctor/create_update_doctor.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/models/specialization/specialization.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Box<Doctor> _loggedInDoctorBox = Hive.box(VARENYA_LOGGED_IN_DOCTOR_BOX);
  final Box<List<dynamic>> _jobsBox = Hive.box(VARENYA_JOB_BOX);
  final Box<List<dynamic>> _specializationsBox =
      Hive.box(VARENYA_SPECIALIZATION_BOX);

  Future<List<Specialization>> fetchSpecializations() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
      await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/doctor/specialization");

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
        log.e("DoctorService:fetchSpecializations Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<Specialization> specializations =
      jsonResponse.map((json) => Specialization.fromJson(json)).toList();

      this._saveSpecializationsToDevice(specializations);

      return specializations;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchSpecializationsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchSpecializationsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchSpecializationsFromDevice();
      } else {
        throw error;
      }
    }
  }

  Future<Doctor> fetchDoctorDetails() async {
    try {
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
        Map<String, dynamic> body = json.decode(response.body);
        log.e("DoctorService:fetchDoctorDetails Error", body['message']);
        throw ServerException(
            message: 'Something went wrong, please try again later.');
      }

      Map<String, dynamic> doctorData = json.decode(response.body);
      Doctor doctor = Doctor.fromJson(doctorData);

      this._saveLoggedInDoctorToDevice(doctor);

      return doctor;
    } on SocketException {
      log.wtf("Dedicated Server Offline");
      return this._fetchLoggedInDoctorFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");
      return this._fetchLoggedInDoctorFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        return this._fetchLoggedInDoctorFromDevice();
      } else {
        throw error;
      }
    }
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
      log.e("DoctorService:createPlaceholderData Error", body['message']);
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
      log.e(body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("DoctorService:updateDoctor Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    Map<String, dynamic> doctorData = json.decode(response.body);
    Doctor doctor = Doctor.fromJson(doctorData);

    return doctor;
  }

  void _saveLoggedInDoctorToDevice(Doctor doctor) {
    log.i("Saving Logged In Doctor to Device");
    this._loggedInDoctorBox.put(VARENYA_LOGGED_IN_DOCTOR, doctor);
    log.i("Saved Logged In Doctor to Device");
  }

  Doctor _fetchLoggedInDoctorFromDevice() {
    log.i("Fetching Logged In Doctor From Device");
    return this._loggedInDoctorBox.get(
          VARENYA_LOGGED_IN_DOCTOR,
          defaultValue: new Doctor(
            id: '',
            shiftStartTime: DateTime.now(),
            shiftEndTime: DateTime.now(),
          ),
        )!;
  }

  void _saveSpecializationsToDevice(List<Specialization> specializations) {
    log.i("Saving Specializations to Device");
    this._specializationsBox.put(VARENYA_SPECIALIZATION_LIST, specializations);
    log.i("Saved Specializations to Device");
  }

  List<Specialization> _fetchSpecializationsFromDevice() {
    log.i("Fetching Specializations From Device");
    return this._specializationsBox.get(
      VARENYA_SPECIALIZATION_LIST,
      defaultValue: [],
    )!.cast<Specialization>();
  }

  void _saveJobsToDevice(List<String> jobs) {
    log.i("Saving Jobs to Device");
    this._jobsBox.put(VARENYA_JOB_LIST, jobs);
    log.i("Saved Jobs to Device");
  }

  List<String> _fetchJobsFromDevice() {
    log.i("Fetching Jobs From Device");
    return this
        ._jobsBox
        .get(VARENYA_JOB_LIST, defaultValue: [])!.cast<String>();
  }
}
