import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';

class PostCategories extends StatelessWidget {
  // List of categories to display.
  final List<PostCategory> categories;

  final Duration duration;

  const PostCategories({
    Key? key,
    required this.categories,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.height * 0.005,
        vertical: 0,
      ),
      child: Wrap(
        children: [
          ...this
              .categories
              .map(
                (category) => Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.005,
              ),
              child: Text(
                category.categoryName,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          )
              .toList(),
          if (duration.inSeconds < 60)
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.005,
              ),
              child: Text(
                '• ${duration.inSeconds}s ago',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          else if (duration.inSeconds < 3600)
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.005,
              ),
              child: Text(
                '• ${duration.inMinutes}m ago',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          else
            Container(
              margin: EdgeInsets.all(
                MediaQuery.of(context).size.height * 0.005,
              ),
              child: Text(
                '• ${duration.inHours}h ago',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
        ],
      ),
    );
  }
}
