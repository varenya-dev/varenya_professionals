import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/comments/delete_comment/delete_comment.dto.dart';
import 'package:varenya_professionals/enum/comment_form_type.enum.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart' as PM;
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/comments/comment_list.widget.dart';
import 'package:varenya_professionals/widgets/comments/comments_form.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_card.widget.dart';

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
  late final CommentsService _commentsService;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
    this._commentsService =
        Provider.of<CommentsService>(context, listen: false);
  }

  void _onDeleteComment(BuildContext context, String commentID) {
    displayBottomSheet(
      context,
      Wrap(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Are you sure you want to delete this comment?'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  await _confirmCommentDeletion(context, commentID);
                },
                child: Text('YES'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onUpdateComment(BuildContext context, PM.Post comment) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Update Comment'),
        content: CommentForm(
          commentFormType: CommentFormType.UPDATE,
          refreshPost: () {
            setState(() {});
          },
          postId: this._post!.id,
          commentId: comment.id,
          text: comment.body,
        ),
      ),
    );
  }

  Future<void> _confirmCommentDeletion(
      BuildContext context, String commentId) async {
    try {
      await this._commentsService.deleteComment(
        new DeleteCommentDto(commentId: commentId),
      );

      setState(() {});

      Navigator.of(context).pop();

      displaySnackbar("Comment Deleted!", context);
    } on ServerException catch (error) {
      displaySnackbar(
        error.message,
        context,
      );
    } on NotLoggedInException catch (error) {
      displaySnackbar(
        error.message,
        context,
      );
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);

      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this._postId == null) {
      this._postId = ModalRoute.of(context)!.settings.arguments as String;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: FutureBuilder(
        future: this._postService.fetchPostsById(this._postId!),
        builder: (
            BuildContext context,
            AsyncSnapshot<PM.Post> snapshot,
            ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  print(snapshot.error);
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._post = snapshot.data!;

            return _buildBody();
          }

          return this._post == null
              ? Column(
            children: [
              CircularProgressIndicator(),
            ],
          )
              : _buildBody();
        },
      ),
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          PostCard(
            post: this._post!,
            fullPagePost: true,
          ),
          CommentForm(
            refreshPost: () {
              setState(() {});
            },
            postId: this._post!.id,
            commentFormType: CommentFormType.CREATE,
          ),
          CommentList(
            comments: this._post!.comments,
            onEditComment: this._onUpdateComment,
            onDeleteComment: this._onDeleteComment,
          ),
        ],
      ),
    );
  }
}
