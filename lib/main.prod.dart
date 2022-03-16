import 'package:flutter/material.dart';
import 'package:varenya_professionals/app.dart';
import 'package:varenya_professionals/providers.dart';
import 'package:varenya_professionals/setup.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await fullSetup();

  runApp(ProdRoot());
}

class ProdRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Providers(
      apiUrl: kIsWeb ? "http://127.0.0.1:5000/v1/api" : "http://10.0.2.2:5000/v1/api",
      rawApiUrl: kIsWeb ? "127.0.0.1:5000" : "10.0.2.2:5000",
      child: App(),
    );
  }
}
