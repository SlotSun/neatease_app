import 'package:neatease_app/entity/sheet_details_entity.dart';

class AlbumEntity {
  List<SheetDetailsPlaylistTrack> songs;
  int code;
  Album album;

  AlbumEntity({this.songs, this.code, this.album});

  AlbumEntity.fromJson(Map<String, dynamic> json) {
    if (json['songs'] != null) {
      songs = new List<SheetDetailsPlaylistTrack>();
      json['songs'].forEach((v) {
        songs.add(new SheetDetailsPlaylistTrack.fromJson(v));
      });
    }
    code = json['code'];
    album = json['album'] != null ? new Album.fromJson(json['album']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songs != null) {
      data['songs'] = this.songs.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    if (this.album != null) {
      data['album'] = this.album.toJson();
    }
    return data;
  }
}

class Album {
  List<Null> songs;
  bool paid;
  bool onSale;
  int mark;
  String description;
  int status;
  List<String> alias;
  List<Artists> artists;
  int copyrightId;
  int picId;
  Artist artist;
  int publishTime;
  String company;
  String briefDesc;
  String commentThreadId;
  int pic;
  String picUrl;
  String blurPicUrl;
  int companyId;
  String tags;
  String subType;
  String name;
  int id;
  String type;
  int size;
  String picIdStr;
  Info info;

  Album(
      {this.songs,
      this.paid,
      this.onSale,
      this.mark,
      this.description,
      this.status,
      this.alias,
      this.artists,
      this.copyrightId,
      this.picId,
      this.artist,
      this.publishTime,
      this.company,
      this.briefDesc,
      this.commentThreadId,
      this.pic,
      this.picUrl,
      this.blurPicUrl,
      this.companyId,
      this.tags,
      this.subType,
      this.name,
      this.id,
      this.type,
      this.size,
      this.picIdStr,
      this.info});

  Album.fromJson(Map<String, dynamic> json) {
    if (json['songs'] != null) {
      songs = new List<Null>();
    }
    paid = json['paid'];
    onSale = json['onSale'];
    mark = json['mark'];
    description = json['description'];
    status = json['status'];
    alias = json['alias'].cast<String>();
    if (json['artists'] != null) {
      artists = new List<Artists>();
      json['artists'].forEach((v) {
        artists.add(new Artists.fromJson(v));
      });
    }
    copyrightId = json['copyrightId'];
    picId = json['picId'];
    artist =
        json['artist'] != null ? new Artist.fromJson(json['artist']) : null;
    publishTime = json['publishTime'];
    company = json['company'];
    briefDesc = json['briefDesc'];
    commentThreadId = json['commentThreadId'];
    pic = json['pic'];
    picUrl = json['picUrl'];
    blurPicUrl = json['blurPicUrl'];
    companyId = json['companyId'];
    tags = json['tags'];
    subType = json['subType'];
    name = json['name'];
    id = json['id'];
    type = json['type'];
    size = json['size'];
    picIdStr = json['picId_str'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songs != null) {
      data['songs'] = [];
    }
    data['paid'] = this.paid;
    data['onSale'] = this.onSale;
    data['mark'] = this.mark;
    data['description'] = this.description;
    data['status'] = this.status;
    data['alias'] = this.alias;
    if (this.artists != null) {
      data['artists'] = this.artists.map((v) => v.toJson()).toList();
    }
    data['copyrightId'] = this.copyrightId;
    data['picId'] = this.picId;
    if (this.artist != null) {
      data['artist'] = this.artist.toJson();
    }
    data['publishTime'] = this.publishTime;
    data['company'] = this.company;
    data['briefDesc'] = this.briefDesc;
    data['commentThreadId'] = this.commentThreadId;
    data['pic'] = this.pic;
    data['picUrl'] = this.picUrl;
    data['blurPicUrl'] = this.blurPicUrl;
    data['companyId'] = this.companyId;
    data['tags'] = this.tags;
    data['subType'] = this.subType;
    data['name'] = this.name;
    data['id'] = this.id;
    data['type'] = this.type;
    data['size'] = this.size;
    data['picId_str'] = this.picIdStr;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}

class Artists {
  int img1v1Id;
  int topicPerson;
  List<Null> alias;
  int picId;
  String briefDesc;
  int musicSize;
  int albumSize;
  bool followed;
  String img1v1Url;
  String trans;
  String picUrl;
  String name;
  int id;
  String img1v1IdStr;

