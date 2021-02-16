import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/personal_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/number_utils.dart';

class RComSongsListCard extends StatelessWidget {
  const RComSongsListCard({
    Key key,
    @required this.size,
    this.img,
    this.viewed,
    this.title,
    this.press,
    this.sizeH,
    this.sheet,
  }) : super(key: key);

  final String img;
  final int viewed;
  final String title;
  final Function press;
  final Size sizeH;
  final Size size;
  final PersonalResult sheet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //添加一个路由跳转到歌单详情,从而实现loading
      onTap: () async {
        NavigatorUtil.goSheetDetailPage(context, sheet.id);
        // var data = await NetUtils().getPlayListDetails(sheet.id);
        // if (data.playlist != null)
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => SheetDetail(data.playlist),
        //     ),
        //   );
      },
      child: Container(
        margin: EdgeInsets.only(
            left: kDefaultPadding / 4,
            top: kDefaultPadding / 2,
            bottom: kDefaultPadding / 4,
            right: kDefaultPadding / 4),
        width: size.width,
        child: Column(
          children: [
            Stack(
              children: [
                ImageHelper.getImage(sheet.picUrl),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.headset,
                        color: Colors.white70,
                        size: 17,
                      ),
                      Text(
                        '${NumberUtils.amountConversion(sheet.playCount)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                sheet.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
