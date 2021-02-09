import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/constant/paly_state.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/lyric/lyric_page.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/widget_music_list_item_sheet.dart';
import 'package:neatease_app/widget/widget_song_progress.dart';
import 'package:provider/provider.dart';

class PlayBody extends StatefulWidget {
  PlayBody({Key key, this.songList, this.index}) : super(key: key);
  final List<SongBeanEntity> songList;
  final int index;

  @override
  _PlayBodyState createState() => _PlayBodyState();
}

class _PlayBodyState extends State<PlayBody> with TickerProviderStateMixin {
  _PlayBodyState();

  AnimationController _controller; // 封面旋转控制器
  AnimationController _stylusController; //唱针控制器
  Animation<double> _stylusAnimation;
  int switchIndex = 0; //用于切换歌词

  //当前播放进度
  //定义一个list存取歌单
  SongBeanEntity stemp;
  int index = 0;

  PlayStateType stateType = PlayStateType.Stop;
  SheetDetailsPlaylistTrack sheet;

  @override
  void initState() {
    super.initState();
    //专辑封面旋转
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    //磁吸旋转
    _stylusController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    //磁吸旋转角度
    _stylusAnimation =
        Tween<double>(begin: -0.03, end: -0.10).animate(_stylusController);
    _controller.addStatusListener((status) {
      // 转完一圈之后继续
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void playSongs(PlaySongsModel model, int index) {
    model.curIndex = index;
    model.play();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(builder: (context, model, child) {
      var curSong = model.curSong;
      if (model.curState == AudioPlayerState.PLAYING) {
        // 如果当前状态是在播放当中，则唱片一直旋转，
        // 并且唱针是移除状态
        _controller.forward();
        _stylusController.reverse();
      } else {
        _controller.stop();
        _stylusController.forward();
      }
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text('${curSong.name}'),
              Text(
                '${curSong.singer}',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.share),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      if (switchIndex == 0) {
                        switchIndex = 1;
                      } else {
                        switchIndex = 0;
                      }
                    });
                  },
                  child: IndexedStack(
                    index: switchIndex,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(150)),
                              child: RotationTransition(
                                turns: _controller,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/player_disc.png',
                                      width: ScreenUtil().setWidth(300),
                                    ),
                                    ImageHelper.getImage(
                                        '${curSong.picUrl}?param=200y200',
                                        height: 200,
                                        isRound: true),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: RotationTransition(
                              turns: _stylusAnimation,
                              alignment: Alignment(
                                  -1 +
                                      (ScreenUtil().setWidth(45 * 2) /
                                          (ScreenUtil().setWidth(293))),
                                  -1 +
                                      (ScreenUtil().setWidth(45 * 2) /
                                          (ScreenUtil().screenWidth))),
                              child: Image.asset(
                                'assets/images/player_needle.png',
                                width: ScreenUtil().setWidth(205),
                                height: ScreenUtil().setWidth(352.8),
                              ),
                            ),
                            alignment: Alignment(0.25, -1),
                          ),
                        ],
                      ),
                      LyricPage(model),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(300),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              color: curSong.like ? Colors.red : Colors.grey,
                              icon: Icon(curSong.like
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              onPressed: () {
                                //应该继续修正用户播放列表的数据，待修复
                                //如果当前不喜欢应该传喜欢收藏
                                NetUtils()
                                    .subSongs('${curSong.id}', !curSong.like);
                                curSong.like = !curSong.like;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.save_alt),
                              onPressed: () {},
                            ),
                            //评论
                            IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.chat),
                              //评论数量 后续在写：这里提前获取有点耗时 需要调优：初步思路播放时预加载
                              onPressed: () {
                                NetUtils().getSongTalkCommants(
                                  curSong.id,
                                  params: {'offset': 1},
                                ).then((data) {
                                  NavigatorUtil.goCommentPage(context,
                                      data: CommentHead(
                                        curSong.picUrl,
                                        curSong.name,
                                        curSong.singer,
                                        data.total,
                                        '${curSong.id}',
                                        0,
                                      ));
                                });
                              },
                            ),
                            IconButton(
                              color: Colors.grey,
                              icon: Icon(Icons.more_vert),
                              onPressed: () {},
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                        padding: EdgeInsets.fromLTRB(20, 8, 10, 8),
                      ),
                      //歌曲进度条
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30)),
                        child: SongProgressWidget(model),
                      ),
                      //模式、下一首、上一首、播放/暂停按钮、歌单
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.loop),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: model.prePlay,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            width: ScreenUtil().setWidth(55),
                            height: ScreenUtil().setWidth(55),
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(55))),
                            child: IconButton(
                              icon: Icon(
                                  model.curState != AudioPlayerState.PAUSED
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline),
                              onPressed: model.togglePlay,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: model.nextPlay,
                          ),
                          //歌单
                          Builder(builder: (context) {
                            return new IconButton(
                              icon: Icon(Icons.list),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                flex: 2,
              )
            ],
          ),
        ),
        //侧边弹出歌单
        drawer: Drawer(
          elevation: 0,
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 200.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        '当前播放列表',
                        style: mCommonTextStyle,
                      ),
                      background: Image.network(
                        '${curSong.picUrl}?param=400y400',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Consumer<PlaySongsModel>(
                    builder: (context, model, child) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var d = model.allSongs[index];
                            return Column(
                              children: [
                                WidgetMusicListItemSheet(
                                  SongBeanEntity(
                                    picUrl: d.picUrl,
                                    mv: d.mv,
                                    id: '${d.id}',
                                    name: d.name,
                                    like: d.like,
                                    singer: d.singer,
                                  ),
                                  onTap: () {
                                    playSongs(model, index);
                                  },
                                  index: index + 1,
                                ),
                                Divider(
                                  height: 1.0,
                                  indent: 0.0,
                                  color: Colors.grey,
                                ),
                              ],
                            );
                          },
                          childCount: model.allSongs.length,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
