import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:neatease_app/andriod_service/android_service.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/home/home_drawer/home_drawer.dart';
import 'package:neatease_app/screen/mine/mine_page.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
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
  int _tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        Application.setLoveList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AndroidService.backDeskTop();
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            elevation: 0,
          ),
          preferredSize: Size.zero,
        ),
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
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
                                NavigatorUtil.goSearchPage(context);
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
        drawer: HomeDrawer(),
      ),
    );
  }
}
