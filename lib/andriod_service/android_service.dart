import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndroidService {
  //初始化通信管道-设置退出到手机桌面
  static const String CHANNEL = "android/service";
  static const platform = MethodChannel(CHANNEL);
  //设置回退到手机桌面
  static Future<bool> backDeskTop() async {
    //通知安卓返回,到手机桌面
    try {
      final bool out = await platform.invokeMethod('backDesktop');
      if (out) debugPrint('返回到桌面');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return Future.value(false);
  }

  static Future<int> getBattery() async {
    //获取电池电量
    int level = 0;
    try {
      level = await platform.invokeMethod('getBattery');
      debugPrint('$level');
    } on PlatformException catch (e) {
      debugPrint("通信失败(设置回退到安卓手机桌面:设置失败)");
      print(e.toString());
    }
    return level;
  }

  static Future<void> sendMessage() async {
    final Map params = <String, dynamic>{
      'name': 'my name  is slot',
      'age': 25,
    };
    await platform.invokeMethod('getList', params);
  }

  static Future<void> openSetting() async {
    await platform.invokeMapMethod('openSetting');
  }

  static Future<void> openView() async {
    await platform.invokeMapMethod("openView");
  }
}
