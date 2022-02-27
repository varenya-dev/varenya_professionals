import 'package:flutter/material.dart';

double responsiveConfig({
  required BuildContext context,
  required double large,
  required double medium,
  required double small,
}) {
  if (MediaQuery.of(context).size.width > 1200) {
    return large;
  } else if (MediaQuery.of(context).size.width >= 800 &&
      MediaQuery.of(context).size.width <= 1200) {
    return medium;
  } else {
    return small;
  }
}
