import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/play/play_fm.dart';
import 'package:neatease_app/screen/singer/singer.dart';
import 'package:neatease_app/util/navigator_util.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:provider/provider.dart';

class FMAndEveryComAndHotButton extends StatelessWidget {
  const FMAndEveryComAndHotButton({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: [
              Container(
                width: (size.width) / 6,
                height: (size.width) / 6,
                margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Consumer<PlaySongsModel>(
                  builder: (_, model, __) {
                    return IconButton(
                      onPressed: () async {
                        var songs = await NetUtils().getFM();
                        model.playSongs(songs, index: 0);
                        model.mode = 0;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return PlayFm();
                        }));
                      },
                      icon: Icon(
                        Icons.radio,
                        size: ScreenUtil().screenWidth / 10,
                      ),
                    );
                  },
                ),
              ),
              Text('私人FM'),
            ],
          ),
          Column(
            children: [
              Container(
                width: (size.width) / 6,
                height: (size.width) / 6,
                margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Consumer<UserModel>(
                  builder: (context, model, child) {
                    return IconButton(
                      onPressed: () {
                        //应该设置登录限制
                        model.user != null
                            ? NavigatorUtil.goDailySongsPage(context)
                            : Fluttertoast.showToast(msg: '未登录');
                      },
                      icon: Icon(
                        Icons.receipt_outlined,
                        size: ScreenUtil().screenWidth / 10,
                      ),
                    );
                  },
                ),
              ),
              Text('每日歌曲推荐'),
            ],
          ),
          Column(
            children: [
              Container(
                width: (size.width) / 6,
                height: (size.width) / 6,
                margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Singer();
                    }));
                  },
                  icon: Icon(
                    Icons.trending_up_outlined,
                    size: ScreenUtil().screenWidth / 10,
                  ),
                ),
              ),
              Text('热门歌手'),
            ],
          ),
        ],
      ),
    );
  }
}
