import 'package:flutter/foundation.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';

class DoctorProvider extends ChangeNotifier {
  Doctor? _doctor;

  Doctor get doctor => this._doctor!;

  set doctor(Doctor doctor) {
    this._doctor = doctor;
    notifyListeners();
  }

  void removeDoctor() {
    this._doctor = null;
  }
}
