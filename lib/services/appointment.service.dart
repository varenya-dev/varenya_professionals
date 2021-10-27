import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/models/appointment/appointment/appointment.model.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<DoctorAppointmentResponse>> fetchAppointments() async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment/doctor");

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
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }

      List<dynamic> jsonResponse = json.decode(response.body);
      List<DoctorAppointmentResponse> appointments = jsonResponse
          .map((json) => DoctorAppointmentResponse.fromJson(json))
          .toList();

      return appointments;
    } catch (error) {
      throw Exception('Try again later');
    }
  }

  Future<void> updateAppointment(Appointment appointment) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      Map<String, dynamic> appointmentJson = appointment.toJson();
      appointmentJson.remove('patientUser');
      appointmentJson.remove('doctorUser');

      // Send the post request to the server.
      http.Response response = await http.put(
        uri,
        body: appointmentJson,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error) {
      throw Exception('Try again later');
    }
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      // Fetch the ID token for the user.
      String firebaseAuthToken =
          await this._firebaseAuth.currentUser!.getIdToken();

      // Prepare URI for the request.
      Uri uri = Uri.parse("$endpoint/appointment");

      // Prepare authorization headers.
      Map<String, String> headers = {
        "Authorization": "Bearer $firebaseAuthToken",
      };

      Map<String, dynamic> appointmentJson = appointment.toJson();
      appointmentJson.remove('patientUser');
      appointmentJson.remove('doctorUser');

      // Send the post request to the server.
      http.Response response = await http.delete(
        uri,
        body: appointmentJson,
        headers: headers,
      );

      // Check for any errors.
      if (response.statusCode >= 400) {
        Map<String, dynamic> body = json.decode(response.body);
        throw Exception(body);
      }
    } catch (error) {
      throw Exception('Try again later');
    }
  }
}
