import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:provider/provider.dart';

import '../../widget/common_text_style.dart';

/// 底部弹出框 初步封装：需要抽离数据再封装
class CommonBottomSheet extends StatefulWidget {
  CommonBottomSheet({Key key, this.list, this.onItemClickListener})
      : assert(list != null),
        super(key: key);
  final List<BottomSheetMenu> list;
  final OnItemClickListener onItemClickListener;

  @override
  _CommonBottomSheetState createState() => _CommonBottomSheetState();
}

typedef OnItemClickListener = void Function(int index);

class _CommonBottomSheetState extends State<CommonBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlaySongsModel>(
      builder: (_, model, __) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '歌曲:${model.curSong.name}',
                    style: commonGrayTextStyle,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, index) {
                    return buildContainer(widget.list[index], model);
                  },
                  itemCount: widget.list.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container buildContainer(BottomSheetMenu list, PlaySongsModel model) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 50,
      child: InkWell(
        onTap: list.function,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              list.iconData,
              color: Colors.lightBlue,
              size: 35,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: Color(0xffe5e5e5),
                    ),
                  ),
                ),
                child: Text(
                  list.title,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetMenu {
  String title;
  Function function;
  IconData iconData;

  BottomSheetMenu(
      {@required this.iconData, this.function, @required this.title});
}
