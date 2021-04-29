import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/widget/v_empty_view.dart';

import 'common_text_style.dart';
import 'h_empty_view.dart';

enum ConferenceItem { AddMember, LockConference, ModifyLayout, TurnoffAll }

class WidgetMusicListItemSheet extends StatelessWidget {
  final SongBeanEntity _data;
  final VoidCallback onTap;
  final int index;
  final PlaySongsModel _model;

  WidgetMusicListItemSheet(this._data, this._model, {this.onTap, this.index});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'delete',
          icon: Icons.delete,
          color: kBackgroundColor,
          onTap: () {
            _model.delSong(index - 1);
            Fluttertoast.showToast(msg: '已经移除');
          },
        )
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: _model.curIndex == index - 1 ? Colors.blue[50] : null),
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setWidth(60),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              HEmptyView(10),
              _data.id == null
                  ? Container()
                  : Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(60),
                      height: ScreenUtil().setWidth(50),
                      child: Text(
                        '$index',
                        style: mGrayTextStyle,
                      ),
                    ),
              HEmptyView(10),
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
                    VEmptyView(10),
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
                          _model.pausePlay();
                          NavigatorUtil.goPlayVideoPage(context, id: _data.mv);
                        },
                        color: Colors.grey,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
