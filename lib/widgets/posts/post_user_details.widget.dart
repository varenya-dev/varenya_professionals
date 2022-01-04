import 'package:flutter/material.dart';
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
  late final PostService _postService;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  void _onDeletePost(BuildContext context) {
    displayBottomSheet(
      context,
      Wrap(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Are you sure you want to delete this post?'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  await _confirmPostDeletion(context);
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
        ],
      ),
    );
  }

  Future<void> _confirmPostDeletion(BuildContext context) async {
    try {
      await this._postService.deletePost(
            new DeletePostDto(
              id: this.widget.post.id,
            ),
          );

      Navigator.of(context).pop();

      displaySnackbar("Post Deleted!", context);
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
      print(error);
      print(stackTrace);

      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        this.widget.serverUser.role == Roles.PROFESSIONAL
            ? Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ProfilePictureWidget(
                      imageUrl: this.widget.serverUser.doctor!.imageUrl,
                      size: 40,
                    ),
                  ),
                  Text(
                    "Dr. ${this.widget.serverUser.doctor!.fullName} posted",
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: ProfilePictureWidget(
                      imageUrl: '',
                      size: 40,
                    ),
                  ),
                  Text(
                    "${this.widget.serverUser.randomName!.randomName} posted",
                  ),
                ],
              ),
        Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, user, _) =>
                  this.widget.serverUser.firebaseId == user.user.uid
                      ? Container(
                          margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: PopupMenuButton(
                            enabled: true,
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text("Update Post"),
                                value: PostOptionsType.UPDATE,
                              ),
                              PopupMenuItem(
                                child: Text("Delete Post"),
                                value: PostOptionsType.DELETE,
                              ),
                            ],
                            onSelected: (PostOptionsType selectedData) {
                              if (selectedData == PostOptionsType.UPDATE) {
                                Navigator.of(context).pushNamed(
                                  UpdatePost.routeName,
                                  arguments: this.widget.post,
                                );
                              }
                              if (selectedData == PostOptionsType.DELETE) {
                                this._onDeletePost(context);
                              }
                            },
                          ),
                        )
                      : SizedBox(),
            ),
          ],
        ),
      ],
    );
  }
}
