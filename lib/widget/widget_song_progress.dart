import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/provider/play_songs_model.dart';

import 'common_text_style.dart';

class SongProgressWidget extends StatelessWidget {
  final PlaySongsModel model;

  SongProgressWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: model.curPositionStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var totalTime =
              snapshot.data.substring(snapshot.data.indexOf('-') + 1);
          var curTime = double.parse(
              snapshot.data.substring(0, snapshot.data.indexOf('-')));
          var curTimeStr =
              DateUtil.formatDateMs(curTime.toInt(), format: "mm:ss");
          return buildProgress(curTime, totalTime, curTimeStr);
        } else {
          return buildProgress(0, "0", "00:00");
        }
      },
    );
  }

  Widget buildProgress(double curTime, String totalTime, String curTimeStr) {
    return Container(
      height: ScreenUtil().setWidth(50),
      child: Row(
        children: <Widget>[
          Text(
            curTimeStr,
            style: common14TextStyle,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                //提示进度的气泡的背景色
                valueIndicatorColor: Colors.grey,
                trackHeight: ScreenUtil().setWidth(1),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: ScreenUtil().setWidth(5),
                ),
              ),
              child: Slider(
                value: curTime,
                onChanged: (data) {
                  model.sinkProgress(data.toInt());
                },
                onChangeStart: (data) {
                  model.pausePlay();
                },
                onChangeEnd: (data) {
                  model.seekPlay(data.toInt());
                },
                //已播放进度条颜色
                activeColor: Colors.grey,
                inactiveColor: Colors.grey.withOpacity(0.8),
                min: 0,
                max: double.parse(totalTime),
              ),
            ),
          ),
          Text(
            DateUtil.formatDateMs(int.parse(totalTime), format: "mm:ss"),
            style: common14TextStyle,
          ),
        ],
      ),
    );
  }
}
