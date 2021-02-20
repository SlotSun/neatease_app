import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/personnal_mv.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/number_utils.dart';

Widget widgetPersonalMv(List<PersonalMVResult> pMv, BuildContext context) {
  return Container(
    height: ScreenUtil().setHeight(145),
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: pMv.length,
      itemBuilder: (BuildContext context, int index) {
        var d = pMv[index];
        return GestureDetector(
          onTap: () {
            NavigatorUtil.goPlayVideoPage(context, id: d.id);
          },
          child: Container(
            margin: EdgeInsets.only(
                left: kDefaultPadding / 4,
                top: kDefaultPadding / 2,
                bottom: kDefaultPadding / 4,
                right: kDefaultPadding / 4),
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(100),
            child: Column(
              children: [
                Stack(
                  children: [
                    ImageHelper.getImage(d.picUrl),
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
                            '${NumberUtils.amountConversion(Random().nextInt(10000000))}',
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
                    d.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
