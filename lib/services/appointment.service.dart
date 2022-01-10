import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:varenya_professionals/constants/endpoint_constant.dart';
import 'package:varenya_professionals/dtos/fetch_booked_appointments/fetch_booked_appointments.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/appointment/appointment/appointment.model.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class AppointmentService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<List<DoctorAppointmentResponse>> fetchAppointments() async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment/doctor");

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
      log.e("AppointmentService:fetchAppointments Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<DoctorAppointmentResponse> appointments = jsonResponse
        .map((json) => DoctorAppointmentResponse.fromJson(json))
        .toList();

    return appointments;
  }

  Future<List<DoctorAppointmentResponse>> fetchAppointmentsByDay(
      FetchBookedAppointmentsDto fetchBookedAppointmentsDto) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.http(RAW_ENDPOINT, "/v1/api/appointment/doctor",
        fetchBookedAppointmentsDto.toJson());

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
      log.e("AppointmentService:fetchAppointmentsByDay Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }

    List<dynamic> jsonResponse = json.decode(response.body);
    List<DoctorAppointmentResponse> appointments = jsonResponse
        .map((json) => DoctorAppointmentResponse.fromJson(json))
        .toList();

    return appointments;
  }

  Future<void> updateAppointment(Appointment appointment) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AppointmentService:updateAppointment Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    // Fetch the ID token for the user.
    String firebaseAuthToken =
        await this._firebaseAuth.currentUser!.getIdToken();

    // Prepare URI for the request.
    Uri uri = Uri.parse("$ENDPOINT/appointment");

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
    if (response.statusCode >= 400 && response.statusCode < 500) {
      Map<String, dynamic> body = json.decode(response.body);
      throw ServerException(message: body['message']);
    } else if (response.statusCode >= 500) {
      Map<String, dynamic> body = json.decode(response.body);
      log.e("AppointmentService:deleteAppointment Error", body['message']);
      throw ServerException(
          message: 'Something went wrong, please try again later.');
    }
  }
}
