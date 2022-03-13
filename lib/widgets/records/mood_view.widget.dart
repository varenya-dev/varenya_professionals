import 'package:flutter/material.dart';

class MoodView extends StatelessWidget {
  final String emojiPath;

  const MoodView({Key? key, required this.emojiPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      padding: EdgeInsets.all(
        MediaQuery.of(context).size.width * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.grey[850]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      child: Image.asset(
        this.emojiPath,
      ),
    );
  }
}
