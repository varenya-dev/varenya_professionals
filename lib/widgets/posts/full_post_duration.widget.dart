import 'package:flutter/material.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/post/post.model.dart';

class FullPostDuration extends StatelessWidget {
  const FullPostDuration({
    Key? key,
    required this.context,
    required Post? post,
    required this.duration,
  })  : _post = post,
        super(key: key);

  final BuildContext context;
  final Post? _post;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.01,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this._post!.user.role == Roles.PROFESSIONAL
                ? "Dr. ${this._post!.user.doctor!.fullName}"
                : this._post!.user.randomName!.randomName,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          if (duration.inSeconds < 60)
            Text(
              '${duration.inSeconds}s ago',
              style: Theme.of(context).textTheme.subtitle1,
            )
          else if (duration.inSeconds < 3600)
            Text(
              '${duration.inMinutes}m ago',
              style: Theme.of(context).textTheme.subtitle1,
            )
          else
            Text(
              '${duration.inHours}h ago',
              style: Theme.of(context).textTheme.subtitle1,
            )
        ],
      ),
    );
  }
}