import 'package:flutter/material.dart';

enum SpaceHeight {
  tall,
  short,
}

Widget addVerticalSpace(double height) {
  return SizedBox(
      height: height,
  );
}