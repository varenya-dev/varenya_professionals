import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/notifications_handler.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/chat/threads_page.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/chat_service.dart';
import 'package:varenya_professionals/services/user_service.dart';

import 'auth/auth_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthService _authService;
  late final UserService _userService;
  late final ChatService _chatService;
  late final AlertsService _alertsService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._authService = Provider.of<AuthService>(context, listen: false);
    this._userService = Provider.of<UserService>(context, listen: false);
    this._chatService = Provider.of<ChatService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);

    this._userService.generateAndSaveTokenToDatabase();

    FirebaseMessaging.instance.onTokenRefresh
        .listen(this._userService.saveTokenToDatabase);

    this
        ._alertsService
        .toggleSubscribeToSOSTopic(true)
        .then((_) => print('SOS TOPIC SUBSCRIBED'))
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varenya For Professionals'),
      ),
      body: NotificationsHandler(
        child: Center(
          child: Column(
            children: [
              Consumer<DoctorProvider>(
                builder: (context, state, child) {
                  var user = state.doctor;
                  return Text(user.fullName);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(UserUpdatePage.routeName);
                },
                child: Text('User Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ThreadsPage.routeName);
                },
                child: Text('Threads'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await this._authService.logOut();
                  Navigator.of(context).pushNamed(AuthPage.routeName);
                },
                child: Text('Logout'),
              ),
              ElevatedButton(
                onPressed: this._chatService.openDummyThread,
                child: Text('Dummy Thread'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppointmentList.routeName);
                },
                child: Text('Appointments'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
