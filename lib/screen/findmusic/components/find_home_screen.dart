import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neatease_app/screen/findmusic/anchorradio/components/body.dart';
import 'file:///D:/WorkSpace/neatease_app/lib/screen/search/search.dart';
import 'package:neatease_app/screen/findmusic/components/src/search_static_bar.dart';
import 'package:neatease_app/screen/findmusic/recommendation/components/body.dart';
import 'package:neatease_app/screen/top/top.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'file:///D:/WorkSpace/neatease_app/lib/screen/findmusic/songscatelog/s_cate_body.dart';
import 'package:neatease_app/widget/widget_play.dart';

class FindHomeScreen extends StatefulWidget {
  FindHomeScreen({Key key}) : super(key: key);

  @override
  _FindHomeScreenState createState() => _FindHomeScreenState();
}

class _FindHomeScreenState extends State<FindHomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> titleTabs = <Tab>[
    Tab(
      text: '个性推荐',
    ),
    Tab(
      text: '歌单',
    ),
    Tab(
      text: '主播电台',
    ),
    Tab(
      text: '排行榜',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // 初始化TabController
    // 参数1：初试显示的tab位置
    // 参数2：tab的个数
    // 参数3：动画效果的异步处理，默认格式

    // 添加监听器
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
          //顶部搜索栏
        ),
        preferredSize: Size.zero,
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          initialIndex: 0,
          length: 4,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: TabBar(



                      labelStyle: bold13TextStyle,
                      //选中的样式
                      unselectedLabelColor: Colors.black,
                      //未选中的颜色
                      unselectedLabelStyle: TextStyle(fontSize: 13),
                      //未选中的样式
                      indicatorColor: Colors.teal,
                      //下划线颜色
                      isScrollable: false,
                      //是否可滑动，设置不可滑动，则是tab的宽度等长
                      //tab标签
                      tabs: titleTabs,
                      // 设置标题

                      //点击事件
                      onTap: (int i) {
                        // print(i + 10);
                      },
                    ),
                  ),
                  Expanded(
                    child: new TabBarView(
                      children: <Widget>[
                        // 每个空间对应的页面、
                        RecBody(size: size),
                        SCateBody(),
                        AnchorRadioBody(),
                        Top(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onTabChanged() {}
}
