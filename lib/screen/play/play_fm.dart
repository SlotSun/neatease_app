import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/constant/paly_state.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/dialog/common_botton_sheet.dart';
import 'package:neatease_app/screen/dialog/show_playlist_dialog.dart';
import 'package:neatease_app/screen/lyric/lyric_page.dart';
import 'package:neatease_app/screen/singer/singer_detail/singer_detail.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/v_empty_view.dart';
import 'package:neatease_app/widget/widget_song_progress.dart';
import 'package:provider/provider.dart';

class PlayFm extends StatefulWidget {
  @override
  _PlayFmState createState() => _PlayFmState();
}

class _PlayFmState extends State<PlayFm> with TickerProviderStateMixin {
  _PlayFmState();

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
    Application.fm = true;
    //专辑封面旋转
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    //磁吸旋转
    _stylusController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    //磁吸旋转角度
    _stylusAnimation =
        Tween<double>(begin: 0, end: -0.12).animate(_stylusController);
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
    _controller.dispose();
    _stylusController.dispose();
    super.dispose();
  }

  void playSongs(PlaySongsModel model, int index) {
    model.curIndex = index;
    model.play();
    Navigator.pop(context);
  }

  void buildList(list, PlaySongsModel model) {
    list.add(
      BottomSheetMenu(
          iconData: Icons.collections_bookmark_outlined,
          title: '收藏到歌单',
          function: () {
            Navigator.pop(context);
            showDialog(
                context: context,
                child: ShowPlayListDialog(track: model.curSong));
          }),
    );
    list.add(
      BottomSheetMenu(
          iconData: Icons.people,
          title: '歌手:${model.curSong.ar.map((a) => a.name).toList().join('/')}',
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingerDetail(model.curSong.ar.first.id),
              ),
            );
          }),
    );
    list.add(
      BottomSheetMenu(
          iconData: Icons.album,
          title: '专辑:${model.curSong.al.name}',
          function: () {
            NavigatorUtil.goSheetDetailPage(context, model.curSong.al.id,
                type: 'album');
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(builder: (context, model, child) {
      var curSong = model.curSong;
      if (curSong.like == null) {
        curSong.like = Application.loveList.indexOf('${curSong.id}') != -1;
      }
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text('${curSong.name}'),
              Text(
                curSong.ar != null
                    ? '${curSong.ar.map((a) => a.name).toList().join('/')}'
                    : '未知歌手',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.grey,
              icon: Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: true,
                    isScrollControlled: false,
                    context: context,
                    builder: (BuildContext context) {
                      List<BottomSheetMenu> list = [];
                      buildList(list, model);
                      return CommonBottomSheet(
                        list: list,
                        onItemClickListener: (index) async {
                          Navigator.pop(context);
                        },
                      );
                    });
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Expanded(
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
                                  top: ScreenUtil().setWidth(10)),
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
                                        curSong.al != null
                                            ? '${curSong.al.picUrl}?param=200y200'
                                            : vilUrl,
                                        height: ScreenUtil().setWidth(200),
                                        isRound: true),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            child: RotationTransition(
                              turns: _stylusAnimation,
                              alignment: Alignment(0, -1),
                              child: Image.asset(
                                'assets/images/player_needle.png',
                              ),
                            ),
                            //位置
                            alignment: Alignment(
                                (ScreenUtil().setWidth(45 * 4) /
                                    ScreenUtil().screenWidth),
                                -1 -
                                    ScreenUtil().setWidth(45 * 4) /
                                        ScreenUtil().screenHeight),
                          ),
                        ],
                      ),
                      LyricPage(model),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Column(
                    children: [
                      //歌曲进度条
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(30)),
                        child: SongProgressWidget(model),
                      ),
                      //模式、下一首、上一首、播放/暂停按钮、歌单
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              NetUtils().fmTrash(curSong.id);
                              Fluttertoast.showToast(msg: '已删除,不会再推荐');
                              model.nextPlay();
                            },
                          ),
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
                                      curSong.al.picUrl,
                                      curSong.name,
                                      '${curSong.ar.map((a) => a.name).toList().join('/')}',
                                      data.total,
                                      '${curSong.id}',
                                      0,
                                    ));
                              });
                            },
                          ),
                        ],
                      ),
                      VEmptyView(20),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
