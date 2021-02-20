import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/mine/mine_page.dart';
import 'package:neatease_app/screen/search/search.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/widget_play.dart';
import 'package:provider/provider.dart';

import '../findmusic/components/find_home_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  UserModel _userModel;

  int _tabIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _userModel = Provider.of<UserModel>(context, listen: false);
        _userModel.isLogin();
        Application.setLoveList();
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.zero,
      ),
      backgroundColor: Colors.white,
      body: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: <Widget>[
              Padding(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 5,
                          left: 20,
                          child: Consumer<UserModel>(
                            builder: (_, model, __) {
                              return Builder(builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: ImageHelper.getImage(
                                      model.user != null
                                          ? model.user.profile.avatarUrl
                                          : 'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fa0.att.hudong.com%2F30%2F29%2F01300000201438121627296084016.jpg&refer=http%3A%2F%2Fa0.att.hudong.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1615185018&t=cdef38e94885581e29b1244310893c0c',
                                      height: 40,
                                      isRound: true),
                                );
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(75)),
                          //切换tab中文抖动，需要修复，思路：让内部组件自刷新
                          child: TabBar(
                            //略微牺牲性能
                            onTap: (index) {
                              setState(() {
                                _tabIndex = index;
                              });
                            },

                            // labelStyle: TextStyle(
                            //     fontSize: 20, fontWeight: FontWeight.bold),
                            // unselectedLabelStyle: TextStyle(fontSize: 14),
                            indicator: UnderlineTabIndicator(),
                            tabs: [
                              Tab(
                                child: Text(
                                  '我的',
                                  style: _tabIndex == 0
                                      ? tabInTextStyle
                                      : tabUnTextStyle,
                                ),
                              ),
                              Tab(
                                child: Text(
                                  '发现',
                                  style: _tabIndex == 1
                                      ? tabInTextStyle
                                      : tabUnTextStyle,
                                ),
                              ),
                              Tab(
                                child: Text(
                                  '动态',
                                  style: _tabIndex == 2
                                      ? tabInTextStyle
                                      : tabUnTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: IconButton(
                            icon: Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              showSearch(
                                  context: context, delegate: SearchPage());
                            },
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // 我,
                          MinePage(),
                          //发现
                          FindHomeScreen(),
                          // 动态
                          Container(),
                        ],
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(75),
                ),
              ),
              PlayWidget(),
            ],
          ),
        ),
      ),
      drawer: Consumer<UserModel>(
        builder: (_, model, __) {
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
                      onTap: () {
                        SpUtil.putString('head',
                            'https://image.baidu.com/search/detail?ct=503316480&z=undefined&tn=baiduimagedetail&ipn=d&word=%E5%9B%BE%E7%89%87&step_word=&ie=utf-8&in=&cl=2&lm=-1&st=undefined&hd=undefined&latest=undefined&copyright=undefined&cs=3363295869,2467511306&os=892371676,71334739&simid=4203536407,592943110&pn=0&rn=1&di=5830&ln=1672&fr=&fmq=1612004503815_R&fm=&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&is=0,0&istype=0&ist=&jit=&bdtype=0&spn=0&pi=0&gsm=0&hs=2&objurl=https%3A%2F%2Fgimg2.baidu.com%2Fimage_search%2Fsrc%3Dhttp%253A%252F%252Fa0.att.hudong.com%252F30%252F29%252F01300000201438121627296084016.jpg%26refer%3Dhttp%253A%252F%252Fa0.att.hudong.com%26app%3D2002%26size%3Df9999%2C10000%26q%3Da80%26n%3D0%26g%3D0n%26fmt%3Djpeg%3Fsec%3D1614596509%26t%3Dbaa41b010d113aac0b061851b83d3b09&rpstart=0&rpnum=0&adpicid=0&force=undefined');
                      },
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
                        SpUtil.clear();
                        Fluttertoast.showToast(msg: '已退出登录');
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
