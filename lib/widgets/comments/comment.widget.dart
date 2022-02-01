import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/comments/delete_comment/delete_comment.dto.dart';
import 'package:varenya_professionals/dtos/comments/update_comment/update_comment.dto.dart';
import 'package:varenya_professionals/enum/post_options_type.enum.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class Comment extends StatefulWidget {
  final Post comment;
  final Function refreshPost;

  Comment({
    Key? key,
    required this.comment,
    required this.refreshPost,
  }) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  late final CommentsService _commentsService;
  final TextEditingController _updateCommentController =
  new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    this._commentsService =
        Provider.of<CommentsService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._updateCommentController.dispose();
  }

  void _onDeleteComment() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Are you sure you want to delete this comment?'),
        content: Text(this.widget.comment.body),
        actions: [
          TextButton(
            onPressed: () async {
              await _confirmCommentDeletion();
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
    );
  }

  void _onUpdateComment() {
    this._updateCommentController.text = this.widget.comment.body;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Update Comment'),
        content: Form(
          key: this._formKey,
          child: CustomTextArea(
            textFieldController: this._updateCommentController,
            validators: [
              RequiredValidator(
                errorText: 'Comment is required.',
              ),
              MinLengthValidator(
                10,
                errorText: 'Comment is required.',
              ),
            ],
            textInputType: TextInputType.text,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await this._confirmCommentUpdate();
            },
            child: Text('UPDATE'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCommentDeletion() async {
    try {
      await this._commentsService.deleteComment(
        new DeleteCommentDto(
          commentId: this.widget.comment.id,
        ),
      );

      await widget.refreshPost();

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
      log.e("Comment:_confirmCommentDeletion", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  Future<void> _confirmCommentUpdate() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    try {
      UpdateCommentDto updateCommentDto = new UpdateCommentDto(
        commentId: this.widget.comment.id,
        comment: this._updateCommentController.text,
      );

      await this._commentsService.updateComment(updateCommentDto);
      await widget.refreshPost();

      Navigator.of(context).pop();

      displaySnackbar("Comment updated!", context);
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("CommentForm:_onFormSubmit", error, stackTrace);
      displaySnackbar("Something went wrong, please try again later.", context);
    }
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
                      this._onUpdateComment();
                    }
                    if (selectedData == PostOptionsType.DELETE) {
                      this._onDeleteComment();
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
