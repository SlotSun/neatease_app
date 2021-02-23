class SingerMV {
  List<Mvs> mvs;
  int time;
  bool hasMore;
  int code;

  SingerMV({this.mvs, this.time, this.hasMore, this.code});

  SingerMV.fromJson(Map<String, dynamic> json) {
    if (json['mvs'] != null) {
      mvs = new List<Mvs>();
      json['mvs'].forEach((v) {
        mvs.add(new Mvs.fromJson(v));
      });
    }
    time = json['time'];
    hasMore = json['hasMore'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mvs != null) {
      data['mvs'] = this.mvs.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    data['hasMore'] = this.hasMore;
    data['code'] = this.code;
    return data;
  }
}

class Mvs {
  int id;
  String name;
  int status;
  String imgurl;
  String imgurl16v9;
  Artist artist;
  String artistName;
  int duration;
  int playCount;
  String publishTime;
  bool subed;

  Mvs(
      {this.id,
      this.name,
      this.status,
      this.imgurl,
      this.imgurl16v9,
      this.artist,
      this.artistName,
      this.duration,
      this.playCount,
      this.publishTime,
      this.subed});

  Mvs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    imgurl = json['imgurl'];
    imgurl16v9 = json['imgurl16v9'];
    artist =
        json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    artistName = json['artistName'];
    duration = json['duration'];
    playCount = json['playCount'];
    publishTime = json['publishTime'];
    subed = json['subed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['imgurl'] = this.imgurl;
    data['imgurl16v9'] = this.imgurl16v9;
    if (this.artist != null) {
      data['artist'] = this.artist.toJson();
    }
    data['artistName'] = this.artistName;
    data['duration'] = this.duration;
    data['playCount'] = this.playCount;
    data['publishTime'] = this.publishTime;
    data['subed'] = this.subed;
    return data;
  }
}

class Artist {
  int img1v1Id;
  int topicPerson;
  List<Null> alias;
  int musicSize;
  int albumSize;
  String picUrl;
  String img1v1Url;
  String trans;
  String briefDesc;
  int picId;
  String name;
  int id;
  String img1v1IdStr;

  Artist(
      {this.img1v1Id,
      this.topicPerson,
      this.alias,
      this.musicSize,
      this.albumSize,
      this.picUrl,
      this.img1v1Url,
      this.trans,
      this.briefDesc,
      this.picId,
      this.name,
      this.id,
      this.img1v1IdStr});

  Artist.fromJson(Map<String, dynamic> json) {
    img1v1Id = json['img1v1Id'];
    topicPerson = json['topicPerson'];
    if (json['alias'] != null) {
      alias = new List<Null>();
    }
    musicSize = json['musicSize'];
    albumSize = json['albumSize'];
    picUrl = json['picUrl'];
    img1v1Url = json['img1v1Url'];
    trans = json['trans'];
    briefDesc = json['briefDesc'];
    picId = json['picId'];
    name = json['name'];
    id = json['id'];
    img1v1IdStr = json['img1v1Id_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img1v1Id'] = this.img1v1Id;
    data['topicPerson'] = this.topicPerson;
    if (this.alias != null) {
      data['alias'] = new List();
    }
    data['musicSize'] = this.musicSize;
    data['albumSize'] = this.albumSize;
    data['picUrl'] = this.picUrl;
    data['img1v1Url'] = this.img1v1Url;
    data['trans'] = this.trans;
    data['briefDesc'] = this.briefDesc;
    data['picId'] = this.picId;
    data['name'] = this.name;
    data['id'] = this.id;
    data['img1v1Id_str'] = this.img1v1IdStr;
    return data;
  }
}
