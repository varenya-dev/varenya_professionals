import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/widgets/posts/display_create_post.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_card.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_filter.widget.dart';

class CategorizedPosts extends StatefulWidget {
  const CategorizedPosts({Key? key}) : super(key: key);

  static const routeName = "/categorized-posts";

  @override
  _CategorizedPostsState createState() => _CategorizedPostsState();
}

class _CategorizedPostsState extends State<CategorizedPosts> {
  late final PostService _postService;
  String _categoryName = 'NEW';
  String _categoryId = '';
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  void _openPostCategoriesFilters() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setStateInner) => PostFilter(
          addOrRemoveCategory: (PostCategory category) {
            _handleAddOrRemoveCategory(category);

            setStateInner(() {});
          },
          categoryName: this._categoryName,
          categoryId: this._categoryId,
        ),
      ),
    );
  }

  void _handleAddOrRemoveCategory(PostCategory category) {
    if (this._categoryName == category.categoryName) {
      setState(() {
        this._categoryName = 'NEW';
        this._categoryId = '';
      });
    } else {
      setState(() {
        this._categoryName = category.categoryName;
        this._categoryId = category.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: this._openPostCategoriesFilters,
            icon: Icon(
              Icons.filter_list_outlined,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              DisplayCreatePost(),
              FutureBuilder(
                future:
                this._postService.fetchPostsByCategory(this._categoryName),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<List<Post>> snapshot,
                    ) {
                  if (snapshot.hasError) {
                    switch (snapshot.error.runtimeType) {
                      case ServerException:
                        {
                          ServerException exception =
                          snapshot.error as ServerException;
                          return Text(exception.message);
                        }
                      default:
                        {
                          log.e(
                            "CategorizedPosts Error",
                            snapshot.error,
                            snapshot.stackTrace,
                          );
                          return Text(
                              "Something went wrong, please try again later");
                        }
                    }
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    this._posts = snapshot.data!;

                    return _buildPostsList();
                  }

                  return this._posts == null
                      ? Column(
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                      : this._buildPostsList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildPostsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: this._posts!.length,
      itemBuilder: (BuildContext context, int index) {
        Post post = this._posts![index];

        return PostCard(
          post: post,
        );
      },
    );
  }
}
