import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/widget/v_empty_view.dart';

import 'common_text_style.dart';
import 'h_empty_view.dart';

class WidgetMusicListItem extends StatelessWidget {
  final SongBeanEntity _data;
  final VoidCallback onTap;
  final int index;

  WidgetMusicListItem(this._data, {this.onTap, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().setWidth(52),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _data.id == null && _data.picUrl == null
                    ? Container()
                    : HEmptyView(15),
                //每日推荐
                _data.id == null
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(47),
                        child: Text(
                          '$index',
                          style: mGrayTextStyle,
                        ),
                      ),
                _data.id == null && _data.picUrl == null
                    ? Container()
                    : HEmptyView(10),
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
                          onPressed: () {},
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
