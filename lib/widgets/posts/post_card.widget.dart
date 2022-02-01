import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/widgets/posts/post_card_responses.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_card_title.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_categories.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_user_details.widget.dart';
import 'package:varenya_professionals/pages/post/post.page.dart' as PostPage;

class PostCard extends StatelessWidget {
  // Post data
  final Post post;

  PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder:
          (BuildContext context, ConnectivityResult result, Widget child) {
        final bool connected = result != ConnectivityResult.none;

        return GestureDetector(
          onTap: connected
              ? () {
            // Push the Full Post Page on
            // top with required arguments.
            Navigator.of(context).pushNamed(
              PostPage.Post.routeName,
              arguments: this.post.id,
            );
          }
              : null,
          child: child,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCategories(
                categories: this.post.categories,
                duration: DateTime.now().difference(
                  this.post.createdAt,
                ),
              ),
              PostCardTitle(post: post),
              PostUserDetails(
                post: this.post,
                serverUser: this.post.user,
              ),
              Divider(),
              PostCardResponses(post: post)
            ],
          ),
        ),
      ),
    );
  }
}
