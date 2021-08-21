import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _firebaseUser;

  User get user => this._firebaseUser!;

  set user(firebaseUser) {
    this._firebaseUser = firebaseUser;
    notifyListeners();
  }

  void removeUser() {
    this._firebaseUser = null;
  }
}
