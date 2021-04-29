class LoginStatus {
  Data data;

  LoginStatus({this.data});

  LoginStatus.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int code;
  Account account;
  Profile profile;

  Data({this.code, this.account, this.profile});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    account =
        json['account'] != null ? new Account.fromJson(json['account']) : null;
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.account != null) {
      data['account'] = this.account.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
}

class Account {
  int id;
  String userName;
  int type;
  int status;
  int whitelistAuthority;
  int createTime;
  int tokenVersion;
  int ban;
  int baoyueVersion;
  int donateVersion;
  int vipType;
  bool anonimousUser;
  bool paidFee;

  Account(
      {this.id,
      this.userName,
      this.type,
      this.status,
      this.whitelistAuthority,
      this.createTime,
      this.tokenVersion,
      this.ban,
      this.baoyueVersion,
      this.donateVersion,
      this.vipType,
      this.anonimousUser,
      this.paidFee});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    type = json['type'];
    status = json['status'];
    whitelistAuthority = json['whitelistAuthority'];
    createTime = json['createTime'];
    tokenVersion = json['tokenVersion'];
    ban = json['ban'];
    baoyueVersion = json['baoyueVersion'];
    donateVersion = json['donateVersion'];
    vipType = json['vipType'];
    anonimousUser = json['anonimousUser'];
    paidFee = json['paidFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['type'] = this.type;
    data['status'] = this.status;
    data['whitelistAuthority'] = this.whitelistAuthority;
    data['createTime'] = this.createTime;
    data['tokenVersion'] = this.tokenVersion;
    data['ban'] = this.ban;
    data['baoyueVersion'] = this.baoyueVersion;
    data['donateVersion'] = this.donateVersion;
    data['vipType'] = this.vipType;
    data['anonimousUser'] = this.anonimousUser;
    data['paidFee'] = this.paidFee;
    return data;
  }
}

class Profile {
  int userId;
  int userType;
  String nickname;
  int avatarImgId;
  String avatarUrl;
  int backgroundImgId;
  String backgroundUrl;
  String signature;
  int createTime;
  String userName;
  int accountType;
  String shortUserName;
  int birthday;
  int authority;
  int gender;
  int accountStatus;
  int province;
  int city;
  int authStatus;
  Null description;
  Null detailDescription;
  bool defaultAvatar;
  Null expertTags;
  Null experts;
  int djStatus;
  int locationStatus;
  int vipType;
  bool followed;
  bool mutual;
  bool authenticated;
  int lastLoginTime;
  String lastLoginIP;
  Null remarkName;
  int viptypeVersion;
  int authenticationTypes;
  Null avatarDetail;
  bool anchor;

  Profile(
      {this.userId,
      this.userType,
      this.nickname,
      this.avatarImgId,
      this.avatarUrl,
      this.backgroundImgId,
      this.backgroundUrl,
      this.signature,
      this.createTime,
      this.userName,
      this.accountType,
      this.shortUserName,
      this.birthday,
      this.authority,
      this.gender,
      this.accountStatus,
      this.province,
      this.city,
      this.authStatus,
      this.description,
      this.detailDescription,
      this.defaultAvatar,
      this.expertTags,
      this.experts,
      this.djStatus,
      this.locationStatus,
      this.vipType,
      this.followed,
      this.mutual,
      this.authenticated,
      this.lastLoginTime,
      this.lastLoginIP,
      this.remarkName,
      this.viptypeVersion,
      this.authenticationTypes,
      this.avatarDetail,
      this.anchor});

  Profile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userType = json['userType'];
    nickname = json['nickname'];
    avatarImgId = json['avatarImgId'];
    avatarUrl = json['avatarUrl'];
    backgroundImgId = json['backgroundImgId'];
    backgroundUrl = json['backgroundUrl'];
    signature = json['signature'];
    createTime = json['createTime'];
    userName = json['userName'];
    accountType = json['accountType'];
    shortUserName = json['shortUserName'];
    birthday = json['birthday'];
    authority = json['authority'];
    gender = json['gender'];
    accountStatus = json['accountStatus'];
    province = json['province'];
    city = json['city'];
    authStatus = json['authStatus'];
    description = json['description'];
    detailDescription = json['detailDescription'];
    defaultAvatar = json['defaultAvatar'];
    expertTags = json['expertTags'];
    experts = json['experts'];
    djStatus = json['djStatus'];
    locationStatus = json['locationStatus'];
    vipType = json['vipType'];
    followed = json['followed'];
    mutual = json['mutual'];
    authenticated = json['authenticated'];
    lastLoginTime = json['lastLoginTime'];
    lastLoginIP = json['lastLoginIP'];
    remarkName = json['remarkName'];
    viptypeVersion = json['viptypeVersion'];
    authenticationTypes = json['authenticationTypes'];
    avatarDetail = json['avatarDetail'];
    anchor = json['anchor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userType'] = this.userType;
    data['nickname'] = this.nickname;
    data['avatarImgId'] = this.avatarImgId;
    data['avatarUrl'] = this.avatarUrl;
    data['backgroundImgId'] = this.backgroundImgId;
    data['backgroundUrl'] = this.backgroundUrl;
    data['signature'] = this.signature;
    data['createTime'] = this.createTime;
    data['userName'] = this.userName;
    data['accountType'] = this.accountType;
    data['shortUserName'] = this.shortUserName;
    data['birthday'] = this.birthday;
    data['authority'] = this.authority;
    data['gender'] = this.gender;
    data['accountStatus'] = this.accountStatus;
    data['province'] = this.province;
    data['city'] = this.city;
    data['authStatus'] = this.authStatus;
    data['description'] = this.description;
    data['detailDescription'] = this.detailDescription;
    data['defaultAvatar'] = this.defaultAvatar;
    data['expertTags'] = this.expertTags;
    data['experts'] = this.experts;
    data['djStatus'] = this.djStatus;
    data['locationStatus'] = this.locationStatus;
    data['vipType'] = this.vipType;
    data['followed'] = this.followed;
    data['mutual'] = this.mutual;
    data['authenticated'] = this.authenticated;
    data['lastLoginTime'] = this.lastLoginTime;
    data['lastLoginIP'] = this.lastLoginIP;
    data['remarkName'] = this.remarkName;
    data['viptypeVersion'] = this.viptypeVersion;
    data['authenticationTypes'] = this.authenticationTypes;
    data['avatarDetail'] = this.avatarDetail;
    data['anchor'] = this.anchor;
    return data;
  }
}
