import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class DisplayCategories extends StatefulWidget {
  final List<PostCategory> selectedCategories;
  final Function addOrRemoveCategory;

  const DisplayCategories({
    Key? key,
    required this.selectedCategories,
    required this.addOrRemoveCategory,
  }) : super(key: key);

  @override
  _DisplayCategoriesState createState() => _DisplayCategoriesState();
}

class _DisplayCategoriesState extends State<DisplayCategories> {
  late final PostService _postService;

  List<PostCategory>? _fetchedCategories;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this._postService.fetchCategories(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<PostCategory>> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  log.e(
                    "DisplayCategories Error",
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._fetchedCategories = snapshot.data!;

            return _buildCategoriesList();
          }

          return this._fetchedCategories == null
              ? CircularProgressIndicator()
              : _buildCategoriesList();
        },
      ),
    );
  }

  Wrap _buildCategoriesList() {
    return Wrap(
      children: this._fetchedCategories!.map(
        (category) {
          bool checkSelected = this
              .widget
              .selectedCategories
              .where((c) => category.id == c.id)
              .isNotEmpty;

          return GestureDetector(
            onTap: () {
              this.widget.addOrRemoveCategory(category);
            },
            child: Container(
              decoration: BoxDecoration(
                color: !checkSelected
                    ? Palette.secondary
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.02,
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.width * 0.015,
              ),
              child: Text(
                category.categoryName,
                style: TextStyle(
                  color: checkSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
