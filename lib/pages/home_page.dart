import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';
import 'package:varenya_professionals/providers/user_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Varenya For Professionals'),
      ),
      body: Center(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, state, child) {
                var user = state.user;
                return Text(user.email!);
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UserUpdatePage.routeName);
              },
              child: Text('User Update'),
            )
          ],
        ),
      ),
    );
  }
}
