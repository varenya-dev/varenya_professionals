import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/widgets/posts/post_card.widget.dart';

class CategorizedPosts extends StatefulWidget {
  const CategorizedPosts({Key? key}) : super(key: key);

  static const routeName = "/categorized-posts";

  @override
  _CategorizedPostsState createState() => _CategorizedPostsState();
}

class _CategorizedPostsState extends State<CategorizedPosts> {
  late final PostService _postService;
  String _categoryName = 'NEW';

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  void _openPostCategoriesFilters() {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            FutureBuilder(
              future: this._postService.fetchCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PostCategory>> snapshot) {
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
                          "Something went wrong, please try again later",
                        );
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<PostCategory> categories = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: categories
                        .map(
                          (category) => ListTile(
                            title: Text(
                              category.categoryName,
                            ),
                            leading: Radio(
                              value: category.categoryName,
                              groupValue: this._categoryName,
                              onChanged: (String? categoryValue) {
                                if (categoryValue != null) {
                                  setState(() {
                                    this._categoryName = categoryValue;
                                  });
                                  setStateInner(() {});
                                }
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._categoryName = 'NEW';
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildFilter(),
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
                          "ChatPage Error",
                          snapshot.error,
                          snapshot.stackTrace,
                        );
                        return Text(
                            "Something went wrong, please try again later");
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<Post> posts = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      Post post = posts[index];

                      return PostCard(
                        post: post,
                      );
                    },
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Show Posts By'),
          GestureDetector(
            onTap: this._openPostCategoriesFilters,
            child: Text(
              this._categoryName,
              style: TextStyle(
                color: Colors.yellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
