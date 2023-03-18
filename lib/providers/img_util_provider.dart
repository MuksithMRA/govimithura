import 'package:flutter/material.dart';

class ImageUtilProvider extends ChangeNotifier {
  ImageProvider? _image;
  String? _imagePath;

  String? get imagePath => _imagePath;
  ImageProvider? get image => _image;

  set image(ImageProvider? image) {
    _image = image;
    notifyListeners();
  }

  set imagePath(String? imagePath) {
    _imagePath = imagePath;
    notifyListeners();
  }

  void clearImage() {
    _image = null;
    _imagePath = null;
    notifyListeners();
  }
}
