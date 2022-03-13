import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/pages/user/user_update_page.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/auth_service.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';
class UserOptionsModal extends StatefulWidget {
  const UserOptionsModal({Key? key}) : super(key: key);

  @override
  _UserOptionsModalState createState() => _UserOptionsModalState();
}

class _UserOptionsModalState extends State<UserOptionsModal> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    this._authService = Provider.of<AuthService>(context, listen: false);
  }

  Future<void> _onLogout() async {
    await this._authService.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.width * 0.25,
          medium: MediaQuery.of(context).size.width * 0.2,
          small: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider userProvider, _) {
          User user = userProvider.user;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: Text(
                  'Logged in as',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ListTile(
                leading: ProfilePictureWidget(
                  imageUrl: user.photoURL ?? '',
                  size: MediaQuery.of(context).size.height * 0.056,
                ),
                title: Text(
                  user.displayName ?? 'User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Update Profile',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    UserUpdatePage.routeName,
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: this._onLogout,
              ),
            ],
          );
        },
      ),
    );
  }
}
