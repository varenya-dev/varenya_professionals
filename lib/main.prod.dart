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
      apiUrl: kIsWeb ? "https://varenya-production.herokuapp.com/v1/api" : "https://varenya-production.herokuapp.com/v1/api",
      rawApiUrl: kIsWeb ? "varenya-production.herokuapp.com" : "varenya-production.herokuapp.com",
      child: App(),
    );
  }
}
