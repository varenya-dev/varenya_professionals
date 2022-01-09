import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/comments/create_comment/create_comment.dto.dart';
import 'package:varenya_professionals/dtos/comments/update_comment/update_comment.dto.dart';
import 'package:varenya_professionals/enum/comment_form_type.enum.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';

class CommentForm extends StatefulWidget {
  final Function refreshPost;
  final String postId;
  final CommentFormType commentFormType;
  final String commentId;
  final String text;

  CommentForm({
    Key? key,
    required this.refreshPost,
    required this.postId,
    required this.commentFormType,
    this.commentId = '',
    this.text = '',
  }) : super(key: key);

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  late final CommentsService _commentsService;

  final TextEditingController _commentController = new TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey();

  Future<void> _onFormSubmit() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    try {
      if (widget.commentFormType == CommentFormType.CREATE) {
        CreateCommentDto createCommentDto = new CreateCommentDto(
          comment: this._commentController.text,
          postId: widget.postId,
        );

        await this._commentsService.createNewComment(createCommentDto);
        await widget.refreshPost();

        displaySnackbar("Comment created!", context);
      } else {
        UpdateCommentDto updateCommentDto = new UpdateCommentDto(
          commentId: widget.commentId,
          comment: this._commentController.text,
        );

        await this._commentsService.updateComment(updateCommentDto);
        await widget.refreshPost();

        Navigator.of(context).pop();

        displaySnackbar("Comment updated!", context);
      }
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } on NotLoggedInException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error) {
      print(error);
      displaySnackbar("Something went wrong, please try again later.", context);
    }
  }

  @override
  void initState() {
    super.initState();

    this._commentsService =
        Provider.of<CommentsService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._commentController.text = widget.text;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Form(
        key: this._formKey,
        child: widget.commentFormType == CommentFormType.CREATE
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _children(context),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _children(context),
        ),
      ),
    );
  }

  List<Widget> _children(BuildContext context) {
    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.80,
        child: CustomTextArea(
          textFieldController: this._commentController,
          label: "Comment Here",
          validators: [
            RequiredValidator(
              errorText: 'Please enter some text',
            ),
          ],
          textInputType: TextInputType.text,
        ),
      ),
      TextButton(
        onPressed: this._onFormSubmit,
        child: Text('SUBMIT'),
      ),
    ];
  }
}
