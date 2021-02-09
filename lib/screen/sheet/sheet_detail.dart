import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/h_empty_view.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/v_empty_view.dart';
import 'package:neatease_app/widget/widget_footer_tab.dart';
import 'package:neatease_app/widget/widget_music_list_item.dart';
import 'package:neatease_app/widget/widget_play.dart';
import 'package:neatease_app/widget/widget_play_list_app_bar.dart';
import 'package:provider/provider.dart';

import '../findmusic/components/play_list_desc_dialog.dart';

/*
  获取歌单详情：调用APi/playlist/detail?id=24381616 
  必选参数 : id : 歌单 id
  可选参数 : s : 歌单最近的 s 个收藏者,默认为8
  接口地址 : /playlist/detail?id=24381616
  设置一个歌单类接收返回的数据
*/
class SheetDetail extends StatefulWidget {
  SheetDetail(this.id);

  final id;

  @override
  _SheetDetailState createState() => _SheetDetailState();
}

class _SheetDetailState extends State<SheetDetail> {
  _SheetDetailState();

  SheetDetailsPlaylist sheet;

  //应该在界面加载之前就获取这个数据，歌单不刷新
  List<Widget> songsListCardList = [];
  List<SongBeanEntity> songList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _request().then((value) => isLoading = false);
  }

  Future<bool> _request() async {
    NetUtils().getPlayListDetails(widget.id).then((value) {
      sheet = value.playlist;
      setState(() {});
    });
  }

  Widget _buildMaterialDialogTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  /// 构建歌单简介
  Widget buildDescription() {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (BuildContext buildContext, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return PlayListDescDialog(sheet);
          },
          barrierDismissible: true,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: const Duration(milliseconds: 150),
          transitionBuilder: _buildMaterialDialogTransitions,
        );
      },
      child: sheet != null && sheet.description != null
          ? Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    sheet.description,
                    style: smallWhite70TextStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
              ],
            )
          : Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SingleChildScrollView一次加载所有卡顿
      body: isLoading
          ? LoadingPage()
          : Stack(
              children: <Widget>[
                // buildTop(),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(80),
                  ),
                  child: CustomScrollView(
                    slivers: <Widget>[
                      PlayListAppBarWidget(
                        sigma: 20,
                        playOnTap: (model) {
                          playSongs(model, 0);
                        },
                        //safeArea不被异形屏覆盖
                        content: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ScreenUtil().setWidth(35),
                              right: ScreenUtil().setWidth(35),
                              top: ScreenUtil().setWidth(120),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    HEmptyView(20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            sheet.name,
                                            softWrap: true,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: mWhiteBoldTextStyle,
                                          ),
                                          VEmptyView(10),
                                          Row(
                                            children: <Widget>[
                                              sheet == null
                                                  ? Container()
                                                  : ImageHelper.getImage(
                                                      '${sheet.creator.avatarUrl}?param=50y50'),
                                              HEmptyView(5),
                                              Expanded(
                                                child: sheet == null
                                                    ? Container()
                                                    : Text(
                                                        sheet.creator.nickname,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            commonWhite70TextStyle,
                                                      ),
                                              ),
                                              sheet == null
                                                  ? Container()
                                                  : Icon(
                                                      Icons
                                                          .keyboard_arrow_right,
                                                      color: Colors.white70,
                                                    ),
                                            ],
                                          ),
                                          VEmptyView(10),
                                          //详情
                                          buildDescription(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                VEmptyView(15),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(12)),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      FooterTabWidget(
                                          'assets/images/icon_comment.png',
                                          '${sheet == null ? "评论" : sheet.commentCount}',
                                          () {
                                        NavigatorUtil.goCommentPage(context,
                                            data: CommentHead(
                                              sheet.coverImgUrl,
                                              sheet.name,
                                              sheet.creator.nickname,
                                              sheet.commentCount,
                                              '${sheet.id}',
                                              2,
                                            ));
                                      }),
                                      FooterTabWidget(
                                          'assets/images/icon_share.png',
                                          '${sheet == null ? "分享" : sheet.shareCount}',
                                          () {}),
                                      FooterTabWidget(
                                          'assets/images/icon_download.png',
                                          '下载',
                                          () {}),
                                      isSubscribed(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        expandedHeight: ScreenUtil().setHeight(400),
                        backgroundImg: sheet.coverImgUrl,
                        title: '歌单',
                        count: sheet == null ? null : sheet.trackCount,
                      ),
                      Consumer<PlaySongsModel>(
                        builder: (context, model, child) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var d = sheet.tracks[index];
                                return WidgetMusicListItem(
                                  SongBeanEntity(
                                    picUrl: d.al.picUrl,
                                    mv: d.mv,
                                    like: Application.loveList
                                                .indexOf('${d.id}') !=
                                            -1
                                        ? true
                                        : false,
                                    id: '${d.id}',
                                    name: d.name,
                                    singer: d.ar.first.name,
                                  ),
                                  onTap: () {
                                    playSongs(model, index);
                                  },
                                  index: index + 1,
                                );
                              },
                              childCount: sheet.tracks.length,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //下部的播放器
                PlayWidget(),
              ],
            ),
    );
  }

  ///是否订阅
  Widget isSubscribed() {
    return Consumer<PlayListModel>(
      builder: (context, model, child) {
        return Expanded(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (sheet.subscribed) {
                    model.delPlayList(sheet);
                  } else {
                    model.addPlayList(sheet);
                    NetUtils().subPlaylist(!sheet.subscribed, sheet.id);
                  }
                  sheet.subscribed = !sheet.subscribed;
                  setState(() {});
                },
                child: Icon(
                  Icons.favorite,
                  color: sheet.subscribed ? Colors.red : Colors.grey,
                  size: 40,
                ),
              ),
              VEmptyView(8),
              Text(
                '收藏',
                style: common14White70TextStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      sheet.tracks
          .map((r) => SongBeanEntity(
                mv: r.mv,
                id: '${r.id}',
                name: r.name,
                picUrl: r.al.picUrl,
                singer: '${r.ar.map((a) => a.name).toList().join('/')}',
                like: Application.loveList.indexOf('${r.id}') != -1
                    ? true
                    : false,
              ))
          .toList(),
      index: index,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayBody()),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
