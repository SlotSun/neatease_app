import 'package:flutter/material.dart';
import 'package:neatease_app/screen/components/uni_list_video_card.dart';

class RVideoListCardsList extends StatelessWidget {
  const RVideoListCardsList({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            UniListVideoCard(
              size: Size(size.width * 0.45, 85),
              img: 'assets/images/image_3.png',
              title: '短视频：骚的睁不开眼，欧美妖男编舞布莱妮热单',
              press: () {},
            ),
            UniListVideoCard(
              size: Size(size.width * 0.45, 85),
              img: 'assets/images/image_3.png',
              title: '短视频：真正的艺术家！87岁老奶奶弹奏《梁祝》',
              press: () {},
            ),
          ],
        ),
        UniListVideoCard(
          size: Size(size.width, 100),
          img: 'assets/images/image_3.png',
          title: '短视频：暴露年龄！听过这些歌的你，可能已经不再年轻',
          press: () {},
        )
      ],
    );
  }
}

