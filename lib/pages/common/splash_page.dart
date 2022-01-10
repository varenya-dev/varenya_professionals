import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/pages/auth/auth_page.dart';
import 'package:varenya_professionals/pages/common/loading_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const routeName = "/";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    setState(() {
      /*
       * Listen for logged in user using firebase auth changes.
       * If the user exists, route them to the Home Page.
       *
       * Otherwise, route them to Auth page.
       */
      this._streamSubscription =
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          log.i("Firebase User Found, logging in.");
          Provider.of<DoctorService>(context, listen: false)
              .fetchDoctorDetails()
              .then((doctor) {
            log.i("Doctor Details Fetched.");
            Provider.of<DoctorProvider>(context, listen: false).doctor = doctor;

            Provider.of<UserProvider>(context, listen: false).user = user;
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          });
        } else {
          log.i("Firebase User Not Found, logging out.");
          Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    this._streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}
