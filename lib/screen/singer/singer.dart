import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/singer_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_load_footer.dart';

class Singer extends StatefulWidget {
  @override
  _SingerState createState() => _SingerState();
}

class _SingerState extends State<Singer> {
  int page = 0;
  List<SingerArtist> artists = [];
  bool isloading = true;
  EasyRefreshController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    _request();
  }

  Future _request() async {
    var answer =
        await top_artists({'offset': page * 15}, await SelfUtil.getCookie());
    if (answer.status == 200) {
      SingerEntity.fromJson(answer.body).artists.forEach((element) {
        artists.add(element);
      });

      setState(() {
        isloading = false;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('热门歌手'),
      ),
      body: isloading
          ? LoadingPage()
          : Scaffold(
              body: Container(
                child: EasyRefresh(
                  footer: LoadFooter(),
                  controller: _controller,
                  onLoad: () async {
                    page++;
                    _request();
                    _controller.finishLoad(noMore: artists.length >= 100);
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
                      return _playlistCard(artists[index]);
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setWidth(10)),
                        height: ScreenUtil().setWidth(1.5),
                        color: Color(0xfff5f5f5),
                      );
                    },
                    itemCount: artists.length,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _playlistCard(SingerArtist artist) {
    return ListTile(
      dense: true,
      contentPadding:
          EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
      leading: ImageHelper.getImage('${artist.picUrl}?param=100y100',
          height: 42, isRound: true),
      subtitle: Text(
        '${artist.musicSize} 首单曲',
        style: TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      title: Text(
        artist.name,
        style: TextStyle(fontSize: 14),
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        // NavigatorUtil.goSheetDetailPage(context, playlist.id);
      },
    );
  }
}
