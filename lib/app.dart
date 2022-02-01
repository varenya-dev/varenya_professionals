import 'package:flutter/material.dart';
import 'package:varenya_professionals/pages/appointment/appointment_list.page.dart';
import 'package:varenya_professionals/pages/auth/auth_page.dart';
import 'package:varenya_professionals/pages/auth/login_page.dart';
import 'package:varenya_professionals/pages/auth/register_page.dart';
import 'package:varenya_professionals/pages/chat/chat_page.dart';
import 'package:varenya_professionals/pages/common/splash_page.dart';
import 'package:varenya_professionals/pages/home_page.dart';
import 'package:varenya_professionals/pages/chat/threads_page.dart';
import 'package:varenya_professionals/pages/post/categorized_posts.page.dart';
import 'package:varenya_professionals/pages/post/new_post.page.dart';
import 'package:varenya_professionals/pages/post/new_posts.page.dart';
import 'package:varenya_professionals/pages/post/post.page.dart';
import 'package:varenya_professionals/pages/post/update_post.page.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';
import 'package:varenya_professionals/utils/generate_swatch.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Varenya Professionals',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: generateMaterialColor(
          Palette.primary,
        ),
        primaryColor: Palette.primary,
        scaffoldBackgroundColor: Color(0xff1f1d24),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Palette.primary,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(
            0XFF282A2E,
          ),
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.white.withOpacity(
              0.44,
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Palette.secondary,
        ),
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
        CategorizedPosts.routeName: (context) => CategorizedPosts(),
        NewPost.routeName: (context) => NewPost(),
        UpdatePost.routeName: (context) => UpdatePost(),
        Post.routeName: (context) => Post(),
      },
    );
  }
}
