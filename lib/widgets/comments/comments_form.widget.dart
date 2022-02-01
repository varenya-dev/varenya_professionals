import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/comments/create_comment/create_comment.dto.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/services/comments.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';

class CommentForm extends StatefulWidget {
  final Function refreshPost;
  final String postId;

  CommentForm({
    Key? key,
    required this.refreshPost,
    required this.postId,
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
      CreateCommentDto createCommentDto = new CreateCommentDto(
        comment: this._commentController.text,
        postId: widget.postId,
      );

      await this._commentsService.createNewComment(createCommentDto);
      await widget.refreshPost();

      displaySnackbar("Comment created!", context);
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
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Form(
        key: this._formKey,
        child: CustomTextArea(
          helperText: 'Type a comment...',
          textFieldController: this._commentController,
          validators: [
            RequiredValidator(
              errorText: 'Please enter some text',
            ),
          ],
          textInputType: TextInputType.text,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.chat,
              color: Palette.primary,
            ),
            onPressed: this._onFormSubmit,
          ),
        ),
      ),
    );
  }
}
