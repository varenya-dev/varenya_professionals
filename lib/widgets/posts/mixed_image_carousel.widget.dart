import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MixedImageCarousel extends StatelessWidget {
  final List<String> images;
  final Function onDelete;

  const MixedImageCarousel({
    Key? key,
    required this.images,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.images.length != 0
          ? MediaQuery.of(context).size.height * 0.45
          : 0,
      child: this.images.length != 0
          ? ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.images.length,
        itemBuilder: (context, index) => Container(
          child: this.images[index].startsWith("http")
              ? Stack(
            children: [
              CachedNetworkImage(
                imageUrl: this.images[index],
                progressIndicatorBuilder:
                    (context, url, downloadProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  );
                },
                errorWidget: (context, url, error) {
                  print(error);
                  return Icon(Icons.error);
                },
              ),
              IconButton(
                onPressed: () {
                  this.onDelete(this.images[index]);
                },
                icon: Icon(Icons.clear),
              ),
            ],
          )
              : Stack(
            children: [
              Image.file(
                new File(this.images[index]),
              ),
              IconButton(
                onPressed: () {
                  this.onDelete(this.images[index]);
                },
                icon: Icon(Icons.clear),
              ),
            ],
          ),
        ),
      )
          : Container(),
    );
  }
}
