import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/v_empty_view.dart';

class PlayListDescDialog extends StatelessWidget {
  final SheetDetailsPlaylist _data;

  PlayListDescDialog(this._data);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: <Widget>[
            ImageHelper.getImage('${_data.coverImgUrl}?param=400y400'),
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 30,
                sigmaX: 30,
              ),
              child: Container(
                color: Colors.black38,
              ),
            ),
            SafeArea(
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(10),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: ScreenUtil().setWidth(40),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      child: Column(
                        children: <Widget>[
                          VEmptyView(80),
                          Align(
                            alignment: Alignment.topCenter,
                            child: ImageHelper.getImage(
                                '${_data.coverImgUrl}?param=400y400',
                                height: 300),
                          ),
                          VEmptyView(40),
                          Text(
                            _data.name,
                            textAlign: TextAlign.center,
                            style: mWhiteBoldTextStyle,
                            softWrap: true,
                          ),
                          VEmptyView(40),
                          Image.asset(
                            'assets/images/icon_line_1.png',
                            width: ScreenUtil().screenWidth * 3 / 4,
                          ),
                          VEmptyView(20),
                          // _data.tags.isEmpty
                          //     ? Container()
                          //     : Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: <Widget>[
                          //           Text(
                          //             '标签：',
                          //             style: common14WhiteTextStyle,
                          //           ),
                          //           ..._data.tags
                          //               .map((t) => TagWidget(t))
                          //               .toList()
                          //         ],
                          //       ),
                          // _data.tags.isEmpty ? Container() : VEmptyView(20),
                          Text(
                            _data.description,
                            style: common14WhiteTextStyle,
                            softWrap: true,
                          ),
                          VEmptyView(50),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
