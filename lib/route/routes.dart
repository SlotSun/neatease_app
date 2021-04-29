import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/screen/home/home_screen.dart';

import 'route_handles.dart';

class Routes {
  static String comment = "/comment";
  static String dailySongs = "/daily_songs";
  static String root = "/";
  static String history = '/mine/history';
  static String home = '/home';
  static String livePage = "/livePage";
  static String login = '/login';
  static String playList = "/play_list";
  static String playSongs = "/play";
  static String fm = '/fm';
  static String sheetDetail = '/sheet_detail';
  static String search = '/search';
  static String userCloud = 'user_cloud';
  static String singerDetail = '/singer_detail';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return HomeScreen();
    });
    router.define(fm, handler: playFmHandler);
    router.define(userCloud, handler: userCloudHandler);
    router.define(history, handler: mineHistorHandler);
    router.define(home, handler: homeHandler);
    router.define(login, handler: loginHandler);
    router.define(livePage, handler: livePageHandler);
    router.define(dailySongs, handler: dailySongsHandler);
    router.define(playSongs, handler: playSongsHandler);
    router.define(comment, handler: commentHandler);
    router.define(sheetDetail, handler: sheetDetailHandler);
    router.define(search, handler: searchHandler);
    router.define(singerDetail, handler: singerDetailHandler);
  }
}
