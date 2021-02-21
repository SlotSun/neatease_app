import 'package:flutter/material.dart';
import 'package:neatease_app/entity/search_mv_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';

class SearchMvPage extends StatefulWidget {
  final List<SearchMvResultMv> mvs;

  const SearchMvPage({Key key, this.mvs}) : super(key: key);
  @override
  _SearchMvPageState createState() => _SearchMvPageState();
}

class _SearchMvPageState extends State<SearchMvPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return ListTile(
            leading: ImageHelper.getImage(
                '${widget.mvs[index].cover}?param=100y100',
                height: 35,
                isRound: true),
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            dense: true,
            title: Text('${widget.mvs[index].name}'),
            subtitle: Text(
              '${widget.mvs[index].artistName}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () {
              NavigatorUtil.goPlayVideoPage(context,
                  id: widget.mvs[index].id); //注意2
            },
          );
        },
        itemCount: widget.mvs.length,
      ),
    );
  }
}
