import 'package:flutter/material.dart';
import 'package:neatease_app/entity/play_history_entity.dart';
import 'package:neatease_app/entity/song_bean_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:neatease_app/widget/widget_music_list_item.dart';
import 'package:neatease_app/widget/widget_play.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  History(this.id);

  final id;

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  PlayHistoryEntity _playHistoryEntity;
  bool isLoading = true;
  List<PlayHistoryAlldata> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NetUtils().getHistory(widget.id).then(
      (value) {
        list = value.allData;
        setState(
          () {
            isLoading = false;
          },
        );
      },
    );
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
                    title: Text('听歌历史'),
                  ),
                  Expanded(
                    child: Consumer<PlaySongsModel>(
                      builder: (context, model, child) {
                        return ListView.builder(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            var d = list[index];
                            return WidgetMusicListItem(
                              SongBeanEntity(
                                name: d.song.name,
                                id: '${d.song.id}',
                                singer:
                                    '${d.song.ar.map((a) => a.name).toList().join('/')}',
                                mv: d.song.mv,
                              ),
                              onTap: () {
                                playSongs(model, index);
                              },
                              index: index,
                            );
                          },
                          itemCount: list.length,
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
      list.map((e) => e.song).toList(),
      index: index,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayBody()),
    );
  }
}
