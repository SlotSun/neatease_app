import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/singer_album.dart';
import 'package:neatease_app/entity/singer_song.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_music_list_item.dart';
import 'package:provider/provider.dart';

class SingerDetail extends StatefulWidget {
  final id;

  SingerDetail(this.id);

  @override
  _SingerDetailState createState() => _SingerDetailState();
}

class _SingerDetailState extends State<SingerDetail> {
  bool isLoading = true;
  SingerSong _singerSong;
  SingerAlbum _singerAlbum;
  List<String> tabs = [
    "热门单曲",
    "专辑",
    "视频",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _request().then((value) => setState(() {
          isLoading = false;
        }));
  }

  Future _request() async {
    _singerAlbum = await _getSingerAlbum(widget.id);
    _singerSong = await _getSingerDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingPage()
          : Consumer<PlaySongsModel>(
              builder: (context, model, child) {
                return DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverAppBar(
                            title: Text(_singerSong.artist.name),
                            centerTitle: false,
                            automaticallyImplyLeading: false,
                            pinned: true,
                            primary: true,
                            snap: false,
                            elevation: 10,
                            floating: false,
                            expandedHeight: 260.0,
                            bottom: TabBar(
                              tabs: tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                            forceElevated: innerBoxIsScrolled,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 240,
                                    child: ImageHelper.getImage(
                                        _singerSong.artist.picUrl +
                                            "?param=400y400",
                                        height: 230),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.3)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(children: [
                      buildSongs(model),
                      buildAlbum(),
                      Container(),
                    ]),
                  ),
                );
              },
            ),
    );
  }

  Widget buildAlbum() {
    return Builder(
      builder: (context) {
        return _singerAlbum == null
            ? LoadingPage()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(10.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.only(
                                left: 5, right: 0, top: 0, bottom: 0),
                            title: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 50,
                                  height: 50,
                                  child: ImageHelper.getImage(
                                      _singerAlbum.hotAlbums[index].picUrl),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        '${_singerAlbum.hotAlbums[index].name}',
                                        style: TextStyle(fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      width: ScreenUtil().screenWidth - 100,
                                    ),
                                    Text(
                                      '共${_singerAlbum.hotAlbums[index].size}首',
                                      style: smallGrayTextStyle,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              NavigatorUtil.goSheetDetailPage(
                                  context, _singerAlbum.hotAlbums[index].id,
                                  type: 'album');
                            },
                          );
                        },
                        childCount: _singerAlbum.hotAlbums.length,
                      ),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget buildSongs(PlaySongsModel model) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var r = _singerSong.hotSongs[index];
                  return Column(
                    children: [
                      WidgetMusicListItem(
                        SongBeanEntity(
                          picUrl: r.al.picUrl,
                          mv: r.mv,
                          id: '${r.id}',
                          name: r.name,
                          like: Application.loveList.indexOf('${r.id}') != -1
                              ? true
                              : false,
                          singer:
                              '${r.ar.map((a) => a.name).toList().join('/')}',
                        ),
                        onTap: () {
                          playSongs(model, index);
                        },
                        index: index,
                        model: model,
                      ),
                    ],
                  );
                },
                childCount: _singerSong.hotSongs.length,
              ),
            ),
          ],
        );
      },
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      _singerSong.hotSongs,
      index: index,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayBody()),
    );
  }

  Future<SingerSong> _getSingerDetails(id) async {
    var answer = await artists({'id': id}, await SelfUtil.getCookie());
    if (answer.status == 200) {
      var body = answer.body;
      var singerSong = SingerSong.fromJson(body);
      if (singerSong.code == 200) {
        singerSong.hotSongs.forEach((SheetDetailsPlaylistTrack element) {
          element.like = Application.loveList.indexOf('${element.id}') != -1;
        });
        return singerSong;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<SingerAlbum> _getSingerAlbum(id) async {
    var answer = await artist_album({'id': id}, await SelfUtil.getCookie());
    if (answer.status == 200) {
      var body = answer.body;
      var singerAlbum = SingerAlbum.fromJson(body);
      if (singerAlbum.code == 200) {
        return singerAlbum;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
