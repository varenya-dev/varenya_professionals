import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<Doctor> fetchDoctorDetails() {
    
  };

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

        Map<String, dynamic> doctorData =
            (await this.fetchDoctorDetails()).data()!;
        Doctor newDoctor = Doctor.fromJson(doctorData);

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

        Map<String, dynamic> doctorData =
            (await this.fetchDoctorDetails()).data()!;
        Doctor newDoctor = Doctor.fromJson(doctorData);

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
