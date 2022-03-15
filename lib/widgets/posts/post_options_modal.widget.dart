import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/post/delete_post/delete_post.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/pages/post/update_post.page.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';

class PostOptionsModal extends StatefulWidget {
  final Post post;

  const PostOptionsModal({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  _PostOptionsModalState createState() => _PostOptionsModalState();
}

class _PostOptionsModalState extends State<PostOptionsModal> {
  late final PostService _postService;

  @override
  void initState() {
    super.initState();
    this._postService = Provider.of<PostService>(context, listen: false);
  }

  void _voidOpenDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: this._onDeletePost,
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDeletePost() async {
    try {
      DeletePostDto deletePostDto = new DeletePostDto(
        id: this.widget.post.id,
      );

      await this._postService.deletePost(deletePostDto);

      displaySnackbar("Post Deleted!", context);

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("PostOptionsModal:_onDeletePost", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.width * 0.25,
          medium: MediaQuery.of(context).size.width * 0.2,
          small: MediaQuery.of(context).size.width * 0.03,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text(
              'Update Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                UpdatePost.routeName,
                arguments: this.widget.post,
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete,
            ),
            title: Text(
              'Delete Post',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: this._voidOpenDeleteConfirmation,
          ),
        ],
      ),
    );
  }
}
