import 'package:flutter/material.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/cloud_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/loading.dart';
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
  List<SongBeanEntity> songs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserCloud().then((value) {
      songs = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingPage()
          : Container(
              child: Column(
                children: <Widget>[
                  AppBar(
                    title: Text('云盘数据'),
                  ),
                  Expanded(
                    child: Consumer<PlaySongsModel>(
                      builder: (context, model, child) {
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            var d = songs[index];
                            return WidgetMusicListItem(
                              d,
                              onTap: () {
                                print(songs.length);
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayBody()),
    );
  }

  Future _getUserCloud() async {
    var answer = await user_cloud({}, await SelfUtil.getCookie());
    List<SongBeanEntity> songs = List();
    if (answer.status == 200) {
      var body = answer.body;
      CloudEntity cloudEntity = CloudEntity.fromJson(body);
      if (cloudEntity.code == 200) {
        Future.forEach(cloudEntity.data, (CloudData d) async {
          songs.add(SongBeanEntity(
            id: '${d.songId}',
            name: d.songName,
            mv: d.simpleSong.mv,
            like: Application.loveList.indexOf('${d.simpleSong.id}') != -1
                ? true
                : false,
            singer: '${d.simpleSong.ar.map((a) => a.name).toList().join('/')}',
            picUrl: d.simpleSong.al.picUrl,
          ));
        });
      }
      return songs;
    }
  }
}
