import 'package:flutter/material.dart';
import 'package:neatease_app/screen/components/uni_list_video_card.dart';

class RadioPersonalComCardList extends StatelessWidget {
  const RadioPersonalComCardList({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '程一电台',
              press: () {},
            ),
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '晓苏电台',
              press: () {},
            ),
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '十点读书',
              press: () {},
            ),
          ],
        ),
        Row(
          children: <Widget>[
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '冯提莫',
              press: () {},
            ),
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '【高能环绕】戴耳机入场哦',
              press: () {},
            ),
            UniListVideoCard(
              size: Size(103, 103),
              img: 'assets/images/image_1.png',
              title: '一个人听',
              press: () {},
            ),
          ],
        ),
      ],
    );
  }
}
