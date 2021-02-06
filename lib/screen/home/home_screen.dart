import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/mine/mine_page.dart';
import 'package:neatease_app/screen/search/search.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/sp_util.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                              var user = model.user;
                              return Builder(builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                  child: ImageHelper.getImage(
                                      model.isLogin()
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
                          child: TabBar(
                            labelStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            unselectedLabelStyle: TextStyle(fontSize: 14),
                            indicator: UnderlineTabIndicator(),
                            tabs: [
                              Tab(
                                text: '我的',
                              ),
                              Tab(
                                text: '发现',
                              ),
                              Tab(
                                text: '动态',
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
      drawer: Drawer(
        elevation: 0,
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: SpUtil.getInt(USER_ID) != 0
                      ? Text('${SpUtil.getString('nickname')}')
                      : Text('未登录'),
                  accountEmail: SpUtil.getInt(USER_ID) != 0
                      ? Text('${SpUtil.getString('signature')}')
                      : Text('Demo'),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      NavigatorUtil.goLoginPage(context);
                    },
                    child: ImageHelper.getImage(
                      SpUtil.getString('head',
                          defValue:
                              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588014709572&di=019dc384d533dd0fe890ec9d4e26beeb&imgtype=0&src=http%3A%2F%2Fp1.qhimgs4.com%2Ft01a30c675c53e713c2.jpg'),
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage('${SpUtil.getString('backgroundUrl')}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                  title: Text('我的好友'),
                  leading: Icon(Icons.people),
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
                  title: Text('音乐云盘'),
                  leading: Icon(Icons.cloud),
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: ScreenUtil().setWidth(50),
                color: Colors.green,
                child: Row(
                  children: <Widget>[],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
