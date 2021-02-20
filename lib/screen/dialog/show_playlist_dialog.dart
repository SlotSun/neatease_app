import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/screen/dialog/create_playlist.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:provider/provider.dart';

class ShowPlayListDialog extends StatefulWidget {
  final SheetDetailsPlaylistTrack track;

  ShowPlayListDialog({Key key, this.track}) : super(key: key);

  @override
  _ShowPlayListDialogState createState() => _ShowPlayListDialogState();
}

class _ShowPlayListDialogState extends State<ShowPlayListDialog> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListModel>(
      builder: (_, model, __) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              elevation: 0,
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              width: ScreenUtil().screenWidth * 0.8,
              height: ScreenUtil().screenHeight * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: EasyRefresh(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '收藏到歌单',
                              style: commonGray18TextStyle,
                            ),
                            Container(
                              width: 80,
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                //创建之后应该刷新当前界面添加新的歌单:应该抽离成状态监听
                                showDialog(
                                  context: context,
                                  child: CreatePlayListDialog(),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.minimize_sharp),
                              onPressed: () {
                                //创建之后应该刷新当前界面添加新的歌单:应该抽离成状态监听
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, int index) {
                            return _orderItem(
                                model, model.selfCreatePlayList[index], index);
                          },
                          childCount: model.selfCreatePlayList.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _orderItem(
      PlayListModel model, SheetDetailsPlaylist orderPlaylist, int index) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      leading: ImageHelper.getImage(
          orderPlaylist.coverImgUrl + "?param=150y150",
          height: ScreenUtil().setHeight(42),
          isRound: true),
      title: Text(
        orderPlaylist.name,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: Text('${orderPlaylist.trackCount} 首单曲',
          style: TextStyle(fontSize: 12)),
      onTap: () {
        model.addPlayListTrack(widget.track, index);
        Navigator.of(context).pop();
      },
    );
  }
}
