import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/api/module.dart';
import 'package:neatease_app/entity/comment_head.dart';
import 'package:neatease_app/entity/song_talk_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/selfUtil.dart';
import 'package:neatease_app/widget/common_text_style.dart';
import 'package:neatease_app/widget/h_empty_view.dart';
import 'package:neatease_app/widget/v_empty_view.dart';
import 'package:neatease_app/widget/widget_load_footer.dart';

import 'comment_input.dart';

///评论页面：待根据评论类型获取评论
class CommentPage extends StatefulWidget {
  final CommentHead commentHead;

  CommentPage(this.commentHead);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  _CommentPageState();

  FocusNode _blankNode = FocusNode();
  EasyRefreshController _controller;
  Map<String, int> params;
  List<SongTalkCommants> commentData = [];
  List<SongTalkHotcommants> hotCommentData = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      params = {'id': int.parse(widget.commentHead.id)};
      _request();
    });
  }

  void _request() async {
    //根据分页获取每页的评论
    _getTalk(widget.commentHead.id, page).then((r) {
      setState(() {
        if (r.hotComments != null && r.hotComments.isNotEmpty) {
          hotCommentData.addAll(r.hotComments);
        }
        commentData.addAll(r.comments);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('评论（${widget.commentHead.count}）'),
      ),
      body: Stack(
        children: <Widget>[
          Listener(
            onPointerDown: (d) {
              FocusScope.of(context).requestFocus(_blankNode);
            },
            child: EasyRefresh(
              footer: LoadFooter(),
              controller: _controller,
              onLoad: () async {
                page == 0 ? page = 1 : page++;
                _request();
                _controller.finishLoad(
                    noMore: commentData.length >= widget.commentHead.count);
              },
              //热搜刷新 但是应该设定一个范围
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildHead(),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setWidth(20),
                      color: Color(0xfff5f5f5),
                      child: Text(
                        '精彩评论',
                        style: common18TextStyle,
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                        bottom: ScreenUtil().setWidth(50),
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _talkHotItem(hotCommentData[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(10)),
                          height: ScreenUtil().setWidth(1.5),
                          color: Color(0xfff5f5f5),
                        );
                      },
                      itemCount: hotCommentData.length,
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().setWidth(20),
                      color: Color(0xfff5f5f5),
                      child: Text(
                        '最新评论',
                        style: common18TextStyle,
                      ),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(30),
                        right: ScreenUtil().setWidth(30),
                        bottom: ScreenUtil().setWidth(50),
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _talkItem(commentData[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setWidth(1.5),
                          color: Color(0xfff5f5f5),
                        );
                      },
                      itemCount: commentData.length,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            child: CommentInputWidget((content) {
              // 提交评论
              _sendTalk(widget.commentHead.id, content).then((r) {
                setState(() {
                  Fluttertoast.showToast(msg: '评论成功！');
                });
              });
            }),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }

  Widget buildHead() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
          vertical: ScreenUtil().setWidth(20)),
      child: Row(
        children: <Widget>[
          ImageHelper.getImage(
            '${widget.commentHead.img}?param=200y200',
            height: 120,
          ),
          HEmptyView(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.commentHead.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: commonTextStyle,
                ),
                VEmptyView(10),
                Text(
                  widget.commentHead.author,
                  style: common14TextStyle,
                )
              ],
            ),
          ),
          HEmptyView(20),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
    );
  }

  ///获取评论
  Future<SongTalkEntity> _getTalk(id, page) async {
    var songTalkEntity;
    switch (widget.commentHead.type) {
      case 0:
        // TODO: Handle this case.
        var answer = await comment_music({
          'id': id,
          'offset': page * 15,
        }, await SelfUtil.getCookie());
        if (answer.status == 200) {
          songTalkEntity = SongTalkEntity.fromJson(answer.body);
        }
        break;
      case 1:
        // TODO: Handle this case
        break;
      case 2:
        // TODO: Handle this case.
        var answer = await comment_playlist({
          'id': id,
          'offset': page * 15,
        }, await SelfUtil.getCookie());
        if (answer.status == 200) {
          songTalkEntity = SongTalkEntity.fromJson(answer.body);
        }
        break;
      case 3:
        var answer = await comment_album({
          'id': id,
          'offset': page * 15,
        }, await SelfUtil.getCookie());
        if (answer.status == 200) {
          songTalkEntity = SongTalkEntity.fromJson(answer.body);
        }
        break;
      default:
        break;
    }
    return songTalkEntity;
  }

  ///发送评论
  Future<bool> _sendTalk(id, content) async {
    var answer = await comment(
        {'id': id, 't': 1, 'type': widget.commentHead.type, 'content': content},
        await SelfUtil.getCookie());
    if (answer.status == 200) {
      page = 0;
      commentData.clear();
      _request();
      return true;
    }
    return false;
  }

  ///给评论点赞:
  Future<bool> _commentLike(id, cid, t, type) async {
    var answer = await comment_like(
        {'id': id, 'cid': cid, 't': t, 'type': type},
        await SelfUtil.getCookie());
    if (answer.status == 200) {
      return true;
    } else {
      print('${answer.status}' + ' ${cid}');
    }
    return false;
  }

  Widget _talkHotItem(SongTalkHotcommants hotcommants) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 0, right: 10),
            dense: true,
            leading: ImageHelper.getImage(
                hotcommants.user.avatarUrl + "?param=80y80",
                height: 35,
                isRound: true),
            title: Text(hotcommants.user.nickname, style: common14TextStyle),
            subtitle: Text(
                '${DateTime.fromMillisecondsSinceEpoch(hotcommants.time)}',
                style: TextStyle(color: Colors.grey)),
            //点赞
            trailing: InkWell(
              onTap: () {
                print('点赞了');
                _commentLike(
                        widget.commentHead.id,
                        hotcommants.user.userId,
                        !hotcommants.liked ? 'like' : 'unlike',
                        widget.commentHead.type)
                    .then((value) {
                  if (value == true) {
                    Fluttertoast.showToast(
                        msg: hotcommants.liked ? '取消成功' : '点赞成功');
                    setState(() {
                      hotcommants.liked = !hotcommants.liked;
                      hotcommants.likedCount++;
                    });
                  }
                });
              },
              child: Text(
                '${hotcommants.likedCount > 10000 ? '${(hotcommants.likedCount / 10000).toStringAsFixed(1)}w' : hotcommants.likedCount} 赞',
                style: TextStyle(
                    color: hotcommants.liked ? Colors.red[400] : Colors.blue),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 55, right: 10),
            child: Text(
              hotcommants.content,
              style: TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _talkItem(SongTalkCommants commants) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 0, right: 10),
            dense: true,
            leading: ImageHelper.getImage(
                commants.user.avatarUrl + "?param=80y80",
                height: 35,
                isRound: true),
            title: Text(
              commants.user.nickname,
              style: common14TextStyle,
            ),
            subtitle: Text(
                '${DateTime.fromMillisecondsSinceEpoch(commants.time)}',
                style: TextStyle(color: Colors.grey)),
            trailing: Text(
              '${commants.likedCount > 10000 ? '${(commants.likedCount / 10000).toStringAsFixed(1)}w' : commants.likedCount} 赞',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 55, right: 10),
            child: Text(
              commants.content,
              style: TextStyle(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
