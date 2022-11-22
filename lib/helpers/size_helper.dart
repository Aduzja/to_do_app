import 'package:flutter/material.dart';

class SizeHelper {
  const SizeHelper();

  static double getSizeFromPx(BuildContext context, int px) {
    const width = 1280;
    final size = (px / width) * MediaQuery.of(context).size.width;
    return size;
  }
}
