import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/api/netease_cloud_music.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/album_entity.dart';
import 'package:neatease_app/entity/banner_entity.dart';
import 'package:neatease_app/entity/highquality_entity.dart';
import 'package:neatease_app/entity/level_entity.dart';
import 'package:neatease_app/entity/like_song_list_entity.dart';
import 'package:neatease_app/entity/login_entity.dart';
import 'package:neatease_app/entity/lyric_entity.dart';
import 'package:neatease_app/entity/new_song_entity.dart';
import 'package:neatease_app/entity/personal_entity.dart';
import 'package:neatease_app/entity/play_history_entity.dart';
import 'package:neatease_app/entity/search_song_entity.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_talk_entity.dart';
import 'package:neatease_app/entity/today_song_entity.dart';
import 'package:neatease_app/entity/top_entity.dart';
import 'package:neatease_app/entity/user_order_entity.dart';
import 'package:neatease_app/entity/user_profile_entity.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:path_provider/path_provider.dart';

class NetUtils {
  static final NetUtils _netUtils = NetUtils._internal(); //1
  factory NetUtils() {
    return _netUtils;
  }

  NetUtils._internal();

  //统一请求"msg" -> "data inconstant when unbooked playlist, pid:2427280345 userId:302618605"
  Future<Map> _doHandler(String url, [Map param = const {}]) async {
    var answer =
        await cloudMusicApi(url, parameter: param, cookie: await _getCookie());
    var map;
    if (answer.status == 200) {
      if (answer.cookie != null && answer.cookie.length > 0) {
        await _saveCookie(answer.cookie);
      }
      map = answer.body;
    }

    return map;
  }

  //获取歌单广场推荐
  Future<HighqualityEntity> getSheet(type, page) async {
    var answer = await top_playlist({
      'cat': type,
      'limit': page * 15,
    }, await SelfUtil.getCookie());
    return answer.status == 200
        ? HighqualityEntity.fromJson(answer.body)
        : null;
  }

//保存cookie
  Future<void> _saveCookie(List<Cookie> cookies) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cookie = new PersistCookieJar(dir: tempPath, ignoreExpires: true);
    cookie.saveFromResponse(Uri.parse("https://music.163.com/weapi/"), cookies);
  }

//获取cookie
  Future<List<Cookie>> _getCookie() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    CookieJar cookie = new PersistCookieJar(dir: tempPath, ignoreExpires: true);
    return cookie.loadForRequest(Uri.parse('https://music.163.com/weapi/'));
  }

//手机号登录
  Future<LoginEntity> loginByPhone(
      context, String phone, String password) async {
    var login;
    var map = await _doHandler(
        "/login/cellphone", {"phone": phone, "password": password});
    if (map != null) {
      login = LoginEntity.fromJson(map);
    }
    return login;
  }

//邮箱登录
  Future<LoginEntity> loginByEmail(String email, String password) async {
    var login;
    var map =
        await _doHandler('/login', {'email': email, 'password': password});
    if (map != null) {
      SpUtil.putObject(USER, map);
      login = LoginEntity.fromJson(map);
    }
    return login;
  }

  // ///获取用户听歌历史
  // Future<PlayHistoryEntity> userHistory(uid, type) async {
  //   PlayHistoryEntity _playHsitory;
  //   var map = await _doHandler('/user/record', {'uid': uid, 'type': type});
  //   if (map != null) {
  //     _playHsitory = PlayHistoryEntity.fromJson(map);
  //   }
  //   return _playHsitory;
  // }

  ///获取用户等级
  Future<int> userLevel() async {
    int level;
    LevelEntity levelEntity;
    var map = await _doHandler(
      '/user/level',
    );
    if (map != null) {
      levelEntity = LevelEntity.fromJson(map);
      SpUtil.putInt(USER_LEVEL, levelEntity.data.level);
      level = levelEntity.data.level;
    }
    return level;
  }

  //获取专辑详情
  Future<AlbumEntity> getAlbumDetail(id) async {
    AlbumEntity albumEntity;
    var map = await _doHandler("/album", {'id': id});
    if (map != null) {
      albumEntity = AlbumEntity.fromJson(map);
    }
    return albumEntity;
  }

//获取歌单详情
  Future<SheetDetailsEntity> getPlayListDetails(id) async {
    SheetDetailsEntity sheetDetails;
    var map = await _doHandler('/playlist/detail', {'id': id});
    if (map != null) sheetDetails = SheetDetailsEntity.fromJson(map);
    var trackIds2 = sheetDetails.playlist.trackIds;
    List<int> ids = [];
    Future.forEach(trackIds2, (id) => ids.add(id.id));
    var list = await getSongDetails(ids.join(','));
    sheetDetails.playlist.tracks = list;
    return sheetDetails;
  }

//获取歌曲详情
  Future<List<SheetDetailsPlaylistTrack>> getSongDetails(ids) async {
    var songDetails;
    var map = await _doHandler('/song/detail', {'ids': ids});
    if (map != null) {
      var body = map['songs'];
      List<SheetDetailsPlaylistTrack> songs = [];
      await Future.forEach(body, (element) {
        var sheetDetailsPlaylistTrack =
            SheetDetailsPlaylistTrack.fromJson(element);
        songs.add(sheetDetailsPlaylistTrack);
      });
      songDetails = songs;
    }
    return songDetails;
  }

//每日推荐
  Future<TodaySongEntity> getTodaySongs() async {
    var todaySongs;
    var map = await _doHandler('/recommend/songs');
    if (map != null) return TodaySongEntity.fromJson(map);
    return todaySongs;
  }

