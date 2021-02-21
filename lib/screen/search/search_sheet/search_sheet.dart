import 'package:flutter/material.dart';
import 'package:neatease_app/entity/search_sheet_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';

class SearchSheetPage extends StatefulWidget {
  final List<SearchSheetResultPlaylist> playlists;

  SearchSheetPage({Key key, this.playlists});
  @override
  _SearchSheetPageState createState() => _SearchSheetPageState();
}

class _SearchSheetPageState extends State<SearchSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageHelper.getImage(
                '${widget.playlists[index].coverImgUrl}?param=100y100',
                height: 35,
                isRound: true),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            dense: true,
            title: Text('${widget.playlists[index].name}'),
            subtitle: Text(
              '${widget.playlists[index].trackCount} 首单曲',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () {
              NavigatorUtil.goSheetDetailPage(
                  context, widget.playlists[index].id);
            },
          );
        },
        itemCount: widget.playlists.length,
      ),
    );
  }
}
