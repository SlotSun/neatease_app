import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/login_entity.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/sp_util.dart';

import '../application.dart';

class UserModel with ChangeNotifier {
  LoginEntity _user;

  LoginEntity get user => _user;

  ///判断是否登录
  void isLogin() {
    if (SpUtil.haveKey(USER) == true) {
      print('111');
      _user = LoginEntity.fromJson(SpUtil.getObject(USER));
    } else {
      _user = null;
    }

    notifyListeners();
  }

  /// 登录
  void login(BuildContext context, String email, String pwd) async {
    NetUtils().loginByEmail(email, pwd).then((login) {
      if (login != null) {
        isLogin();
        NetUtils().getLoveSong(login.account.id);
        Application.setLoveList();
        //待优化代码
        SpUtil.putInt(USER_ID, login.account.id);
        SpUtil.putString('head', login.profile.avatarUrl);
        SpUtil.putString('nickname', login.profile.nickname);
        SpUtil.putString(USER_BACKGROUND, login.profile.backgroundUrl);
        SpUtil.putString('signature', login.profile.signature);

        Application.loginState = true;
        Fluttertoast.showToast(msg: '登录成功！');
        // Provider.of<PlayListModel>(context).user = login;
        //使用完要解锁
        NavigatorUtil.goHomePage(context);
      } else {
        Fluttertoast.showToast(msg: '登录失败请重新尝试！');
      }
    });
  }
}
