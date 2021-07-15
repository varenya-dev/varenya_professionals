import 'package:flutter/material.dart';
import 'package:varenya_professionals/page/home_page.dart';

void main() {
  runApp(Root());
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Varenya For Professionals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
