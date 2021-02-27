import 'dart:async';
import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/entity/today_song_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/widget_music_list_item.dart';
import 'package:neatease_app/widget/widget_play.dart';
import 'package:neatease_app/widget/widget_play_list_app_bar.dart';
import 'package:neatease_app/widget/widget_sliver_future_builder.dart';
import 'package:provider/provider.dart';

class DailySongsPage extends StatefulWidget {
  @override
  _DailySongsPageState createState() => _DailySongsPageState();
}

class _DailySongsPageState extends State<DailySongsPage> {
  double _expandedHeight = ScreenUtil().setWidth(340);
  int _count;
  TodaySongEntity data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(80)),
            child: CustomScrollView(
              slivers: <Widget>[
                PlayListAppBarWidget(
                  backgroundImg: 'assets/images/bg_daily.png',
                  count: _count,
                  playOnTap: (model) {
                    playSongs(model, 0);
                  },
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      '${DateUtil.formatDate(DateTime.now(), format: 'dd')} ',
                                  style: TextStyle(fontSize: 30)),
                              TextSpan(
                                  text:
                                      '/ ${DateUtil.formatDate(DateTime.now(), format: 'MM')}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                        child: Text(
                          '根据你的音乐口味，为你推荐好音乐。',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                  expandedHeight: _expandedHeight,
                  title: '每日推荐',
                ),
                CustomSliverFutureBuilder<TodaySongEntity>(
                  futureFunc: NetUtils().getTodaySongs,
                  builder: (context, data) {
                    setCount(data.recommend.length);
                    return Consumer<PlaySongsModel>(
                      builder: (context, model, child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              this.data = data;
                              var d = data.recommend[index];
                              return WidgetMusicListItem(
                                d,
                                onTap: () {
                                  playSongs(model, index);
                                },
                                index: index,
                                model: model,
                              );
                            },
                            childCount: data.recommend.length,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          PlayWidget(),
        ],
      ),
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      data.recommend,
      index: index,
    );
    NavigatorUtil.goPlaySongsPage(context);
  }

  void setCount(int count) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _count = count;
        });
      }
    });
  }
}
