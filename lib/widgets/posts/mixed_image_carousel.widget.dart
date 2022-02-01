import 'dart:io';
import 'dart:ui';

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
                width: MediaQuery.of(context).size.width,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) {
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
                      filter:
                      ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  this.onDelete(this.images[index]);
                },
                icon: Icon(Icons.clear),
              ),
            ],
          )
              : Container(
            child: Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.file(
                    new File(this.images[index]),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  ClipRRect(
                    child: BackdropFilter(
                      filter:
                      ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Image.file(
                        new File(this.images[index]),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
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
          ),
        ),
      )
          : Container(),
    );
  }
}
