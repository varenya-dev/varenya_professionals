import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post.model.dart';

class PostCardResponses extends StatelessWidget {
  const PostCardResponses({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(
        MediaQuery.of(context).size.height * 0.01,
      ),
      child: Text(
        '${this.post.comments.length} responses',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
