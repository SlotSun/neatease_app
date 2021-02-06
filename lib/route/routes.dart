import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'file:///D:/WorkSpace/neatease_app/lib/screen/home/home_screen.dart';
import 'route_handles.dart';

class Routes {
  static String root = "/";
  static String home = '/home';
  static String login = '/login';
  static String dailySongs = "/daily_songs";
  static String playList = "/play_list";
  static String playSongs = "/play";
  static String comment = "/comment";
  static String sheetDetail = '/sheet_detail';
  static String search = '/search';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return HomeScreen();
    });

    router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(dailySongs, handler: dailySongsHandler);
    router.define(playSongs, handler: playSongsHandler);
    router.define(comment, handler: commentHandler);
    router.define(sheetDetail, handler: sheetDetailHandler);
    router.define(search, handler: null);
  }
}
