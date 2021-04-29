import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/login_entity.dart';
import 'package:neatease_app/entity/login_status.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/util/sp_util.dart';

import '../application.dart';

class UserModel with ChangeNotifier {
  LoginEntity _user;

  LoginEntity get user => _user;

  ///判断是否登录
  void isLogin() {
    if (SpUtil.haveKey(USER) == true) {
      _user = LoginEntity.fromJson(SpUtil.getObject(USER));
    } else {
      _user = null;
    }
    notifyListeners();
  }

  ///自动登录
  void loginAuto(BuildContext context) async {
    LoginStatus loginStatus;
    var answer = await login_status(null, await SelfUtil.getCookie());
    if (answer.status == 200) {
      loginStatus = LoginStatus.fromJson(answer.body);
      if (loginStatus.data?.account == null) {
        login(context, SpUtil.getString("email"), SpUtil.getString('pwd'));
      } else {
        isLogin();
        NavigatorUtil.goHomePage(context);
      }
    }
  }

  /// 登录
  void login(BuildContext context, String email, String pwd) async {
    SpUtil.putString("email", email);
    SpUtil.putString("pwd", pwd);
    NetUtils().loginByEmail(email, pwd).then((login) async {
      if (login != null) {
        isLogin();
        //添加喜爱歌曲id清单
        NetUtils().getLoveSong(login.account.id);
        int level = await NetUtils().userLevel();
        Application.setLoveList();
        //待优化代码
        SpUtil.putInt(USER_ID, login.account.id);
        SpUtil.putString('head', login.profile.avatarUrl);
        SpUtil.putString('nickname', login.profile.nickname);
        SpUtil.putString(USER_BACKGROUND, login.profile.backgroundUrl);
        SpUtil.putString('signature', login.profile.signature);

        Application.loginState = true;
        Fluttertoast.showToast(msg: '登录成功！');
        //应该将当前歌单用户的歌单缓存在本地，提高打开效率：待优化

        NavigatorUtil.goHomePage(context);
      } else {
        NavigatorUtil.goHomePage(context);
        Fluttertoast.showToast(msg: '登录失败请重新尝试！');
      }
    });
  }
}
