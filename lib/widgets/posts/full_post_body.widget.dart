import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post.model.dart';

class FullPostBody extends StatelessWidget {
  const FullPostBody({
    Key? key,
    required this.context,
    required Post? post,
  })  : _post = post,
        super(key: key);

  final BuildContext context;
  final Post? _post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Text(
        this._post!.body,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
