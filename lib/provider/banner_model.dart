import 'package:flutter/material.dart';

class BannerModel with ChangeNotifier {
  bool circle = true;
  void changeAutoPlay() {
    circle = !circle;
    notifyListeners();
  }
}
