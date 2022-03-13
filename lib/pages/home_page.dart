import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/general.exception.dart';
import 'package:varenya_professionals/notifications_handler.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/chat/threads.page.dart';
import 'package:varenya_professionals/pages/post/categorized_posts.page.dart';
import 'package:varenya_professionals/pages/records/records.page.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/chat.service.dart';
import 'package:varenya_professionals/services/user_service.dart';
import 'package:varenya_professionals/utils/check_connectivity.util.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/home_bar.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final UserService _userService;
  late final AlertsService _alertsService;

  final List<Widget> screens = [
    AppointmentList(),
    CategorizedPosts(),
    Threads(),
    Records(),
  ];

  int screen = 0;

  @override
  void initState() {
    super.initState();
    this._userService = Provider.of<UserService>(context, listen: false);
    this._alertsService = Provider.of<AlertsService>(context, listen: false);

    if (!kIsWeb)
      checkConnectivity().then((value) {
        if (value) {
          try {
            this._userService.generateAndSaveTokenToDatabase();

            FirebaseMessaging.instance.onTokenRefresh
                .listen(this._userService.saveTokenToDatabase);
          } on GeneralException catch (error) {
            displaySnackbar(error.message, context);
          } catch (error, stackTrace) {
            log.e("HomePage:initState Error", error, stackTrace);
            displaySnackbar(
                "Something went wrong with notifications, error has been informed.",
                context);
          }

          this
              ._alertsService
              .toggleSubscribeToSOSTopic(true)
              .then((_) => log.i('Subscribed to SOS Topic'))
              .catchError((error) => print(error));
        } else {
          log.i(
              "Device offline, suspending FCM Token Generation and Topic Subscription");
        }
      }).catchError((error, stackTrace) {
        log.e("HomePage Error", error, stackTrace);
      });
  }

  void emitScreen(int screenNumber) {
    setState(() {
      this.screen = screenNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: HomeBar(
        screen: screen,
        emitScreen: this.emitScreen,
      ),
      body: NotificationsHandler(
        child: screens[screen],
      ),
    );
  }
}
