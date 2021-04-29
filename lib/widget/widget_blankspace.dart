import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget BlankSpace(){
  return  Container(
    height: ScreenUtil().setWidth(80),
    decoration: BoxDecoration(color: Colors.white),
  );
}