import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (_, model, __) {
      return Drawer(
        elevation: 0,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                header(model),
                ListTile(
                  title: Text('我的消息'),
                  leading: Icon(Icons.email),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text('附近的人'),
                  leading: Icon(Icons.add_location),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text('设置'),
                  leading: Icon(Icons.settings),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  title: Text('退出'),
                  leading: Icon(Icons.highlight_off_rounded),
                  onTap: () {
                    exit(0);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Future<int> _dailySignin() async {
    var answer = await daily_signin({'type': 0}, await SelfUtil.getCookie());
    if (answer.status == 200) {
      Fluttertoast.showToast(msg: '签到成功');
    } else {
      Fluttertoast.showToast(msg: '请勿重复签到');
    }
    return answer.status;
  }

  Widget header(UserModel model) {
    return Semantics(
      container: true,
      label: MaterialLocalizations.of(context).signedInLabel,
      child: DrawerHeader(
        margin: EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsetsDirectional.only(top: 16.0, start: 16.0),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 16.0),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        child: Semantics(
                          explicitChildNodes: true,
                          child: SizedBox(
                            width: 72.0,
                            height: 72.0,
                            child: model.user != null
                                ? ImageHelper.getImage(
                                    model.user.profile.avatarUrl)
                                : Container(),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 87,
                        child: Column(
                          children: [
                            DefaultTextStyle(
                              style:
                                  Theme.of(context).primaryTextTheme.bodyText1,
                              overflow: TextOverflow.ellipsis,
                              child: Text(model.user != null
                                  ? model.user.profile.nickname
                                  : '未登录'),
                            ),
                            //等级介绍说明
                            InkWell(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(top: 5),
                                width: 42,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                ),
                                child: Center(
                                  child: model.user != null
                                      ? Text(
                                          'Lv.${SpUtil.getInt(USER_LEVEL)}',
                                          textAlign: TextAlign.center,
                                        )
                                      : Container(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      //签到：这里应该存储一个日期+签到信息的map，每次启动匹配
                      Positioned(
                        right: 0,
                        top: 20,
                        child: Ink(
                          color: Colors.grey,
                          child: InkWell(
                            onTap: () {
                              _dailySignin();
                            },
                            child: Container(
                              width: 70,
                              height: 31,
                              child: Center(
                                //为什么没有水纹呢？因为背景颜色阻挡了，在最外层包裹一个ink设置颜色.
                                child: Text(
                                  '签到',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      //头像下侧的动态关注粉丝个人信息按钮
                      Positioned(
                          top: 90,
                          left: 0,
                          child: Container(
                            child: Row(
                              //均分
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(right: 1),
                                    width: 65,
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('动态'),
                                        Text(
                                            '${model.user != null ? model.user.profile.eventCount : 0}'),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(right: 1),
                                    width: 65,
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('关注'),
                                        Text(
                                            '${model.user != null ? model.user.profile.follows : 0}'),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.only(right: 1),
                                    width: 65,
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text('粉丝'),
                                        Text(
                                            '${model.user != null ? model.user.profile.followeds : 0}'),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 1),
                                  width: 65,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Center(
                                      child: Text('我的资料'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