  Artists(
      {this.img1v1Id,
      this.topicPerson,
      this.alias,
      this.picId,
      this.briefDesc,
      this.musicSize,
      this.albumSize,
      this.followed,
      this.img1v1Url,
      this.trans,
      this.picUrl,
      this.name,
      this.id,
      this.img1v1IdStr});

  Artists.fromJson(Map<String, dynamic> json) {
    img1v1Id = json['img1v1Id'];
    topicPerson = json['topicPerson'];
    if (json['alias'] != null) {
      alias = new List<Null>();
    }
    picId = json['picId'];
    briefDesc = json['briefDesc'];
    musicSize = json['musicSize'];
    albumSize = json['albumSize'];
    followed = json['followed'];
    img1v1Url = json['img1v1Url'];
    trans = json['trans'];
    picUrl = json['picUrl'];
    name = json['name'];
    id = json['id'];
    img1v1IdStr = json['img1v1Id_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img1v1Id'] = this.img1v1Id;
    data['topicPerson'] = this.topicPerson;
    if (this.alias != null) {
      data['alias'] = [];
    }
    data['picId'] = this.picId;
    data['briefDesc'] = this.briefDesc;
    data['musicSize'] = this.musicSize;
    data['albumSize'] = this.albumSize;
    data['followed'] = this.followed;
    data['img1v1Url'] = this.img1v1Url;
    data['trans'] = this.trans;
    data['picUrl'] = this.picUrl;
    data['name'] = this.name;
    data['id'] = this.id;
    data['img1v1Id_str'] = this.img1v1IdStr;
    return data;
  }
}

class Artist {
  int img1v1Id;
  int topicPerson;
  List<String> alias;
  int picId;
  String briefDesc;
  int musicSize;
  int albumSize;
  bool followed;
  String img1v1Url;
  String trans;
  String picUrl;
  String name;
  int id;
  String picIdStr;
  String img1v1IdStr;

  Artist(
      {this.img1v1Id,
      this.topicPerson,
      this.alias,
      this.picId,
      this.briefDesc,
      this.musicSize,
      this.albumSize,
      this.followed,
      this.img1v1Url,
      this.trans,
      this.picUrl,
      this.name,
      this.id,
      this.picIdStr,
      this.img1v1IdStr});

  Artist.fromJson(Map<String, dynamic> json) {
    img1v1Id = json['img1v1Id'];
    topicPerson = json['topicPerson'];
    alias = json['alias'].cast<String>();
    picId = json['picId'];
    briefDesc = json['briefDesc'];
    musicSize = json['musicSize'];
    albumSize = json['albumSize'];
    followed = json['followed'];
    img1v1Url = json['img1v1Url'];
    trans = json['trans'];
    picUrl = json['picUrl'];
    name = json['name'];
    id = json['id'];
    picIdStr = json['picId_str'];
    img1v1IdStr = json['img1v1Id_str'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img1v1Id'] = this.img1v1Id;
    data['topicPerson'] = this.topicPerson;
    data['alias'] = this.alias;
    data['picId'] = this.picId;
    data['briefDesc'] = this.briefDesc;
    data['musicSize'] = this.musicSize;
    data['albumSize'] = this.albumSize;
    data['followed'] = this.followed;
    data['img1v1Url'] = this.img1v1Url;
    data['trans'] = this.trans;
    data['picUrl'] = this.picUrl;
    data['name'] = this.name;
    data['id'] = this.id;
    data['picId_str'] = this.picIdStr;
    data['img1v1Id_str'] = this.img1v1IdStr;
    return data;
  }
}

class Info {
  CommentThread commentThread;
  Null latestLikedUsers;
  bool liked;
  Null comments;
  int resourceType;
  int resourceId;
  int commentCount;
  int likedCount;
  int shareCount;
  String threadId;

