import 'package:neatease_app/entity/sheet_details_entity.dart';

class SingerSong {
  Artist artist;
  List<SheetDetailsPlaylistTrack> hotSongs;
  bool more;
  int code;

  SingerSong({this.artist, this.hotSongs, this.more, this.code});

  SingerSong.fromJson(Map<String, dynamic> json) {
    artist =
        json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    if (json['hotSongs'] != null) {
      hotSongs = new List<SheetDetailsPlaylistTrack>();
      json['hotSongs'].forEach((v) {
        hotSongs.add(new SheetDetailsPlaylistTrack.fromJson(v));
      });
    }
    more = json['more'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.artist != null) {
      data['artist'] = this.artist.toJson();
    }
    if (this.hotSongs != null) {
      data['hotSongs'] = this.hotSongs.map((v) => v.toJson()).toList();
    }
    data['more'] = this.more;
    data['code'] = this.code;
    return data;
  }
}

class Artist {
  int img1v1Id;
  int topicPerson;
  List<dynamic> alias;
  int musicSize;
  int albumSize;
  String briefDesc;
  int picId;
  bool followed;
  String img1v1Url;
  String trans;
  String picUrl;
  String name;
  int id;
  int publishTime;
  String picIdStr;
  String img1v1IdStr;
  int mvSize;

  Artist(
      {this.img1v1Id,
      this.topicPerson,
      this.alias,
      this.musicSize,
      this.albumSize,
      this.briefDesc,
      this.picId,
      this.followed,
      this.img1v1Url,
      this.trans,
      this.picUrl,
      this.name,
      this.id,
      this.publishTime,
      this.picIdStr,
      this.img1v1IdStr,
      this.mvSize});

  Artist.fromJson(Map<String, dynamic> json) {
    img1v1Id = json['img1v1Id'];
    topicPerson = json['topicPerson'];
    alias = json['alias'];
    musicSize = json['musicSize'];
    albumSize = json['albumSize'];
    briefDesc = json['briefDesc'];
    picId = json['picId'];
    followed = json['followed'];
    img1v1Url = json['img1v1Url'];
    trans = json['trans'];
    picUrl = json['picUrl'];
    name = json['name'];
    id = json['id'];
    publishTime = json['publishTime'];
    picIdStr = json['picId_str'];
    img1v1IdStr = json['img1v1Id_str'];
    mvSize = json['mvSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img1v1Id'] = this.img1v1Id;
    data['topicPerson'] = this.topicPerson;
    data['alias'] = this.alias;
    data['musicSize'] = this.musicSize;
    data['albumSize'] = this.albumSize;
    data['briefDesc'] = this.briefDesc;
    data['picId'] = this.picId;
    data['followed'] = this.followed;
    data['img1v1Url'] = this.img1v1Url;
    data['trans'] = this.trans;
    data['picUrl'] = this.picUrl;
    data['name'] = this.name;
    data['id'] = this.id;
    data['publishTime'] = this.publishTime;
    data['picId_str'] = this.picIdStr;
    data['img1v1Id_str'] = this.img1v1IdStr;
    data['mvSize'] = this.mvSize;
    return data;
  }
}
