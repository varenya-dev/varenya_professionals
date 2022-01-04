import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';

class PostCategories extends StatelessWidget {
  final List<PostCategory> categories;

  const PostCategories({
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.005,
        vertical: 0,
      ),
      child: Wrap(
        children: this
            .categories
            .map(
              (category) => Container(
            margin: EdgeInsets.all(
              MediaQuery.of(context).size.height * 0.005,
            ),
            child: Chip(
              label: Text(
                category.categoryName,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
