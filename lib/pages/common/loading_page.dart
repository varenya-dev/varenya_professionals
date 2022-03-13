import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.asset(
                'assets/logo/app_logo.png',
                // scale: 0.5,
              ),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
