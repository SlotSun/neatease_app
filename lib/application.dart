import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'route/navigate_service.dart';

class Application{
  static FluroRouter router;
  static GlobalKey<NavigatorState> key = GlobalKey();
  static SharedPreferences sp;
  static double screenWidth;
  static double screenHeight;
  static double statusBarHeight;
  static double bottomBarHeight;
  static GetIt getIt = GetIt.instance;
  static bool loginState;
  static List<String> loveList;


  static setLoveList(){
    loveList = SpUtil.getStringList(LIKE_SONGS);
  }
  static initSp() async{
    sp = await SharedPreferences.getInstance();
  }

  static setupLocator(){
    getIt.registerSingleton(NavigateService());
  }

}