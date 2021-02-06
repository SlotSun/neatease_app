import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/util/sp_util.dart';

Widget blackWidget(bool isBlack, Widget child) {
  if (isBlack == null)
    isBlack = SpUtil.getString(USER_BACKGROUND, defValue: null) != null;
  return Container(
    decoration: isBlack
        ? BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(SpUtil.getString(USER_BACKGROUND))), //
          fit: BoxFit.cover,
        ))
        : BoxDecoration(),
    child: ClipRRect(
      // make sure we apply clip it properly
      child: BackdropFilter(
        //背景滤镜
        filter: ImageFilter.blur(
            sigmaX: SpUtil.getDouble(BLUR, defValue: 0),
            sigmaY: SpUtil.getDouble(BLUR, defValue: 0)), //背景模糊化
        child: Container(
          alignment: Alignment.center,
          color: Colors.white.withOpacity(isBlack?0.3:0),
          child: child,
        ),
      ),
    ),
  );
}