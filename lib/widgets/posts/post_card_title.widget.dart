import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';

class PostCardTitle extends StatelessWidget {
  const PostCardTitle({
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
        this.post.title,
        style: TextStyle(
          fontSize: responsiveConfig(
            context: context,
            large: MediaQuery.of(context).size.width * 0.02,
            medium: MediaQuery.of(context).size.width * 0.02,
            small: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ),
    );
  }
}
