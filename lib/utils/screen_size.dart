import 'package:flutter/material.dart';

class ScreenSize {
  static double _width = 0;
  static double _height = 0;
  static double _appBarHeight = 0;

  static double get width => _width;
  static double get height => _height;
  static double get appBarHeight => _appBarHeight;

  static init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  static initAppBarHeight(AppBar appBar) {
    _appBarHeight = appBar.preferredSize.height;
  }
}
