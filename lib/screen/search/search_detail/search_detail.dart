import 'package:flutter/material.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/search_mv_entity.dart';
import 'package:neatease_app/entity/search_sheet_entity.dart';
import 'package:neatease_app/entity/search_singer_entity.dart';
import 'package:neatease_app/entity/search_song_entity.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_de_entity.dart';
import 'package:neatease_app/screen/search/search_mv/search_mv.dart';
import 'package:neatease_app/screen/search/search_sheet/search_sheet.dart';
import 'package:neatease_app/screen/search/search_singer/search_singer.dart';
import 'package:neatease_app/screen/search/search_song/search_song_page.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_blackWidget.dart';
import 'package:neatease_app/widget/widget_play.dart';

class SearchDetail extends StatefulWidget {
  final searchContent;

  SearchDetail({this.searchContent});

  @override
  _SearchDetailState createState() => _SearchDetailState();
}

class _SearchDetailState extends State<SearchDetail> {
  bool isLoading = true;
  List<SheetDetailsPlaylistTrack> songs = [];
  List<SearchSingerResultArtist> artists = [];
  List<SearchSheetResultPlaylist> playlists = [];
  List<SearchMvResultMv> mvs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _init() async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var searchSheetEntity = await NetUtils().search(widget.searchContent, 1);
    if (searchSheetEntity != null) {
      List<String> ids = List();
      searchSheetEntity.result.songs.forEach((song) {
        ids.add('${song.id}');
      });
      var list = await NetUtils().getSongDetails(ids.join(','));
      songs = list;
    }
    _searchSheetData(widget.searchContent).then((sheet) {
      if (sheet != null) {
        playlists = sheet.result.playlists;
        setState(() {});
      }
    });

    _searchSingerData(widget.searchContent).then((singer) {
      if (singer != null) {
        artists = singer.result.artists;
        setState(() {});
      }
    });
    _searchMvData(widget.searchContent).then((mv) {
      if (mv != null) {
        mvs = mv.result.mvs;
        setState(() {});
      }
    });
  }

  Future<SearchSongEntity> _searchSongData(content) async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var answer = await search(
        {'keywords': content, 'type': 1}, await SelfUtil.getCookie());
    return answer.status == 200 ? SearchSongEntity.fromJson(answer.body) : null;
  }

  Future<SearchSheetEntity> _searchSheetData(content) async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var answer = await search(
        {'keywords': content, 'type': 1000}, await SelfUtil.getCookie());
    return answer.status == 200
        ? SearchSheetEntity.fromJson(answer.body)
        : null;
  }

  Future<SearchMvEntity> _searchMvData(content) async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var answer = await search(
        {'keywords': content, 'type': 1004}, await SelfUtil.getCookie());
    return answer.status == 200 ? SearchMvEntity.fromJson(answer.body) : null;
  }

  Future<SearchSingerEntity> _searchSingerData(content) async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var answer = await search(
        {'keywords': content, 'type': 100}, await SelfUtil.getCookie());
    return answer.status == 200
        ? SearchSingerEntity.fromJson(answer.body)
        : null;
  }

  Future<SongDeEntity> _getSongDetails(ids) async {
    // 1: 单曲, 10: 专辑, 100: 歌手, 1000: 歌单, 1002: 用户, 1004: MV, 1006: 歌词, 1009: 电台, 1014: 视频
    var answer = await song_detail({'ids': ids}, await SelfUtil.getCookie());
    return answer.status == 200 ? SongDeEntity.fromJson(answer.body) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: blackWidget(
          null,
          isLoading
              ? LoadingPage()
              : Container(
                  child: DefaultTabController(
                      length: 4,
                      child: Column(
                        children: <Widget>[
                          AppBar(
                            title: Text('Search: "${widget.searchContent}"'),
                            backgroundColor: Colors.transparent,
                          ),
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: EdgeInsets.all(0),
                            tabs: <Widget>[
                              Tab(text: '单曲'),
                              Tab(text: '歌单'),
                              Tab(text: '歌手'),
                              Tab(text: 'mv'),
                            ],
                          ),
                          Expanded(
                              child: TabBarView(children: <Widget>[
                            SearchSongPage(
                              songs: songs,
                            ),
                            SearchSheetPage(
                              playlists: playlists,
                            ),
                            SearchSingerPage(artists: artists),
                            SearchMvPage(mvs: mvs),
                          ])),
                          PlayWidget(),
                        ],
                      )),
                )),
    );
  }
}
