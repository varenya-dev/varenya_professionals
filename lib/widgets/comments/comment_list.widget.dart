import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/widgets/comments/comment.widget.dart';

class CommentList extends StatelessWidget {
  final List<Post> comments;
  final Function onEditComment;
  final Function onDeleteComment;

  CommentList({
    Key? key,
    required this.comments,
    required this.onEditComment,
    required this.onDeleteComment,
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
          onEditComment: this.onEditComment,
          onDeleteComment: this.onDeleteComment,
        );
      },
    );
  }
}
