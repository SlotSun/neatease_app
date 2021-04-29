import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:provider/provider.dart';
//需要调用原生插件上传图片
class CreatePlayListDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DialogState();
}

class _DialogState extends State<CreatePlayListDialog> {
  bool isCreate = false;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * .8;
    return Consumer<PlayListModel>(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              width: width,
              child: isCreate
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    )
                  : Wrap(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child:
                                Text('创建歌单', style: TextStyle(fontSize: 16))),
                        Container(
                          width: width,
                          height: 30,
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                          child: TextField(
                            controller: textEditingController,
                            autofocus: true,
                          ),
                        ),
                        Container(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                child: Text('取消'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('创建'),
                                onPressed: () async {
                                  if (textEditingController.text != '') {
                                    setState(() {
                                      isCreate = true;
                                    });
                                    NetUtils()
                                        .createPlayList(
                                            textEditingController.text)
                                        .then((value) {
                                      if (value)
                                        Fluttertoast.showToast(msg: '创建成功');
                                      //这是util设置的返回数据有问题 需要下一步修正。
                                      model.getSelfPlaylistData(
                                        SpUtil.getInt(USER_ID),
                                      );
                                    });

                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
