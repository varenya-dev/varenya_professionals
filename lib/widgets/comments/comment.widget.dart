import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/enum/post_options_type.enum.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class Comment extends StatefulWidget {
  final Post comment;
  final Function onEditComment;
  final Function onDeleteComment;

  Comment({
    Key? key,
    required this.comment,
    required this.onEditComment,
    required this.onDeleteComment,
  }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.02,
        horizontal: MediaQuery.of(context).size.width * 0.02,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: widget.comment.user.role == Roles.PROFESSIONAL
                    ? ProfilePictureWidget(
                  imageUrl: this.widget.comment.user.doctor!.imageUrl,
                  size: 40,
                )
                    : ProfilePictureWidget(
                  imageUrl: '',
                  size: 40,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.comment.user.role == Roles.PROFESSIONAL
                      ? Text('Dr. ${widget.comment.user.doctor!.fullName}')
                      : Text('${widget.comment.user.randomName!.randomName}'),
                  Text(this.widget.comment.body),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Consumer<UserProvider>(
                builder: (context, user, _) =>
                this.widget.comment.user.firebaseId == user.user.uid
                    ? PopupMenuButton(
                  child: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Update Comment"),
                      value: PostOptionsType.UPDATE,
                    ),
                    PopupMenuItem(
                      child: Text("Delete Comment"),
                      value: PostOptionsType.DELETE,
                    ),
                  ],
                  onSelected: (PostOptionsType selectedData) {
                    if (selectedData == PostOptionsType.UPDATE) {
                      widget.onEditComment(
                        context,
                        this.widget.comment,
                      );
                    }
                    if (selectedData == PostOptionsType.DELETE) {
                      widget.onDeleteComment(
                        context,
                        this.widget.comment.id,
                      );
                    }
                  },
                )
                    : SizedBox(
                  width: MediaQuery.of(context).size.width * 0.057,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
