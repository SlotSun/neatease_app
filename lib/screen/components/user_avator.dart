import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class UserAvator extends StatelessWidget {
  const UserAvator({
    Key key,
    this.img,
    this.size,
  }) : super(key: key);
  final String img;
  final Size size;

  @override
  Widget build(BuildContext context) {
    print(img);
    return Container(
      width: ScreenUtil().setWidth(size.width),
      height: ScreenUtil().setHeight(size.height),
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(img),
        ),
      ),
    );
  }
}
