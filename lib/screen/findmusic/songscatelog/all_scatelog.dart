import 'package:flutter/material.dart';
import 'package:neatease_app/screen/components/list_title.dart';
import 'package:neatease_app/screen/components/r_com_songs_card.dart';

class AllScatelog extends StatelessWidget {
  const AllScatelog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: <Widget>[
          NeteaseListTitle(
            title: '全部歌单',
          ),
          Spacer(),
          Text(
            '欧美 | 民谣 | 电子   ',
            style: TextStyle(
              fontSize: 14,
            ),
          )
        ],
      ),
      Column(
        children: [],
      )
    ]);
  }
}
