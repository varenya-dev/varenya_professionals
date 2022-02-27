import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/pages/post/new_post.page.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class DisplayCreatePost extends StatelessWidget {
  const DisplayCreatePost({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          NewPost.routeName,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Row(
            children: [
              Consumer<UserProvider>(
                builder: (
                    BuildContext context,
                    UserProvider user,
                    _,
                    ) =>
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.03,
                        vertical: MediaQuery.of(context).size.height * 0.005,
                      ),
                      child: ProfilePictureWidget(
                        imageUrl: user.user.photoURL ?? '',
                        size: responsiveConfig(
                          context: context,
                          large: MediaQuery.of(context).size.width * 0.05,
                          medium: MediaQuery.of(context).size.width * 0.04,
                          small: MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                    ),
              ),
              Text(
                'Write Something...',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.022,
                  color: Theme.of(context).textTheme.subtitle1!.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
