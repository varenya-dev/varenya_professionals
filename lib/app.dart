import 'package:flutter/material.dart';
import 'package:varenya_professionals/pages/auth/login_page.dart';
import 'package:varenya_professionals/pages/auth/register_page.dart';
import 'package:varenya_professionals/pages/auth/user_details_page.dart';
import 'package:varenya_professionals/pages/common/splash_page.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Varenya Professionals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        UserDetailsPage.routeName: (context) => UserDetailsPage(),
        UserUpdatePage.routeName: (context) => UserUpdatePage(),
      },
    );
  }
}
