import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/widgets/posts/post_card.widget.dart';

class NewPosts extends StatefulWidget {
  const NewPosts({Key? key}) : super(key: key);

  static const routeName = "/new-posts";

  @override
  _NewPostsState createState() => _NewPostsState();
}

class _NewPostsState extends State<NewPosts> {
  late final PostService _postService;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: this._postService.fetchNewPosts(),
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
                    print(snapshot.error);
                    return Text("Something went wrong, please try again later");
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
      ),
    );
  }
}
