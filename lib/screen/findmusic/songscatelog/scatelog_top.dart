import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/screen/components/list_title.dart';
import 'package:neatease_app/screen/components/uni_list_video_card.dart';

class SCLogTop extends StatelessWidget {
  const SCLogTop({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: 122,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            UniListVideoCard(
              size: Size(90, 90),
              img: 'assets/images/image_1.png',
              title: '',
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                NeteaseListTitle(
                  title: '精品歌单',
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 12,
                      left: kDefaultPadding,
                      bottom: 5,
                    ),
                    child: Text(
                      '评论过万的英文歌与潜力股',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: kDefaultPadding,
                      bottom: 5,
                    ),
                    child: Text(
                      '听歌写评论 评评更健康',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}