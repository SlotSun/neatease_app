import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/search_hot_entity.dart';
import 'package:neatease_app/screen/search/search_detail/search_detail.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/widget_blackWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController;
  List<SearchHotData> data = [];
  int _count;

  _request() {
    _hotSearch().then((value) => data = value).then((value) {
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: blackWidget(
        null,
        Container(
          child: Column(
            children: <Widget>[
              PreferredSize(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQueryData.fromWindow(window).padding.top + 5,
                        left: 5,
                        right: 5),
                    child: Card(
                      elevation: 2,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setHeight(40),
                              child: Icon(
                                Icons.arrow_back,
                                size: 22,
                              ),
                            ),
                            onTap: () => Navigator.pop(context),
                          ),
//            IconButton(icon: Icon(Icons.arrow_back,size: Screens.setSp(22),), onPressed: ()=>Navigator.pop(viewService.context)),
                          Expanded(
                              child: TextField(
                            controller: textEditingController,
                            textInputAction: TextInputAction.search,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                                isDense: true,
                                hintText: '请输入搜索内容',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(10),
                                    horizontal: ScreenUtil().setWidth(5))),
                            onSubmitted: (text) {
                              if (text != '') {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (context) {
                                      return new SearchDetail(
                                        searchContent: text,
                                      );
                                    },
                                  ),
                                );
                              } else
                                Fluttertoast.showToast(msg: '搜索内容不能为空');
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(ScreenUtil().setHeight(54))),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      title: Row(
                        children: <Widget>[
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Text(data[index].searchWord))
                        ],
                      ),
                      subtitle: Text(data[index].content),
                      onTap: () {
                        Navigator.of(context).push(
                          new MaterialPageRoute(
                            builder: (context) {
                              return new SearchDetail(
                                searchContent: data[index].searchWord,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  itemCount: data.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setCount(int count) {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _count = count;
        });
      }
    });
  }

  Future<List<SearchHotData>> _hotSearch() async {
    var answer = await search_hot_details({}, await SelfUtil.getCookie());
    return answer.status == 200
        ? SearchHotEntity.fromJson(answer.body).data
        : null;
  }
}
