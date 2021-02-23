import 'package:neatease_app/entity/sheet_details_entity.dart';

class TodaySongEntity {
  num code;
  List<SheetDetailsPlaylistTrack> recommend;

  TodaySongEntity({this.code, this.recommend});

  TodaySongEntity.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['recommend'] != null) {
      recommend = new List<SheetDetailsPlaylistTrack>();
      (json['recommend'] as List).forEach((v) {
        recommend.add(new SheetDetailsPlaylistTrack.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.recommend != null) {
      data['recommend'] = this.recommend.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
