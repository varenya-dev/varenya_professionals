import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/animations/error.animation.dart';
import 'package:varenya_professionals/animations/loading.animation.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart' as PM;
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/comments/comment_list.widget.dart';
import 'package:varenya_professionals/widgets/comments/comments_form.widget.dart';
import 'package:varenya_professionals/widgets/posts/full_post_body.widget.dart';
import 'package:varenya_professionals/widgets/posts/full_post_duration.widget.dart';
import 'package:varenya_professionals/widgets/posts/full_post_user_details.widget.dart';
import 'package:varenya_professionals/widgets/posts/image_carousel.widget.dart';

import '../../utils/responsive_config.util.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  static const routeName = "/post";

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  String? _postId;
  PM.Post? _post;
  late final PostService _postService;

  final DateTime _now = DateTime.now();

  bool _showCommentForm = false;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (this._postId == null) {
      this._postId = ModalRoute.of(context)!.settings.arguments as String;
    }

    return Scaffold(
      bottomSheet: this._showCommentForm
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.3,
              medium: MediaQuery.of(context).size.width * 0.3,
              small: MediaQuery.of(context).size.width,
            ),
            child: CommentForm(
              refreshPost: () {
                setState(() {});
              },
              postId: this._post!.id,
            ),
          ),
        ],
      )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder(
            future: this._postService.fetchPostsById(this._postId!),
            builder: (
                BuildContext context,
                AsyncSnapshot<PM.Post> snapshot,
                ) {
              if (snapshot.hasError) {
                switch (snapshot.error.runtimeType) {
                  case ServerException:
                    {
                      ServerException exception =
                      snapshot.error as ServerException;
                      return Error(message: exception.message);
                    }
                  default:
                    {
                      log.e(
                        "Post Error",
                        snapshot.error,
                        snapshot.stackTrace,
                      );
                      return Error(
                        message: "Something went wrong, please try again later",
                      );
                    }
                }
              }

              if (snapshot.connectionState == ConnectionState.done) {
                this._post = snapshot.data!;

                return _buildBody();
              }

              return this._post == null
                  ? Loading(message: 'Loading post details')
                  : _buildBody();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    Duration duration = _now.difference(this._post!.createdAt);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.width * 0.3,
          medium: MediaQuery.of(context).size.width * 0.3,
          small: 0,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FullPostUserDetails(
              context: context,
              post: _post!,
            ),
            ImageCarousel(
              imageUrls: this._post!.images,
            ),
            FullPostDuration(
              context: context,
              post: _post,
              duration: duration,
            ),
            FullPostBody(
              context: context,
              post: _post,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: TextButton(
                onPressed: () => setState(() {
                  this._showCommentForm = !this._showCommentForm;
                }),
                child: Text(
                  'Add Comment',
                ),
              ),
            ),
            CommentList(
              comments: this._post!.comments,
              refreshPost: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
