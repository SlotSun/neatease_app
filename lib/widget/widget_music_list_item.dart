import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/dialog/common_botton_sheet.dart';
import 'package:neatease_app/screen/dialog/show_playlist_dialog.dart';
import 'package:neatease_app/screen/singer/singer_detail/singer_detail.dart';
import 'package:neatease_app/util/navigator_util.dart';

import 'common_text_style.dart';

class WidgetMusicListItem extends StatelessWidget {
  final SheetDetailsPlaylistTrack _data;
  final VoidCallback onTap;
  final int index;
  final PlaySongsModel model;

  WidgetMusicListItem(this._data, {this.onTap, this.index, this.model});

  void buildList(list, PlaySongsModel model, context) {
    list.add(
      BottomSheetMenu(
          //当前模式如果为fm就禁止下一首播放
          ban: Application.fm,
          iconData: Icons.play_circle_outline,
          title: '下一首播放',
          function: () {
            Fluttertoast.showToast(msg: '添加成功');
            model.allSongs
                .insert(model.allSongs.indexOf(model.curSong) + 1, _data);
            Navigator.pop(context);
          }),
    );
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
          title: '歌手: ${_data.ar.map((a) => a.name).toList().join('/')}',
          function: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingerDetail(_data.ar.first.id),
              ),
            );
          }),
    );
    list.add(
      BottomSheetMenu(
          iconData: Icons.album,
          title: '专辑:${_data.al.name}',
          function: () {
            Navigator.pop(context);
            NavigatorUtil.goSheetDetailPage(context, _data.al.id,
                type: 'album');
          }),
    );
  }

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
                        '${_data.ar.map((a) => a.name).toList().join('/')}',
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
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          isDismissible: true,
                          isScrollControlled: false,
                          context: context,
                          builder: (BuildContext context) {
                            List<BottomSheetMenu> list = [];
                            buildList(list, model, context);
                            return CommonBottomSheet(
                              list: list,
                              onItemClickListener: (index) async {
                                Navigator.pop(context);
                              },
                            );
                          });
                    },
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
