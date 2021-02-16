import 'package:flutter/cupertino.dart';
import 'package:neatease_app/constant/constants.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/util/sp_util.dart';

class PlayListModel with ChangeNotifier {
  List<SheetDetailsPlaylist> _selfCreatePlayList = []; // 我创建的歌单
  List<SheetDetailsPlaylist> _collectPlayList = []; // 收藏的歌单
  List<SheetDetailsPlaylist> _allPlayList = []; // 所有的歌单

  List<SheetDetailsPlaylist> get selfCreatePlayList => _selfCreatePlayList;

  List<SheetDetailsPlaylist> get collectPlayList => _collectPlayList;

  List<SheetDetailsPlaylist> get allPlayList => _allPlayList;

  void setPlayList(List<SheetDetailsPlaylist> value) {
    _allPlayList = value;
    _splitPlayList();
  }

  void _splitPlayList() {
    _selfCreatePlayList =
        _allPlayList.where((p) => p.userId == SpUtil.getInt(USER_ID)).toList();
    _collectPlayList =
        _allPlayList.where((p) => p.userId != SpUtil.getInt(USER_ID)).toList();
    notifyListeners();
  }

  void addPlayListTrack(SheetDetailsPlaylistTrack track, int index) {
    NetUtils()
        .addPlaylistTracks('add', _selfCreatePlayList[index].id, '${track.id}');
    _selfCreatePlayList[index].trackCount++;
    notifyListeners();
  }

  void addPlayList(SheetDetailsPlaylist playlist) {
    _allPlayList.add(playlist);
    _splitPlayList();
  }

  Future<bool> delPlayList(SheetDetailsPlaylist playlist) async {
    //判断歌单所有权：个人删除，非个人取消关注
    var result = playlist.userId == Constants.userId
        ? NetUtils().delPlayList(playlist.id)
        : NetUtils().subPlaylist(false, playlist.id);
    _allPlayList.remove(playlist);
    _splitPlayList();
    return result;
  }

  Future<bool> getSelfPlaylistData(id) async {
    var result = await NetUtils().getUserPlayList(id);
    setPlayList(result.playlist);
    return true;
  }
}
