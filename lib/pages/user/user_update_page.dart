import 'package:flutter/material.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/widgets/user/user_delete_tab.dart';
import 'package:varenya_professionals/widgets/user/user_email_update_tab.dart';
import 'package:varenya_professionals/widgets/user/user_password_update_tab.dart';
import 'package:varenya_professionals/widgets/user/user_profile_update_tab.dart';

class UserUpdatePage extends StatelessWidget {
  const UserUpdatePage({Key? key}) : super(key: key);

  static const routeName = "/user-update";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update Your Profile'),
          bottom: TabBar(
            indicatorColor: Palette.primary,
            tabs: [
              Tab(
                child: Text(
                  'User Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Email Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Password Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserProfileUpdateTab(),
            UserEmailUpdateTab(),
            UserPasswordUpdateTab(),
            UserDeleteTab(),
          ],
        ),
      ),
    );
  }
}
