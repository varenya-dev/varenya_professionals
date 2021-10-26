import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchDoctorDetails() => this
      ._firebaseFirestore
      .collection('doctors')
      .doc(this._firebaseAuth.currentUser!.uid)
      .snapshots();

  Future<void> createPlaceholderData() async {
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
      } catch (error) {
        print(error);
      }
    } else {
      throw new NotLoggedInException(
        message: 'Please log in to access this feature.',
      );
    }
  }

  Future<void> createOrUpdateDoctor(
    Doctor doctor,
  ) async {
    User? firebaseUser = this._firebaseAuth.currentUser;

    if (firebaseUser != null) {
      try {
        String userId = firebaseUser.uid;

        await this
            ._firebaseFirestore
            .collection('doctors')
            .doc(userId)
            .set(doctor.toJson());
      } catch (error) {
        print(error);
      }
    } else {
      throw new NotLoggedInException(
        message: 'Please log in to access this feature.',
      );
    }
  }

  Future<void> deleteDoctor() async {
    User? firebaseUser = this._firebaseAuth.currentUser;

    if (firebaseUser != null) {
      try {
        String userId = firebaseUser.uid;

        await this
            ._firebaseFirestore
            .collection('doctors')
            .doc(userId)
            .delete();
      } catch (error) {
        print(error);
      }
    } else {
      throw new NotLoggedInException(
        message: 'Please log in to access this feature.',
      );
    }
  }
}
