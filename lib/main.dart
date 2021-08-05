import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:varenya_professionals/app.dart';
import 'package:varenya_professionals/pages/common/loading_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Root());
}

class Root extends StatelessWidget {
  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return App();
        }

        return LoadingPage();
      },
    );
  }
}
