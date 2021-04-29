import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/slide_item.dart';
import 'package:provider/provider.dart';

class SheetManager extends StatefulWidget {
  @override
  _SheetManagerState createState() => _SheetManagerState();
}

class _SheetManagerState extends State<SheetManager> {
  SlideConfig slideConfig = SlideConfig(
    slideOpenAnimDuration: Duration(milliseconds: 200),
    slideCloseAnimDuration: Duration(milliseconds: 100),
    deleteStep1AnimDuration: Duration(milliseconds: 50),
    deleteStep2AnimDuration: Duration(milliseconds: 30),
    supportElasticity: true,
    closeOpenedItemOnTouch: false,
    slideProportion: 0.2,
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListModel>(builder: (_, model, __) {
      return Scaffold(
        appBar: AppBar(title: Text('歌单管理')),
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Text(
                      '创建的歌单',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Checkbox(value: false, onChanged: (value) {}),
                  ),
                ),
              ),
              _list(model, model.selfCreatePlayList, true, context),
              SliverToBoxAdapter(
                child: Container(
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Text(
                      '收藏的歌单',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Checkbox(value: false, onChanged: (value) {}),
                  ),
                ),
              ),
              _list(model, model.collectPlayList, false, context)
            ],
          ),
        ),
      );
    });
  }

  Widget _list(PlayListModel model, List<SheetDetailsPlaylist> list,
      bool isCreate, context) {
    return SlideConfiguration(
      config: slideConfig,
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, int index) {
            return SlideItem(
              slidable: true,
              indexInList: index + 1,
              leftActions: isCreate
                  ? [
                      SlideAction(
                        actionWidget: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '编辑歌单',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                        ),
                        tapCallback: (_) async {
                          _.close();
                        },
                      ),
                    ]
                  : [],
              actions: [
                SlideAction(
                  isDeleteButton: true,
                  actionWidget: Container(
                    alignment: Alignment.center,
                    child: Text(
                      isCreate ? '删除歌单' : '取消收藏',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.red,
                  ),
                  tapCallback: (_) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          title: Text(
                            "删除歌单",
                            style: bold16TextStyle,
                          ),
                          content: Text(
                            "确定要删除歌单吗？",
                            style: commonGrayTextStyle,
                          ),
                          actions: <Widget>[
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text('取消'),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Text('确认'),
                              ),
                              onTap: () {
                                model.delPlayList(list[index]).then((value) =>
                                    value
                                        ? Fluttertoast.showToast(msg: '删除成功')
                                        : Fluttertoast.showToast(msg: '删除失败'));
                                Navigator.pop(context);
                              },
                            ),
                          ]),
                    );

                    _.close();
                  },
                )
              ],
              child: _orderItem(list[index], context),
            );
          },
          childCount: list.length,
        ),
      ),
    );
  }

  Widget _orderItem(
    SheetDetailsPlaylist orderPlaylist,
    context,
  ) {
    return Container(
      color: Constants.dark ? Colors.grey[850] : Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        leading: ImageHelper.getImage(
            orderPlaylist.coverImgUrl + "?param=150y150",
            height: ScreenUtil().setHeight(32),
            isRound: true),
        title: Text(
          orderPlaylist.name,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
//      subtitle: Text('${state.ids.length} 首单曲', style: TextStyle(fontSize: Screens.text12)),
//    trailing: state.ids.length>0&&state.ids.contains('${orderPlaylist.id}')?Icon(Icons.select_all):Container(),
        onTap: () {},
      ),
    );
  }
}
