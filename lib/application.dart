import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/util/sp_util.dart';

import 'route/navigate_service.dart';

class Application {
  static FluroRouter router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SpUtil sp;
  static double screenWidth;
  static double screenHeight;
  static double statusBarHeight;
  static double bottomBarHeight;
  static GetIt getIt = GetIt.instance;
  static bool loginState;
  static List<String> loveList;
  static bool fm = false;

  static setLoveList() {
    loveList = SpUtil.getStringList(LIKE_SONGS);
  }

  static initSp() async {
    sp = await SpUtil.getInstance();
  }

  static setupLocator() {
    getIt.registerSingleton(NavigateService());
  }
}
