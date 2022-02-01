import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/post/delete_post/delete_post.dto.dart';
import 'package:varenya_professionals/enum/post_options_type.enum.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/exceptions/auth/not_logged_in_exception.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';
import 'package:varenya_professionals/pages/post/update_post.page.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/widgets/common/profile_picture_widget.dart';

class PostUserDetails extends StatefulWidget {
  final ServerUser serverUser;
  final Post post;

  const PostUserDetails({
    Key? key,
    required this.serverUser,
    required this.post,
  }) : super(key: key);

  @override
  State<PostUserDetails> createState() => _PostUserDetailsState();
}

class _PostUserDetailsState extends State<PostUserDetails> {
  // Post Service
  late final PostService _postService;

  @override
  void initState() {
    super.initState();

    // Injecting post service from global state.
    this._postService = Provider.of<PostService>(context, listen: false);
  }

  /*
   * Method to display an alert dialog to confirm post deletion.
   * @param context Build Context.
   */
  void _onDeletePost(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Are you sure you want to delete this post?'),
        content: Text(
          this.widget.post.body,
        ),
        actions: [
          TextButton(
            onPressed: _confirmPostDeletion,
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

  /*
   * Method to delete post from server.
   */
  Future<void> _confirmPostDeletion() async {
    try {
      // Send request to server to delete post.
      await this._postService.deletePost(
        new DeletePostDto(
          id: this.widget.post.id,
        ),
      );

      // Close alert dialog.
      Navigator.of(context).pop();

      // Display deletion confirmation.
      displaySnackbar("Post Deleted!", context);
    }
    // Handle errors gracefully.
    on ServerException catch (error) {
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
      log.e("PostUserDetails:_confirmPostDeletion", error, stackTrace);

      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return this.widget.serverUser.role == Roles.PROFESSIONAL
        ? Row(
      children: [
        Container(
          margin: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          child: ProfilePictureWidget(
            imageUrl: this.widget.serverUser.doctor!.imageUrl,
            size: 30,
          ),
        ),
        Text(
          "Dr. ${this.widget.serverUser.doctor!.fullName}",
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    )
        : Row(
      children: [
        Container(
          margin: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.02,
          ),
          child: ProfilePictureWidget(
            imageUrl: '',
            size: 30,
          ),
        ),
        Text(
          this.widget.serverUser.randomName!.randomName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }
}
