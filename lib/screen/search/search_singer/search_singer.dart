import 'package:flutter/material.dart';
import 'package:neatease_app/entity/search_singer_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';

class SearchSingerPage extends StatefulWidget {
  final List<SearchSingerResultArtist> artists;

  const SearchSingerPage({Key key, this.artists}) : super(key: key);

  @override
  _SearchSingerPageState createState() => _SearchSingerPageState();
}

class _SearchSingerPageState extends State<SearchSingerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageHelper.getImage(
                '${widget.artists[index].picUrl}?param=100y100',
                height: 35,
                isRound: true),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            dense: true,
            title: Text('${widget.artists[index].name}'),
            subtitle: Text(
              '${widget.artists[index].albumSize} 张专辑',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () async {
              NavigatorUtil.goSingerDetailPage(
                  context, widget.artists[index].id);
            },
          );
        },
        itemCount: widget.artists.length,
      ),
    );
  }
}
