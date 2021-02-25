import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:provider/provider.dart';

import 'common_text_style.dart';
import 'h_empty_view.dart';

/// 所有页面下面的播放条
class PlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Consumer<PlaySongsModel>(builder: (context, model, child) {
        Widget child;

        if (model.allSongs.isEmpty)
          child = Text('暂无正在播放的歌曲');
        else {
          SheetDetailsPlaylistTrack curSong = model.curSong;
          child = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (Application.fm == true) {
                NavigatorUtil.goFmPage(context);
              } else {
                NavigatorUtil.goPlaySongsPage(context);
              }
            },
            child: Row(
              children: <Widget>[
                ImageHelper.getImage(
                    curSong.ar != null ? curSong.al.picUrl : vilUrl,
                    height: 50),
                HEmptyView(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        curSong.name,
                        style: commonTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        curSong.ar != null
                            ? '${curSong.ar.map((a) => a.name).toList().join('/')}'
                            : '未知歌手',
                        style: common13TextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (model.curState == null) {
                      model.play();
                    } else {
                      model.togglePlay();
                    }
                  },
                  child: Icon(
                    model.curState == AudioPlayerState.PLAYING
                        ? Icons.pause_circle_outline_sharp
                        : Icons.play_circle_outline_sharp,
                    size: ScreenUtil().setWidth(40),
                  ),
                ),
                HEmptyView(15),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/list.png',
                    width: ScreenUtil().setWidth(30),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setWidth(70),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200])),
              color: Colors.white),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(5)),
          child: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().setWidth(80),
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
            alignment: Alignment.center,
            child: child,
          ),
        );
      }),
    );
  }
}
