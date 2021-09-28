import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/app.dart';
import 'package:varenya_professionals/pages/common/loading_page.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

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
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                create: (context) => UserProvider(),
              ),
              Provider<AuthService>(
                create: (context) => AuthService(),
              ),
              Provider<UserService>(
                create: (context) => UserService(),
              ),
            ],
            child: App(),
          );
        }

        return LoadingPage();
      },
    );
  }
}
