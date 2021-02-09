class LevelEntity {
  bool full;
  Data data;
  int code;

  LevelEntity({this.full, this.data, this.code});

  LevelEntity.fromJson(Map<String, dynamic> json) {
    full = json['full'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full'] = this.full;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Data {
  int userId;
  String info;
  double progress;
  int nextPlayCount;
  int nextLoginCount;
  int nowPlayCount;
  int nowLoginCount;
  int level;

  Data(
      {this.userId,
      this.info,
      this.progress,
      this.nextPlayCount,
      this.nextLoginCount,
      this.nowPlayCount,
      this.nowLoginCount,
      this.level});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    info = json['info'];
    progress = json['progress'];
    nextPlayCount = json['nextPlayCount'];
    nextLoginCount = json['nextLoginCount'];
    nowPlayCount = json['nowPlayCount'];
    nowLoginCount = json['nowLoginCount'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['info'] = this.info;
    data['progress'] = this.progress;
    data['nextPlayCount'] = this.nextPlayCount;
    data['nextLoginCount'] = this.nextLoginCount;
    data['nowPlayCount'] = this.nowPlayCount;
    data['nowLoginCount'] = this.nowLoginCount;
    data['level'] = this.level;
    return data;
  }
}