  Info(
      {this.commentThread,
      this.latestLikedUsers,
      this.liked,
      this.comments,
      this.resourceType,
      this.resourceId,
      this.commentCount,
      this.likedCount,
      this.shareCount,
      this.threadId});

  Info.fromJson(Map<String, dynamic> json) {
    commentThread = json['commentThread'] != null
        ? new CommentThread.fromJson(json['commentThread'])
        : null;
    latestLikedUsers = json['latestLikedUsers'];
    liked = json['liked'];
    comments = json['comments'];
    resourceType = json['resourceType'];
    resourceId = json['resourceId'];
    commentCount = json['commentCount'];
    likedCount = json['likedCount'];
    shareCount = json['shareCount'];
    threadId = json['threadId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commentThread != null) {
      data['commentThread'] = this.commentThread.toJson();
    }
    data['latestLikedUsers'] = this.latestLikedUsers;
    data['liked'] = this.liked;
    data['comments'] = this.comments;
    data['resourceType'] = this.resourceType;
    data['resourceId'] = this.resourceId;
    data['commentCount'] = this.commentCount;
    data['likedCount'] = this.likedCount;
    data['shareCount'] = this.shareCount;
    data['threadId'] = this.threadId;
    return data;
  }
}

class CommentThread {
  String id;
  ResourceInfo resourceInfo;
  int resourceType;
  int commentCount;
  int likedCount;
  int shareCount;
  int hotCount;
  Null latestLikedUsers;
  int resourceId;
  int resourceOwnerId;
  String resourceTitle;

  CommentThread(
      {this.id,
      this.resourceInfo,
      this.resourceType,
      this.commentCount,
      this.likedCount,
      this.shareCount,
      this.hotCount,
      this.latestLikedUsers,
      this.resourceId,
      this.resourceOwnerId,
      this.resourceTitle});

  CommentThread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resourceInfo = json['resourceInfo'] != null
        ? new ResourceInfo.fromJson(json['resourceInfo'])
        : null;
    resourceType = json['resourceType'];
    commentCount = json['commentCount'];
    likedCount = json['likedCount'];
    shareCount = json['shareCount'];
    hotCount = json['hotCount'];
    latestLikedUsers = json['latestLikedUsers'];
    resourceId = json['resourceId'];
    resourceOwnerId = json['resourceOwnerId'];
    resourceTitle = json['resourceTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.resourceInfo != null) {
      data['resourceInfo'] = this.resourceInfo.toJson();
    }
    data['resourceType'] = this.resourceType;
    data['commentCount'] = this.commentCount;
    data['likedCount'] = this.likedCount;
    data['shareCount'] = this.shareCount;
    data['hotCount'] = this.hotCount;
    data['latestLikedUsers'] = this.latestLikedUsers;
    data['resourceId'] = this.resourceId;
    data['resourceOwnerId'] = this.resourceOwnerId;
    data['resourceTitle'] = this.resourceTitle;
    return data;
  }
}

class ResourceInfo {
  int id;
  int userId;
  String name;
  String imgUrl;
  Null creator;
  Null encodedId;
  Null subTitle;
  Null webUrl;

  ResourceInfo(
      {this.id,
      this.userId,
      this.name,
      this.imgUrl,
      this.creator,
      this.encodedId,
      this.subTitle,
      this.webUrl});

  ResourceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    imgUrl = json['imgUrl'];
    creator = json['creator'];
    encodedId = json['encodedId'];
    subTitle = json['subTitle'];
    webUrl = json['webUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['creator'] = this.creator;
    data['encodedId'] = this.encodedId;
    data['subTitle'] = this.subTitle;
    data['webUrl'] = this.webUrl;
    return data;
  }
}
