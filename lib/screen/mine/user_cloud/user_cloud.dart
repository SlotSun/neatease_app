import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/cloud_entity.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_load_footer.dart';
import 'package:neatease_app/widget/widget_music_list_item.dart';
import 'package:neatease_app/widget/widget_play.dart';
import 'package:provider/provider.dart';

import '../../../application.dart';

class UserCloud extends StatefulWidget {
  @override
  _UserCloudState createState() => _UserCloudState();
}

class _UserCloudState extends State<UserCloud> {
  bool isLoading = true;
  List<SheetDetailsPlaylistTrack> songs = [];
  int offset = 0;
  EasyRefreshController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
    _getUserCloud(offset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingPage()
          : Scaffold(
              appBar: AppBar(
                title: Text('云盘数据'),
              ),
              body: Stack(
                children: <Widget>[
                  Container(
                    child: EasyRefresh(
                      onLoad: () async {
                        offset++;
                        print(songs.length);
                        _getUserCloud(offset);
                        _controller.finishLoad(noMore: songs.length >= 1000);
                      },
                      footer: LoadFooter(),
                      controller: _controller,
                      child: Consumer<PlaySongsModel>(
                        builder: (context, model, child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var d = songs[index];
                              return WidgetMusicListItem(
                                d,
                                onTap: () {
                                  playSongs(model, index);
                                },
                                index: index,
                              );
                            },
                            itemCount: songs.length,
                          );
                        },
                      ),
                    ),
                  ),
                  PlayWidget(),
                ],
              ),
            ),
    );
  }

  void playSongs(PlaySongsModel model, int index) {
    model.playSongs(
      songs,
      index: index,
    );
    print(songs.first.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayBody()),
    );
  }

  Future<bool> _getUserCloud(offset) async {
    var answer = await user_cloud(
        {'limit': 20, 'offset': offset}, await SelfUtil.getCookie());

    if (answer.status == 200) {
      var body = answer.body;
      CloudEntity cloudEntity = CloudEntity.fromJson(body);
      if (cloudEntity.code == 200) {
        cloudEntity.data.forEach((CloudData d) {
          d.simpleSong.like =
              Application.loveList.indexOf('${d.simpleSong.id}') != -1
                  ? true
                  : false;
          songs.add(d.simpleSong);
        });
        setState(() {
          isLoading = false;
        });
      }
    }
    return true;
  }
}
