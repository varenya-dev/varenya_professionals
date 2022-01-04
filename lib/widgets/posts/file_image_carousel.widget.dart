import 'dart:io';

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
      child: this.fileImages.length != 0
          ? ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: this.fileImages.length,
        itemBuilder: (context, index) => Container(
          child: Stack(
            children: [
              Image.file(
                this.fileImages[index],
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
      )
          : Container(),
    );
  }
}
