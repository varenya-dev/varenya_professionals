import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/dtos/doctor/create_update_doctor/create_update_doctor.dto.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';

class DoctorService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createOrUpdateDoctor(
    CreateOrUpdateDoctorDto createOrUpdateDoctorDto,
  ) async {
    User? firebaseUser = this._firebaseAuth.currentUser;

    if (firebaseUser != null) {
      try {
        String userId = firebaseUser.uid;
        createOrUpdateDoctorDto.id = userId;

        await this
            ._firebaseFirestore
            .collection('doctors')
            .doc(userId)
            .set(createOrUpdateDoctorDto.toJson());
      } catch (error) {
        print(error);
      }
    } else {
      throw new NotLoggedInException(
        message: 'Please log in to acess this feature.',
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
        message: 'Please log in to acess this feature.',
      );
    }
  }
}
