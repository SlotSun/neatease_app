import 'package:flutter/material.dart';
import 'package:neatease_app/screen/components/list_title.dart';

import 'anchor_cate_and _rank.dart';
import 'radio_card_list.dart';
import 'radio_personal_com_card_list.dart';

class AnchorRadioBody extends StatelessWidget {
  const AnchorRadioBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Container(
            width: size.width,
            height: 127,
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
          ),
          AnchorCateAndRank(
            size: size,
          ),
          NeteaseListTitle(title: '每天听些好节目'),
          RadioCardList(),
          NeteaseListTitle(title: '电台个性推荐'),
          RadioPersonalComCardList(), 
        ],
      ),
    );
  }
}

