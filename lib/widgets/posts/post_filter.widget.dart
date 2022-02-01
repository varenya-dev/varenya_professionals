import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/widgets/posts/display_categories.widget.dart';

class PostFilter extends StatelessWidget {
  final String categoryName;
  final String categoryId;
  final Function addOrRemoveCategory;

  const PostFilter({
    Key? key,
    required this.categoryName,
    required this.categoryId,
    required this.addOrRemoveCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.03,
          left: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_list_outlined,
                  size: MediaQuery.of(context).size.width * 0.08,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                  ),
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                )
              ],
            ),
            DisplayCategories(
              selectedCategories: [
                new PostCategory(
                  id: this.categoryId,
                  categoryName: this.categoryName,
                ),
              ],
              addOrRemoveCategory: this.addOrRemoveCategory,
            ),
          ],
        ),
      ),
    );
  }
}
