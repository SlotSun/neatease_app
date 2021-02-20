import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/application.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/new_song_entity.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/screen/play/body.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/number_utils.dart';
import 'package:provider/provider.dart';

Widget widgetNewSong(List<NewSongResult> newSong, BuildContext context) {
  return Container(
    height: ScreenUtil().setHeight(145),
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: newSong.length,
      itemBuilder: (BuildContext context, int index) {
        return Consumer<PlaySongsModel>(
          builder: (_, model, __) {
            var d = newSong[index];
            return GestureDetector(
              onTap: () {
                playSongs(model, index, newSong, context);
              },
              child: Container(
                margin: EdgeInsets.only(
                    left: kDefaultPadding / 4,
                    top: kDefaultPadding / 2,
                    bottom: kDefaultPadding / 4,
                    right: kDefaultPadding / 4),
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(100),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ImageHelper.getImage(d.picUrl),
                        Container(
                          margin: EdgeInsets.all(2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.headset,
                                color: Colors.white70,
                                size: 17,
                              ),
                              Text(
                                '${NumberUtils.amountConversion(Random().nextInt(10000000))}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        d.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

void playSongs(PlaySongsModel model, int index, List<NewSongResult> newSong,
    BuildContext context) {
  List<SheetDetailsPlaylistTrack> list = [];
  newSong[index].song.like =
      Application.loveList.indexOf('${newSong[index].song.id}') != -1;
  list.add(newSong[index].song);
  model.playSongs(
    list,
    index: 0,
  );
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PlayBody()),
  );
}
