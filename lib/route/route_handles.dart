import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/screen/comment/comment_page.dart';
import 'package:neatease_app/screen/daily_songs/daily_songs_page.dart';
import 'package:neatease_app/screen/home/home_screen.dart';
import 'package:neatease_app/screen/login/login_page.dart';
import 'package:neatease_app/screen/mine/history/history.dart';
import 'package:neatease_app/screen/mine/user_cloud/user_cloud.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/screen/play/play_fm.dart';
import 'package:neatease_app/screen/play_video/play_video.dart';
import 'package:neatease_app/screen/search/search.dart';
import 'package:neatease_app/screen/sheet/sheet_detail.dart';
import 'package:neatease_app/screen/singer/singer_detail/singer_detail.dart';
import 'package:neatease_app/util/fluro_convert_utils.dart';

///跳转到home
var homeHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return HomeScreen();
});

///跳转到login
var loginHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return LoginPage();
});

///跳转到搜索
var searchHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return SearchPage();
});

///跳转到每日推荐
var dailySongsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return DailySongsPage();
});

///跳转到播放页
var playSongsHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return PlayBody();
});

///跳转到Fm播放页
var playFmHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return PlayFm();
});

///跳转到视频播放页
var livePageHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  var id = int.parse(params['id'].first);
  return PlayVideo(mvid: id);
});

///跳转到评论页
var commentHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  String data = params['data'].first;
  return CommentPage(CommentHead.fromJson(FluroConvertUtils.string2map(data)));
});

///跳转到歌单详情
var sheetDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  var id = int.parse(params['data'].first);
  var type = params['type'].first;
  return SheetDetail(
    id,
    type: type,
  );
});

///跳转到歌单详情
var singerDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  var id = int.parse(params['id'].first);
  return SingerDetail(id);
});

///跳转到听歌历史
var mineHistorHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  var id = int.parse(params['data'].first);
  return History(id);
});

///跳转到用户云盘
var userCloudHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<Object>> params) {
  return UserCloud();
});
