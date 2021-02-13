import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/album_entity.dart';
import 'package:neatease_app/entity/play_history_entity.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/entity/song_info.dart';
import 'package:neatease_app/entity/today_song_entity.dart';
import 'package:path_provider/path_provider.dart';

class SelfUtil {
  static String unix2Time(unix) {
    var minStr, secStr;
    unix = unix ~/ 1000;
    var min = unix ~/ 60;
    var sec = unix - min * 60;
    minStr = '$min';
    secStr = '$sec';
    if (min < 10) minStr = '0$min';
    if (sec < 10) secStr = '0$sec';
    return '$minStr:$secStr';
  }

  static isEmail(String email) {
    return new RegExp(r'^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$').hasMatch(email);
  }

  static Widget getPlayMode(PlayModeType playModeType) {
    Icon icon = Icon(Icons.repeat);
    switch (playModeType) {
      case PlayModeType.REPEAT:
        icon = Icon(Icons.repeat);
        break;
      case PlayModeType.REPEAT_ONE:
        icon = Icon(Icons.repeat_one);
        break;
      case PlayModeType.SHUFFLE:
        icon = Icon(Icons.shuffle);
        break;
    }
    return icon;
  }

//  static void saveCookie(List<Cookie> cookie) {
//    List<SaveCookieEntity> cookies = new List();
//    cookie.forEach((Cookie c) {
//      SaveCookieEntity myCookie = new SaveCookieEntity(
//          name: c.name,
//          value: c.value,
//          maxAge: c.maxAge,
//          domain: c.domain,
//          path: c.path);
//      cookies.add(myCookie);
//    });
//    SpUtil.putObjectList('cookies', cookies);
//  }

