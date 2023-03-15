import 'package:flutter/material.dart';

class ScreenSize {
  static double _width = 0;
  static double _height = 0;

  static double get width => _width;
  static double get height => _height;

  static init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }
}
