// import '../application.dart';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/route/routes.dart';

import 'fluro_convert_utils.dart';

class NavigatorUtil {
  static _navigateTo(BuildContext context, String path,
      {bool replace = false,
      bool clearStack = false,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder,
        transition: TransitionType.material);
  }

  /// 登录页
  static void goLoginPage(BuildContext context) {
    _navigateTo(context, Routes.login);
  }

  /// 首页
  static void goHomePage(BuildContext context) {
    _navigateTo(context, Routes.home, clearStack: true);
  }

  /// 每日推荐歌曲
  static void goDailySongsPage(BuildContext context) {
    _navigateTo(context, Routes.dailySongs);
  }

  /// 歌单详情
  static void goSheetDetailPage(BuildContext context, int id) {
    _navigateTo(context, "${Routes.sheetDetail}?data=$id");
  }

  // /// 排行榜首页
  // static void goTopListPage(BuildContext context) {
  //   _navigateTo(context, Routes.topList);
  // }

  /// 播放歌曲页面
  static void goPlaySongsPage(BuildContext context) {
    _navigateTo(context, Routes.playSongs);
  }

  ///跳转历史记录界面
  static void goHistoryPage(BuildContext context, int id) {
    _navigateTo(context, '${Routes.history}?data=$id');
  }

  ///跳转用户云盘界面
  static void goUserCloudPage(BuildContext context) {
    _navigateTo(context, Routes.userCloud);
  }

  /// 评论页面
  static void goCommentPage(BuildContext context,
      {@required CommentHead data}) {
    _navigateTo(context,
        "${Routes.comment}?data=${FluroConvertUtils.object2string(data)}");
  }

//   /// 搜索页面
//   static void goSearchPage(BuildContext context) {
//     _navigateTo(context, Routes.search);
//   }

//   /// 查看图片页面
//   static void goLookImgPage(
//       BuildContext context, List<String> imgs, int index) {
// //    Application.router.navigateTo(context, '${Routes.lookImg}?imgs=${FluroConvertUtils.object2string(imgs.join(','))}&index=$index', transitionBuilder: (){});
// //    _navigateTo(context, '${Routes.lookImg}?imgs=${FluroConvertUtils.object2string(imgs.join(','))}&index=$index');
// //    _navigateTo(context, '${Routes.lookImg}');
//     Navigator.push(
//       context,
//         TransparentRoute(builder: (_) => LookImgPage(imgs, index),),
//     );
//   }

//   /// 用户详情页面
//   static void goUserDetailPage(BuildContext context, int userId) {
//     _navigateTo(context, "${Routes.userDetail}?id=$userId");
//   }

}
