import 'package:flutter/material.dart';

void displayBottomSheet(BuildContext context, Widget body) =>
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return body;
        });
