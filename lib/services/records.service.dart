import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/constants/hive_boxes.constant.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/patient/patient.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class RecordsService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Box<List<dynamic>> _recordsBox = Hive.box(VARENYA_PATIENT_RECORD_BOX);

  /*
   * Method to fetch doctor records from the server.
   */
  Future<List<Patient>> fetchPatientRecords() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
      await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$ENDPOINT/records");

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
        log.e("RecordsService:fetchDoctorRecords Error", body['message']);
        throw ServerException(
          message: 'Something went wrong, please try again later.',
        );
      }

      // Decode JSON and create objects based on it.
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Patient> records =
      jsonResponse.map((json) => Patient.fromJson(json)).toList();

      // Save records on device storage.
      this._saveRecordsToDevice(records);

      return records;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage.
      return this._fetchRecordsFromDevice();
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch posts from device storage.
      return this._fetchRecordsFromDevice();
    } on FirebaseAuthException catch (error) {
      if (error.code == "network-request-failed") {
        // Fetch posts from device storage.
        return this._fetchRecordsFromDevice();
      } else {
        throw error;
      }
    }
  }

  /*
   * Method to save records on device.
   */
  void _saveRecordsToDevice(List<Patient> records) {
    log.i("Saving Records to Device");

    // Save records to HiveDB box.
    this._recordsBox.put(VARENYA_PATIENT_RECORD_LIST, records);
    log.i("Saved Records to Device");
  }

  /*
   * Method to fetch saved records from device.
   */
  List<Patient> _fetchRecordsFromDevice() {
    log.i("Fetching Records From Device");

    // Fetch and return saved records from device.
    return this
        ._recordsBox
        .get(VARENYA_PATIENT_RECORD_LIST, defaultValue: [])!.cast<Patient>();
  }
}
