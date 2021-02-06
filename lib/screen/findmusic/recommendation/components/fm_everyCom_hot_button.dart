import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/screen/findmusic/songscatelog/detail/sheet_sq_details_page.dart';
import 'package:neatease_app/util/navigator_util.dart';
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
        children: <Widget>[
          Column(
            children: [
              Container(
                width: (size.width) / 5,
                height: (size.width) / 5,
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
                      return SheetSqDetailsPage(
                        type: '全部',
                      );
                    }));
                  },
                  icon: SvgPicture.asset('assets/icons/fm.svg'),
                ),
              ),
              Text('私人FM'),
            ],
          ),
          Column(
            children: [
              Container(
                width: (size.width) / 5,
                height: (size.width) / 5,
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
                        model.user != null?NavigatorUtil.goDailySongsPage(context):Fluttertoast.showToast(msg: '未登录');
                      },
                      icon: SvgPicture.asset('assets/icons/today.svg'),
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
                width: (size.width) / 5,
                height: (size.width) / 5,
                margin: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/icons/round_rank_fill.svg'),
                ),
              ),
              Text('云音乐热歌榜'),
            ],
          ),
        ],
      ),
    );
  }
}
