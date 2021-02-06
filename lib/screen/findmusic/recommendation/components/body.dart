import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neatease_app/entity/banner_entity.dart';
import 'package:neatease_app/entity/personal_entity.dart';
import 'package:neatease_app/screen/components/list_title.dart';
import 'package:neatease_app/screen/components/r_com_songs_card.dart';
import 'package:neatease_app/screen/findmusic/recommendation/components/banner.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/widget_play.dart';

import 'fm_everyCom_hot_button.dart';
import 'r_video_list_cards_list.dart';

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
  List<Widget> listCard = [];
  List<PersonalResult> sheet = [];
  List<BannerBanner> banners = [];

  // EasyRefreshController _controller = EasyRefreshController();
  @override
  void initState() {
    // TODO: implement initState
    size = widget.size;
    _onRefresh();
    super.initState();
  }

  //刷新 Action
  Future _onRefresh() async {
    var wait = await Future.wait([
      NetUtils().getBanner(),
      NetUtils().getRecommendResource(),
      NetUtils().getNewSongs()
    ]);
    wait.forEach((data) {
      if (data is BannerEntity) if (data != null) {
        banners = data.banners;
      }
      if (data is PersonalEntity) if (data != null) {
        sheet = data.result;
        listCard = buildSheetList(sheet);
      }
    });
    setState(() {});
  }

  //创建歌单sheets Action
  List<Widget> buildSheetList(List<PersonalResult> sheets) {
    List<Widget> list = [];
    sheets.forEach((sheet) {
      list.add(RComSongsListCard(
        sheet: sheet,
        size: size,
      ));
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    listW = [
      //Swiper需要二次开发，点击跳转
      buildBanner(banners),
      //按钮私人Fm和每日歌曲推荐热歌榜
      FMAndEveryComAndHotButton(size: size),
      //推荐歌单
      NeteaseListTitle(
        title: '推荐歌单',
        press: () {},
      ),
      //将数据填充进去
      GridView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listCard.length,
        itemBuilder: (BuildContext context, int index) {
          return listCard[index];
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1.45,
            crossAxisSpacing: 23.0,
            mainAxisSpacing: 0.0),
      ),
      NeteaseListTitle(
        title: '独家放送',
      ),
      RVideoListCardsList(size: size),
      NeteaseListTitle(
        title: '最新音乐',
      ),
      NeteaseListTitle(
        title: '推荐MV',
      ),
      NeteaseListTitle(
        title: '精选专栏',
      ),
    ];
    return EasyRefresh(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: listW,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