  static Future<List<Cookie>> getCookie() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cookie = new PersistCookieJar(dir: tempPath, ignoreExpires: true);
    return cookie.loadForRequest(Uri.parse('https://music.163.com/weapi/'));
  }

  static Future<List<SongInfo>> songToSongInfo(
      List<SheetDetailsPlaylistTrack> songs) async {
    List<SongInfo> info = [];
    await Future.forEach(songs, (SheetDetailsPlaylistTrack element) {
      SongInfo songInfo = SongInfo(
          songId: '${element.id}',
          duration: element.dt,
          songCover: '${element.al.picUrl}',
          songUrl: '',
          songName: '${element.name}',
          artist: '${element.ar[0].name}');
      info.add(songInfo);
    });
    return info;
  }

  ///将专辑信息转换为歌单
  static SheetDetailsPlaylist albumToSheetDetailsPlaylist(
      AlbumEntity albumEntity) {
    SheetDetailsPlaylist sheetDetailsPlaylist;
    var r = albumEntity.album;
    sheetDetailsPlaylist = SheetDetailsPlaylist(
      commentCount: r.info.commentCount,
      shareCount: r.info.shareCount,
      subscribedCount: r.info.likedCount,
      subscribed: r.info.liked,
      trackCount: albumEntity.songs.length,
      name: r.name,
      id: r.id,
      description: r.description,
      tracks: albumEntity.songs,
      tags: [],
      creator: SheetDetailsPlaylistCreator(
        userId: r.artist.id,
        nickname: r.artist.name,
        avatarUrl: r.picUrl,
      ),
      coverImgUrl: r.picUrl,
    );
    return sheetDetailsPlaylist;
  }

  ///将历史entity转为SongBeanEntity
  static Future<List<SongBeanEntity>> historyToSongBeanEntity(
      List<PlayHistoryAlldata> songs) async {
    List<SongBeanEntity> info = [];
    await Future.forEach(songs, (PlayHistoryAlldata element) {
      SongBeanEntity songInfo = SongBeanEntity(
        id: '${element.song.id}',
        picUrl: '${element.song.al.picUrl}',
        like: Application.loveList.indexOf('${element.song.id}') != -1
            ? true
            : false,
        name: '${element.song.name}',
        mv: element.song.mv,
        singer: '${element.song.ar.map((a) => a.name).toList().join('/')}',
      );
      info.add(songInfo);
    });
    return info;
  }

  static Future<List<SongInfo>> todayToSongInfo(
      List<TodaySongRecommand> songs) async {
    List<SongInfo> info = [];
    await Future.forEach(songs, (TodaySongRecommand element) {
      SongInfo songInfo = SongInfo(
          songId: '${element.id}',
          duration: element.duration,
          songCover: '${element.album.picUrl}',
          songUrl: '',
          songName: '${element.name}',
          artist: '${element.artists[0].name}');
      info.add(songInfo);
    });
    return info;
  }

  static List<Lyric> getLyric(String lyric) {
    var split = lyric.split('\n');
    split.forEach((str) {});
  }

  /// 格式化歌词
  static List<Lyric> formatLyric(String lyricStr) {
    RegExp reg =
        RegExp(r"(?<=\[)\d{2}:\d{2}.\d{2,3}.*?(?=\[)|[^\[]+$", dotAll: true);

    var matches = reg.allMatches(lyricStr);
    var lyrics = matches.map((m) {
      var matchStr = m.group(0).replaceAll("\n", "");
      var symbolIndex = matchStr.indexOf("]");
      var time = matchStr.substring(0, symbolIndex);
      var lyric = matchStr.substring(symbolIndex + 1);
      var duration = lyricTimeToDuration(time);
      return Lyric(lyric, startTime: duration);
    }).toList();
    //移除所有空歌词
    lyrics.removeWhere((lyric) => lyric.lyric.trim().isEmpty);
    for (int i = 0; i < lyrics.length - 1; i++) {
      lyrics[i].endTime = lyrics[i + 1].startTime;
    }
    lyrics.last.endTime = Duration(hours: 200);
    return lyrics;
  }

  static Duration lyricTimeToDuration(String time) {
    int hourSeparatorIndex = time.indexOf(":");
    int minuteSeparatorIndex = time.indexOf(".");

    var milliseconds = time.substring(minuteSeparatorIndex + 1);
    var microseconds = 0;
    if (milliseconds.length > 3) {
      microseconds = int.parse(milliseconds.substring(3, milliseconds.length));
      milliseconds = milliseconds.substring(0, 3);
    }
    return Duration(
      minutes: int.parse(
        time.substring(0, hourSeparatorIndex),
      ),
      seconds: int.parse(
          time.substring(hourSeparatorIndex + 1, minuteSeparatorIndex)),
      milliseconds: int.parse(milliseconds),
      microseconds: microseconds,
    );
  }

  static int findLyricIndex(double curDuration, List<Lyric> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime.inMilliseconds &&
          curDuration <= lyrics[i].endTime.inMilliseconds) {
        return i;
      }
    }
    return 0;
  }

  static int str2Millisecond(str) {
    if (str.length == 9 || str.length == 8) {
      str = str.replaceAll(":", "."); //00.40.57
      str = str.replaceAll(".", "@"); //00@40@57
      var timeData = str.split("@"); //[00, 40, 57]
      int minute = int.parse(timeData[0]); //数组里的第1个数据是分0
      int second = int.parse(timeData[1]); //数组里的第2个数据是秒40
      int millisecond = int.parse(timeData[2]); //数组里的第3个数据是秒57
      return (minute * 60 * 1000 +
          second * 1000 +
          millisecond); //40000+570=40570
    }
    return 0;
  }

  // static bool isLogin() {
  //   return SpUtil.getInt( USER_ID, defValue: -1) != -1;
  // }

  static showToast(msg) {
//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.BOTTOM,
//        timeInSecForIos: 1,
//        backgroundColor: Colors.white,
//        textColor: Colors.black,
//        fontSize: 14.0);
  }
}

class Lyric {
  String lyric;
  Duration startTime;
  Duration endTime;
  double offset;

  Lyric(this.lyric, {this.startTime, this.endTime, this.offset});

  @override
  String toString() {
    return 'Lyric{lyric: $lyric, startTime: $startTime, endTime: $endTime}';
  }
}
