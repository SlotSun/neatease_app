import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common_text_style.dart';
import 'v_empty_view.dart';

class FooterTabWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  FooterTabWidget(this.iconData, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Icon(
              iconData,
              size: ScreenUtil().setWidth(40),
              color: Colors.white60,
            ),
            VEmptyView(ScreenUtil().setWidth(8)),
            Text(
              text,
              style: common14White70TextStyle,
            )
          ],
        ),
      ),
    );
  }
}
