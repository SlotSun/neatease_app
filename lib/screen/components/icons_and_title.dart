import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconsAndTitle extends StatelessWidget {
  const IconsAndTitle({
    Key key,
    this.icons,
    this.title,
    this.press,
  }) : super(key: key);
  final IconData icons;
  final String title;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 10, bottom: 10, top: 10),
          width: ScreenUtil().setWidth(81.25),
          height: ScreenUtil().setHeight(35),
          child: IconButton(
            onPressed: press,
            icon: Icon(
              icons,
              color: Colors.white,
              size: ScreenUtil().setHeight(35),
            ),
          ),
        ),
        Text(
          '$title',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
