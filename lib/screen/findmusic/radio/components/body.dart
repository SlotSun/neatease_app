import 'package:flutter/material.dart';

class AnchorRadioBody extends StatelessWidget {
  const AnchorRadioBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Center(
        child: Text('暂未开发'),
      ),
    );
    //   SingleChildScrollView(
    //   scrollDirection: Axis.vertical,
    //   child: Column(
    //     children: <Widget>[
    //       Container(
    //         width: size.width,
    //         height: 127,
    //         decoration: BoxDecoration(
    //           color: Colors.grey,
    //         ),
    //       ),
    //       AnchorCateAndRank(
    //         size: size,
    //       ),
    //       NeteaseListTitle(title: '每天听些好节目'),
    //       RadioCardList(),
    //       NeteaseListTitle(title: '电台个性推荐'),
    //       RadioPersonalComCardList(),
    //     ],
    //   ),
    // );
  }
}
