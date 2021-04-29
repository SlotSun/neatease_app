import 'package:neatease_app/entity/sheet_details_entity.dart';

class PlayHistoryEntity {
  List<PlayHistoryAlldata> allData;
  num code;

  PlayHistoryEntity({this.allData, this.code});

  PlayHistoryEntity.fromJson(Map<String, dynamic> json) {
    if (json['allData'] != null) {
      allData = new List<PlayHistoryAlldata>();
      (json['allData'] as List).forEach((v) {
        allData.add(new PlayHistoryAlldata.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allData != null) {
      data['allData'] = this.allData.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    return data;
  }
}

class PlayHistoryAlldata {
  SheetDetailsPlaylistTrack song;
  num playCount;
  num score;

  PlayHistoryAlldata({this.song, this.playCount, this.score});

  PlayHistoryAlldata.fromJson(Map<String, dynamic> json) {
    song = json['song'] != null
        ? new SheetDetailsPlaylistTrack.fromJson(json['song'])
        : null;
    playCount = json['playCount'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.song != null) {
      data['song'] = this.song.toJson();
    }
    data['playCount'] = this.playCount;
    data['score'] = this.score;
    return data;
  }
}
