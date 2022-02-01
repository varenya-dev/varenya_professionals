import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/widgets/comments/comment.widget.dart';

class CommentList extends StatelessWidget {
  final List<Post> comments;
  final Function refreshPost;

  CommentList({
    Key? key,
    required this.comments,
    required this.refreshPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.comments.length,
      itemBuilder: (BuildContext context, int index) {
        Post comment = this.comments[index];

        return Comment(
          comment: comment,
          refreshPost: refreshPost,
        );
      },
    );
  }
}
