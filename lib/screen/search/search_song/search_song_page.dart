import 'package:flutter/material.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:provider/provider.dart';

class SearchSongPage extends StatefulWidget {
  final List<SheetDetailsPlaylistTrack> songs;

  SearchSongPage({Key key, this.songs});

  @override
  _SearchSongPageState createState() => _SearchSongPageState();
}

class _SearchSongPageState extends State<SearchSongPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(
      builder: (_, model, __) {
        return Container(
          child: ListView.builder(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return ListTile(
                leading: ImageHelper.getImage(
                    '${widget.songs[index].al.picUrl}?param=100y100',
                    height: 35,
                    isRound: true),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                dense: true,
                title: Text('${widget.songs[index].name}'),
                subtitle: Text('${widget.songs[index].ar.first.name}'),
                onTap: () {
                  playSongs(model, index, context);
                },
              );
            },
            itemCount: widget.songs.length,
          ),
        );
      },
    );
  }

  void playSongs(PlaySongsModel model, int index, BuildContext context) {
    model.playSongs(
      widget.songs,
      index: index,
    );
  }
}
