import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/dialog/create_playlist.dart';
import 'package:neatease_app/screen/mine/sheet_manager/sheet_manager.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:provider/provider.dart';

///个人界面
class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  ///控制个人列表展开-default：false
  bool isOpenCreate = false;

  ///控制收藏列表展开-default：false
  bool isOpenLike = false;
  PlayListModel _playListModel;

  ///加载-default：false
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(SpUtil.getInt(USER_ID));
    print(SpUtil.haveKey(USER));
    //当所有的组件初始化后
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        _playListModel = Provider.of<PlayListModel>(context, listen: false);
        _playListModel
            .getSelfPlaylistData(SpUtil.getInt(USER_ID))
            .then((value) {
          isLoading = false;
          setState(() {});
        });
      }
    });
  }

  ///区分个人歌单和收藏歌单

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    super.build(context);

    return Consumer<UserModel>(
      builder: (context, model, child) {
        return model.user == null
            ? _unLoginView()
            : isLoading
                ? LoadingPage()
                : _loginView(model);
      },
    );
  }

  ///未登录页面
  Widget _unLoginView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset(
            'assets/images/image_1.png',
            height: ScreenUtil().setHeight(160),
          ),
        ),
        Container(
          width: ScreenUtil().screenWidth * 0.6,
          child: MaterialButton(
            onPressed: () {
              NavigatorUtil.goLoginPage(context);
            },
            child: Text('点我去登录'),
          ),
        ),
      ],
    );
  }

  ///登录页面
  Widget _loginView(UserModel userModel) {
    return Consumer<PlayListModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.zero,
            child: AppBar(
              elevation: 0,
            ),
          ),
          body: EasyRefresh(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Expanded(
                        child: Wrap(
                          direction: Axis.vertical,
                          children: [
                            //用户名
                            Container(
                              height: ScreenUtil().setWidth(30),
                              child: Text(
                                '${SpUtil.getString(NICKNAME)}',
                                style: TextStyle(fontSize: 18),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            //
                            Container(
                              height: ScreenUtil().setWidth(30),
                              child: Text(
                                '${SpUtil.getString(SIGNATURE)}',
                                style: TextStyle(fontSize: 13),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                      ),
                      //退出按钮
                      IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            size: 22,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  title: Text("退出登录"),
                                  content: Text("确定要退出登录吗？"),
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
                                        //清除本地存储登录态
                                        SpUtil.clear();
                                        //判定界面
                                        userModel.isLogin();
                                        Navigator.pop(context);
                                        //这一步多余
                                        setState(() {});
                                      },
                                    ),
                                  ]),
                            );
                          }),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 4))
                    ],
                  ),
                ),
                _loginViewHistoryAndCloudAndFrindsAndManage(),
                SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () {
                      isOpenCreate = !isOpenCreate;
                      setState(() {});
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Icon(isOpenCreate
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Text(
                                '我创建的歌单 (${model.selfCreatePlayList.length})',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Wrap(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    //创建之后应该刷新当前界面添加新的歌单:应该抽离成状态监听
                                    showDialog(
                                      context: context,
                                      child: CreatePlayListDialog(),
                                    );
                                  }),
                              IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SheetManager();
                                    }));
                                  }),
                            ],
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                    ),
                  ),
                ),
                isOpenCreate
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, int index) {
                            return _orderItem(
                                model, model.selfCreatePlayList[index]);
                          },
                          childCount: model.selfCreatePlayList.length,
                        ),
                      )
                    : SliverToBoxAdapter(),
                SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () {
                      isOpenLike = !isOpenLike;
                      setState(() {});
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Wrap(
                            children: <Widget>[
                              Icon(isOpenLike
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_right),
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Text(
                                '我收藏的歌单 (${model.collectPlayList.length})',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Wrap(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SheetManager();
                                    }));
                                  }),
                            ],
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                    ),
                  ),
                ),
                isOpenLike
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, int index) {
                            return _orderItem(
                              model,
                              model.collectPlayList[index],
                            );
                          },
                          childCount: model.collectPlayList.length,
                        ),
                      )
                    : SliverToBoxAdapter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _loginViewHistoryAndCloudAndFrindsAndManage() {
    return Consumer<UserModel>(
      builder: (_, model, __) {
        return SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.history,
                  ),
                  onPressed: () {
                    NavigatorUtil.goHistoryPage(context, model.user.account.id);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.cloud,
                  ),
                  onPressed: () {
                    NavigatorUtil.goUserCloudPage(context);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.people,
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: '暂不可用');
                  }),
              IconButton(
                  icon: Icon(
                    Icons.queue_music,
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: '暂不可用');
                    // Navigator.of(viewService.context).pushNamed('local_music', arguments: null);
                  }),
            ],
          ),
        );
      },
    );
  }

  ///歌单项
  Widget _orderItem(PlayListModel model, SheetDetailsPlaylist orderPlaylist) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 2),
      leading: ImageHelper.getImage(
          orderPlaylist.coverImgUrl + "?param=150y150",
          height: ScreenUtil().setHeight(42),
          isRound: true),
      title: Text(
        orderPlaylist.name,
        style: TextStyle(fontSize: 14),
      ),
      subtitle: Text('${orderPlaylist.trackCount} 首单曲',
          style: TextStyle(fontSize: 12)),
      onTap: () {
        if (orderPlaylist.trackCount == 0)
          Fluttertoast.showToast(msg: "当前列表为空");
        else
          NavigatorUtil.goSheetDetailPage(context, orderPlaylist.id); //注意
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
