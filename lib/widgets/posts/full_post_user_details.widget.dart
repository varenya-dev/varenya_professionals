import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';
import 'package:varenya_professionals/widgets/posts/post_options_modal.widget.dart';

class FullPostUserDetails extends StatelessWidget {
  const FullPostUserDetails({
    Key? key,
    required this.context,
    required Post post,
  })  : _post = post,
        super(key: key);

  final BuildContext context;
  final Post _post;

  void _openPostOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: kIsWeb
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => PostOptionsModal(
        post: this._post,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: responsiveConfig(
        context: context,
        large: MediaQuery.of(context).size.height * 0.3,
        medium: MediaQuery.of(context).size.height * 0.3,
        small: MediaQuery.of(context).size.height * 0.2,
      ),
      width: MediaQuery.of(context).size.width,
      color: Colors.black54,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Consumer<UserProvider>(
        builder:
            (BuildContext context, UserProvider userProvider, Widget? child) {
          User user = userProvider.user;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child!,
              if (user.uid == this._post.user.firebaseId)
                IconButton(
                  iconSize: MediaQuery.of(context).size.height * 0.055,
                  onPressed: this._openPostOptions,
                  icon: Icon(
                    Icons.more_vert,
                  ),
                ),
            ],
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            this._post.user.role == Roles.MAIN
                ? '${this._post.user.randomName!.randomName} posted'
                : 'Dr. ${this._post.user.doctor!.fullName} posted',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.04,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible,
            maxLines: 3,
          ),
        ),
      ),
    );
  }
}
