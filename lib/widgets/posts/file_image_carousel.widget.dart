import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class FileImageCarousel extends StatelessWidget {
  final List<File> fileImages;
  final Function onDelete;

  const FileImageCarousel({
    Key? key,
    required this.fileImages,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.fileImages.length != 0
          ? MediaQuery.of(context).size.height * 0.45
          : 0,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemCount: this.fileImages.length,
        itemBuilder: (context, index) => Container(
          child: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.file(
                  this.fileImages[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                    child: Image.file(
                      this.fileImages[index],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    this.onDelete(this.fileImages[index]);
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
