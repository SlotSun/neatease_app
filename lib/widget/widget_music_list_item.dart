import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/util/navigator_util.dart';

import 'common_text_style.dart';

class WidgetMusicListItem extends StatelessWidget {
  final SongBeanEntity _data;
  final VoidCallback onTap;
  final int index;
  final PlaySongsModel model;

  WidgetMusicListItem(this._data, {this.onTap, this.index, this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().setWidth(52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //每日推荐
                _data.id == null
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(47),
                        child: Text(
                          '${index + 1}',
                          style: mGrayTextStyle,
                        ),
                      ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _data.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: commonTextStyle,
                      ),
                      Text(
                        _data.singer,
                        style: smallGrayTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _data.mv == 0
                      ? Container()
                      : IconButton(
                          icon: Icon(Icons.play_circle_outline),
                          onPressed: () {
                            model.pausePlay();
                            NavigatorUtil.goPlayVideoPage(context,
                                id: _data.mv);
                          },
                          color: Colors.grey,
                        ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      ),
    );
  }
}
