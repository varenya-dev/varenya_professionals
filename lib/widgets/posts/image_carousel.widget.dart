import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/post/post_image/post_image.model.dart';

class ImageCarousel extends StatelessWidget {
  // List of all images.
  final List<PostImage> imageUrls;

  const ImageCarousel({
    Key? key,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.imageUrls.length != 0
          ? MediaQuery.of(context).size.height * 0.45
          : 0,
      child: this.imageUrls.length != 0
          ? ListView.builder(
        physics: PageScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.imageUrls.length,
        itemBuilder: (context, index) => CachedNetworkImage(
          imageUrl: this.imageUrls[index].imageUrl,
          width: MediaQuery.of(context).size.width,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            );
          },
          errorWidget: (context, url, error) {
            print(error);
            return Icon(Icons.error);
          },
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      )
          : SizedBox(),
    );
  }
}
