import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int selectedScreenIndex = 0;

  onNavigationChange(int index) {
    selectedScreenIndex = index;
    notifyListeners();
  }
}
