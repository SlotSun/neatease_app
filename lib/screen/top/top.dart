import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/song_info.dart';
import 'package:neatease_app/entity/top_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_blackWidget.dart';
import 'package:neatease_app/widget/widget_blankspace.dart';

class Top extends StatefulWidget {
  @override
  _TopState createState() => _TopState();
}

class _TopState extends State<Top> with AutomaticKeepAliveClientMixin {
  List<SongInfo> BS_Top = [];
  List<SongInfo> New_Top = [];
  List<SongInfo> YC_Top = [];
  List<SongInfo> Hot_Top = [];
  List<TopInfo> lTopInfo = [];

  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lTopInfo
      ..add(TopInfo(10520166, '电音榜', dy_top))
      ..add(TopInfo(180106, 'UK榜', uk_top))
      ..add(TopInfo(60131, '日本榜', rb_top))
      ..add(TopInfo(60198, 'Billl榜', billl_top))
      ..add(TopInfo(21845217, 'KTV榜', krv_top))
      ..add(TopInfo(11641012, 'Itunes榜', itunes_top));
    _request();
  }

  _request() async {
    Future.wait([
      NetUtils().getTopData('19723756'),
      NetUtils().getTopData('3779629'),
      NetUtils().getTopData('2884035'),
      NetUtils().getTopData('3778678'),
    ]).then((value) async {
      BS_Top = await _changeType(value[0]);
      New_Top = await _changeType(value[1]);
      YC_Top = await _changeType(value[2]);
      Hot_Top = await _changeType(value[3]);
    }).then((value) {
      setState(() {
        isloading = false;
      });
    });
  }

  Future<List<SongInfo>> _changeType(TopEntity topEntity) async {
    var songToSongInfo =
        await SelfUtil.songToSongInfo(topEntity.playlist.tracks);
    return songToSongInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? LoadingPage()
          : blackWidget(
              null,
              Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: EasyRefresh(
                  header: MaterialHeader(
                      valueColor: AlwaysStoppedAnimation(
                          Color.fromRGBO(0, 153, 37, .6))),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          dense: true,
                          contentPadding:
                              EdgeInsets.only(left: 5, top: 0, bottom: 0),
                          title: Text(
                            '云音乐官方榜',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _topItem(bs_top, BS_Top, 19723756),
                        _topItem(new_top, New_Top, 3779629),
                        _topItem(yc_top, YC_Top, 2884035),
                        _topItem(hot_top, Hot_Top, 3778678),
                        _globalItem(),
                        BlankSpace(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _topItem(img, List<SongInfo> songs, id) {
    return InkWell(
      onTap: () {
        NavigatorUtil.goSheetDetailPage(context, id);
      },
      child: Container(
        width: ScreenUtil().screenWidth - 10,
        //暂时没有想出怎么用row做到左不滑动 右滑动
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: ScreenUtil().setWidth(100),
              child: ImageHelper.getImage(img),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(108)),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${index + 1}. ${songs[index].songName}(${songs[index].artist})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, wordSpacing: 1.2),
                    ),
                  );
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

//5: "180106", //UK排行榜周榜
//6: "60198", //美国Billboard周榜
//7: "21845217", //KTV嗨榜
//8: "11641012", //iTunes榜
//9: "120001", //Hit FM Top榜
//10: "60131", //日本Oricon周榜
//11: "3733003", //韩国Melon排行榜周榜
//12: "60255", //韩国Mnet排行榜周榜
//13: "46772709", //韩国Melon原声周榜
//14: "112504", //中国TOP排行榜(港台榜)
//15: "64016", //中国TOP排行榜(内地榜)
//16: "10169002", //香港电台中文歌曲龙虎榜
//17: "4395559", //华语金曲榜
//18: "1899724", //中国嘻哈榜
//19: "27135204", //法国 NRJ EuroHot 30周榜
//20: "112463", //台湾Hito排行榜
//21: "3812895", //Beatport全球电子舞曲榜
//22: "71385702", //云音乐ACG音乐榜
//23: "991319590" //云音乐嘻哈榜
  Widget _globalItem() {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: lTopInfo.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              NavigatorUtil.goSheetDetailPage(context, lTopInfo[index].id);
            },
            child: Container(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().screenWidth / 3,
                    child: ImageHelper.getImage(
                      lTopInfo[index].picUrl,
                      height: ScreenUtil().screenWidth / 3,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(6))),
                    padding: EdgeInsets.only(top: 5, left: 5),
                    child: Text(
                      lTopInfo[index].name,
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class TopInfo {
  int id;
  String name;
  String picUrl;

  TopInfo(this.id, this.name, this.picUrl);
}
