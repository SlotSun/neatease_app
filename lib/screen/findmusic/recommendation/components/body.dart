import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neatease_app/entity/banner_entity.dart';
import 'package:neatease_app/entity/new_song_entity.dart';
import 'package:neatease_app/entity/personal_entity.dart';
import 'package:neatease_app/entity/personnal_mv.dart';
import 'package:neatease_app/screen/components/list_title.dart';
import 'package:neatease_app/screen/components/r_com_songs_card.dart';
import 'package:neatease_app/screen/findmusic/recommendation/components/banner.dart';
import 'package:neatease_app/screen/findmusic/recommendation/new_song/new_song.dart';
import 'package:neatease_app/screen/findmusic/recommendation/personnal_mv/personal_mv.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';

import 'fm_everyCom_hot_button.dart';

class RecBody extends StatefulWidget {
  final Size size;

  RecBody({@required this.size});

  @override
  _RecBodyState createState() => _RecBodyState();
}

//添加AutomatickeepAliveClientMixin 切换界面保存页面状态
class _RecBodyState extends State<RecBody> with AutomaticKeepAliveClientMixin {
  _RecBodyState();

  Size size;
  List<Widget> listW;
  List<Widget> listCardSheet = [];
  List<Widget> listCardNewSong = [];
  List<PersonalResult> sheets = [];
  List<BannerBanner> banners = [];
  List<NewSongResult> newSong = [];
  List<PersonalMVResult> pMV = [];
  bool circle = true;

  // EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    // TODO: implement initState
    size = widget.size;

    super.initState();
    _onRefresh();
  }

  //刷新 Action
  Future _onRefresh() async {
    var wait = await Future.wait([
      NetUtils().getBanner(),
      NetUtils().getRecommendResource(),
      NetUtils().getNewSongs(),
      NetUtils().getPersonalMv(),
    ]);
    wait.forEach((data) {
      if (data is BannerEntity) if (data != null) {
        banners = data.banners;
      }
      if (data is PersonalEntity) if (data != null) {
        sheets = data.result;
        listCardSheet = buildSheetList(sheets);
      }
      if (data is NewSongEntity) {
        if (data != null) {
          newSong = data.result;
        }
      }
      if (data is PersonalMVEntity) {
        if (data != null) {
          pMV = data.result;
        }
      }
    });
    setState(() {});
  }

  Function press = () {};

  //创建歌单sheets Action
  List<Widget> buildSheetList(List<PersonalResult> sheets) {
    List<Widget> list = [];
    sheets.forEach((sheet) {
      list.add(RComSongsListCard(
        sheet: sheet,
        size: size,
        press: () {
          //跳转页面将circle关闭：返回界面应该circle打开
          circle = false;
          setState(() {});
          NavigatorUtil.goSheetDetailPage(context, sheet.id);
        },
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: EasyRefresh.custom(
        onRefresh: _onRefresh,
        slivers: [
          SliverToBoxAdapter(
            child: buildBanner(banners, circle),
          ),
          SliverToBoxAdapter(
            child: FMAndEveryComAndHotButton(size: size),
          ),
          SliverToBoxAdapter(
            child: NeteaseListTitle(
              title: '推荐歌单',
              press: () {},
            ),
          ),
          SliverToBoxAdapter(
            child: GridView.builder(
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listCardSheet.length,
              itemBuilder: (BuildContext context, int index) {
                return listCardSheet[index];
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.45,
                  crossAxisSpacing: 23.0,
                  mainAxisSpacing: 0.0),
            ),
          ),
          SliverToBoxAdapter(
            child: NeteaseListTitle(
              title: '最新音乐',
            ),
          ),
          SliverToBoxAdapter(
            child: widgetNewSong(newSong, context),
          ),
          SliverToBoxAdapter(
            child: NeteaseListTitle(
              title: '推荐mv',
            ),
          ),
          SliverToBoxAdapter(
            child: widgetPersonalMv(pMV, context),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
