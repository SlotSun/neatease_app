import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:neatease_app/entity/highquality_entity.dart';
import 'package:neatease_app/screen/sheet/sheet_detail.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_load_footer.dart';

// ignore: non_constant_identifier_names
class SheetSqDetailsPage extends StatefulWidget {
  final type;

  SheetSqDetailsPage({Key key, this.type}) : super(key: key);

  @override
  _SheetSqDetailsPageState createState() => _SheetSqDetailsPageState();
}

class _SheetSqDetailsPageState extends State<SheetSqDetailsPage> with AutomaticKeepAliveClientMixin {
  _SheetSqDetailsPageState();

  FocusNode _blankNode = FocusNode();
  EasyRefreshController _controller;

  //坑啊,默认是从第一页开始，苦苦debug了俩小时
  int page = 1;
  List<HighqualityPlaylist> highQualityPlayList = [];
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      _request().then((value) => isloading = false);
    });
  }

  Future<bool> _request() async {
    //根据类型分页获取 歌单
    NetUtils().getSheet(widget.type, page).then((data) {
      if (data != null) highQualityPlayList.addAll(data.playlists);
      if (mounted) {
        setState(() {});
      }
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? LoadingPage()
        : Scaffold(
            body: Container(
              child: EasyRefresh(
                footer: LoadFooter(),
                controller: _controller,
                onLoad: () async {
                  page++;
                  _request();
                  _controller.finishLoad(
                      noMore: highQualityPlayList.length >= 1000);
                },
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30),
                    right: ScreenUtil().setWidth(30),
                    bottom: ScreenUtil().setWidth(50),
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _playlistCard(highQualityPlayList[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(10)),
                      height: ScreenUtil().setWidth(1.5),
                      color: Color(0xfff5f5f5),
                    );
                  },
                  itemCount: highQualityPlayList.length,
                ),
              ),
            ),
          );
  }

  Widget _playlistCard(HighqualityPlaylist playlist) {
    return ListTile(
      dense: true,
      contentPadding:
          EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
      leading: ImageHelper.getImage('${playlist.coverImgUrl}?param=100y100',
          height: 42, isRound: true),
      subtitle: Text(
        '${playlist.trackCount} 首歌曲  Play: ${playlist.playCount > 10000 ? '${(playlist.playCount / 10000).toStringAsFixed(1)}w' : playlist.playCount}',
        style: TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      title: Text(
        playlist.name,
        style: TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        NavigatorUtil.goSheetDetailPage(context, playlist.id);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive => true;
}
