import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/providers/doctor.provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/alerts_service.dart';
import 'package:varenya_professionals/services/appointment.service.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/services/chat.service.dart';
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/services/records.service.dart';
import 'package:varenya_professionals/services/user_service.dart';

class Providers extends StatelessWidget {
  final String apiUrl;
  final String rawApiUrl;
  final Widget child;

  const Providers({
    Key? key,
    required this.apiUrl,
    required this.rawApiUrl,
    required this.child,
  }) : super(key: key);

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
          create: (context) => AuthService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<UserService>(
          create: (context) => UserService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<ChatService>(
          create: (context) => ChatService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<AlertsService>(
          create: (context) => AlertsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<DoctorService>(
          create: (context) => DoctorService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<AppointmentService>(
          create: (context) => AppointmentService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<PostService>(
          create: (context) => PostService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<CommentsService>(
          create: (context) => CommentsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
        Provider<RecordsService>(
          create: (context) => RecordsService(
            apiUrl: apiUrl,
            rawApiUrl: rawApiUrl,
          ),
        ),
      ],
      child: child,
    );
  }
}
