import 'package:flutter/material.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/auth/auth_page.dart';
import 'package:varenya_professionals/pages/auth/login_page.dart';
import 'package:varenya_professionals/pages/auth/register_page.dart';
import 'package:varenya_professionals/pages/chat/chat_page.dart';
import 'package:varenya_professionals/pages/common/splash_page.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/pages/chat/threads_page.dart';
import 'package:varenya_professionals/pages/post/new_posts.page.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Varenya Professionals',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
      ),
      routes: {
        SplashPage.routeName: (context) => SplashPage(),
        HomePage.routeName: (context) => HomePage(),
        AuthPage.routeName: (context) => AuthPage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        UserUpdatePage.routeName: (context) => UserUpdatePage(),
        ThreadsPage.routeName: (context) => ThreadsPage(),
        ChatPage.routeName: (context) => ChatPage(),
        AppointmentList.routeName: (context) => AppointmentList(),
        NewPosts.routeName: (context) => NewPosts(),
      },
    );
  }
}