//获取个人信息
  Future<UserProfileEntity> getUserProfile(userId) async {
    var profile;
    var map = await _doHandler("/user/detail", {'uid': userId});
    if (map != null)
      profile = UserProfileEntity.fromJson(Map<String, dynamic>.from(map));
    return profile;
  }

//获取评论预览
  Future<SongTalkEntity> getSongTalkCommants(
    id, {
    @required Map<String, dynamic> params,
  }) async {
    var talkEntity;
    var map = await _doHandler("/comment/music", {'id': id, params: params});
    if (map != null) {
      talkEntity = SongTalkEntity.fromJson(map);
    }
    return talkEntity;
  }

  ///新版获取评论：可选参数：pageNo（分页参数） pageSize（分页参数：数据） sortType（ 排序方式,1:按推荐排序,2:按热度排序,3:按时间排序）
  ///cursor（当sortType为3时且页数不是第一页时需传入,值为上一条数据的time）
  Future<SongTalkEntity> getNewTalkCommants(int type, id,
      {@required Map<String, dynamic> params}) async {
    var songTalkEntity;
    var map = await _doHandler(
        '/comment/new', {'id': id, 'type': type, params: params});
    if (map != null) {
      songTalkEntity = SongTalkEntity.fromJson(map);
    }
    return songTalkEntity;
  }

  ///获取用户喜爱的歌曲
  Future<void> getLoveSong(id) async {
//  Response likeList = await HttpUtil().post('/likelist',data: {'uid': id});
    var likeList = await likelist({'uid': id}, await SelfUtil.getCookie());
    var likeSongListEntity =
        LikeSongListEntity.fromJson(Map<String, dynamic>.from(likeList.body));
    List<String> likes = List();
    likeSongListEntity.ids.forEach((id) {
      likes.add('$id');
    });
    //本地保存收藏歌曲列表
    SpUtil.putStringList(LIKE_SONGS, likes);
  }

//获取用户歌单
  Future<UserOrderEntity> getUserPlayList(userId) async {
    var playlist;
    var map = await _doHandler('/user/playlist', {'uid': userId});
    if (map != null) playlist = UserOrderEntity.fromJson(map);
    return playlist;
  }

//推荐歌单
  Future<PersonalEntity> getRecommendResource() async {
    var playlist;
    var map = await _doHandler('/personalized');
    if (map != null) playlist = PersonalEntity.fromJson(map);
    return playlist;
  }

//banner
  Future<BannerEntity> getBanner() async {
    var banner;
    var map = await _doHandler('/banner');
    if (map != null) banner = BannerEntity.fromJson(map);
    return banner;
  }

//新歌推荐
  Future<NewSongEntity> getNewSongs() async {
    var newSongs;
    var map = await _doHandler('/personalized/newsong');
    if (map != null) newSongs = NewSongEntity.fromJson(map);
    return newSongs;
  }

//获取歌曲播放地址
  Future<String> getSongUrl(songId) async {
    var songUrl = '';
    var map = await _doHandler('/song/url', {'id': songId, 'br': '320000'});
    if (map != null) songUrl = map['data'][0]['url'];
    return songUrl;
  }

//根据id获取排行榜/top/list
  Future<TopEntity> getTopData(id) async {
    var top;
    var map = await _doHandler('/top/list', {'idx': id});
    if (map != null) top = TopEntity.fromJson(map);
    return top;
  }

//根据ID删除创建歌单
  Future<bool> delPlayList(id) async {
    var del = false;
    var map = await _doHandler('/playlist/del', {'id': id});
    del = map != null;
    return del;
  }

  ///1收藏0取消收藏
  Future<bool> subPlaylist(bool isSub, id) async {
    bool sub = false;
    var map =
        await _doHandler('/playlist/subscribe', {'t': isSub ? 1 : 0, 'id': id});
    sub = map != null;
    return sub;
  }

  ///收藏/取消收藏 歌曲
  void subSongs(String id, bool like) async {
    var answer =
        await like_song({'id': id, 'like': like}, await SelfUtil.getCookie());
    if (answer.status == 200) {
      if (like) {
        Application.loveList.add(id);
      } else {
        Application.loveList.remove(id);
      }
      SpUtil.putStringList(LIKE_SONGS, Application.loveList);
    }
  }

//創建歌單
  Future<bool> createPlayList(name) async {
    bool create = false;
    var map = await _doHandler('/playlist/create', {'name': name});
    if (map != null) create = map != null;
    return create;
  }

//搜索// 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
  Future<SearchSongEntity> search(content, type) async {
    var searchData;
    var map = await _doHandler('/search', {'keywords': content, 'type': type});
    if (map != null) searchData = SearchSongEntity.fromJson(map);
    return searchData;
  }

  ///获取用户播放历史
  Future<PlayHistoryEntity> getHistory(uid) async {
    var history;
    var map = await _doHandler('/user/record', {'uid': uid});
    if (map != null) history = PlayHistoryEntity.fromJson(map);
    return history;
  }

  //获取歌词
  Future<LyricEntity> getLyric(id) async {
    var answer = await lyric({'id': id}, await SelfUtil.getCookie());
//  Response sheet = await HttpUtil().get('/lyric', data: {'id': id});
//  var data = sheet.data;
//  var jsonDecode2 = jsonDecode(data);q
    if (answer.status == 200 && answer.body != null) {
      return LyricEntity.fromJson(answer.body);
    } else
      return null;
  }
}
