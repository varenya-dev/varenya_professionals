import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/posts/post_options_modal.widget.dart';

class PostCardTitle extends StatelessWidget {
  const PostCardTitle({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  void _openPostOptions(BuildContext context) {
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
        post: this.post,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder:
          (BuildContext context, UserProvider userProvider, Widget? child) {
        User user = userProvider.user;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            child!,
            if (user.uid == this.post.user.firebaseId)
              IconButton(
                onPressed: () => this._openPostOptions(context),
                icon: Icon(
                  Icons.more_vert,
                ),
              ),
          ],
        );
      },
      child: Container(
        margin: EdgeInsets.all(
          MediaQuery.of(context).size.height * 0.01,
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          this.post.title,
          style: TextStyle(
            fontSize: responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.02,
              medium: MediaQuery.of(context).size.width * 0.02,
              small: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          overflow: TextOverflow.visible,
          maxLines: 3,
        ),
      ),
    );
  }
}
