import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/app.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/appointment.service.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/chat_service.dart';
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print("FCM STATUS: ${settings.authorizationStatus}");

  runApp(Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<DoctorProvider>(
          create: (context) => DoctorProvider(),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        Provider<UserService>(
          create: (context) => UserService(),
        ),
        Provider<ChatService>(
          create: (context) => ChatService(),
        ),
        Provider<AlertsService>(
          create: (context) => AlertsService(),
        ),
        Provider<DoctorService>(
          create: (context) => DoctorService(),
        ),
        Provider<AppointmentService>(
          create: (context) => AppointmentService(),
        ),
        Provider<PostService>(
          create: (context) => PostService(),
        ),
        Provider<CommentsService>(
          create: (context) => CommentsService(),
        ),
      ],
      child: App(),
    );
  }
}
