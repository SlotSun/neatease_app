import 'package:flutter/material.dart';
import 'package:neatease_app/screen/findmusic/songscatelog/detail/sheet_sq_details_page.dart';
import 'package:neatease_app/widget/nav_bar.dart';
import 'package:neatease_app/widget/widget_blackWidget.dart';

class SCateBody extends StatefulWidget {
  @override
  _SCateBodyState createState() => _SCateBodyState();
}

class _SCateBodyState extends State<SCateBody>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: blackWidget(
          null,
          Container(
            child: DefaultTabController(
                initialIndex: 0,
                length: 8,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 14),
                      tabs: <Widget>[
                        // 全部,华语,欧美,韩语,日语,粤语,小语种,运动,ACG,影视原声,流行,摇滚,后摇,古风,民谣,轻音乐,电子,器乐,说唱,古典,爵士
                        Tab(text: '全部'),
                        Tab(text: '华语'),
                        Tab(text: '欧美'),
                        Tab(text: '韩语'),
                        Tab(text: '日语'),
                        Tab(text: '粤语'),
                        Tab(text: '民谣'),
                        Tab(text: '古风'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          SheetSqDetailsPage(type: '全部'),
                          SheetSqDetailsPage(type: '华语'),
                          SheetSqDetailsPage(type: '欧美'),
                          SheetSqDetailsPage(type: '韩语'),
                          SheetSqDetailsPage(type: '日语'),
                          SheetSqDetailsPage(type: '粤语'),
                          SheetSqDetailsPage(type: '民谣'),
                          SheetSqDetailsPage(type: '古风'),
                        ],
                      ),
                    ),
                  ],
                )),
          )),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
