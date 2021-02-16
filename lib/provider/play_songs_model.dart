import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/entity/sheet_details_entity.dart';
import 'package:neatease_app/util/net_util.dart';

class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  List<SheetDetailsPlaylistTrack> _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;

  List<SheetDetailsPlaylistTrack> get allSongs => _songs;
  SheetDetailsPlaylistTrack get curSong => _songs[curIndex];
  Stream<String> get curPositionStream => _curPositionController.stream;
  AudioPlayerState get curState => _curState;

  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // 播放状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;

      /// 先做顺序播放
      if (state == AudioPlayerState.COMPLETED) {
        nextPlay();
      }
      // 其实也只有在播放状态更新时才需要通知。
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
    });
    // 当前播放进度监听
    _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      sinkProgress(p.inMilliseconds > curSongDuration.inMilliseconds
          ? curSongDuration.inMilliseconds
          : p.inMilliseconds);
    });
  }

  // 歌曲进度
  void sinkProgress(int m) {
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }

  // 播放一首歌
  void playSong(SheetDetailsPlaylistTrack song) {
    _songs.insert(curIndex, song);
    play();
  }

  // 播放很多歌
  void playSongs(List<SheetDetailsPlaylistTrack> songs, {int index}) {
    this._songs = songs;
    if (index != null) curIndex = index;
    play();
  }

  // 添加歌曲
  void addSongs(List<SheetDetailsPlaylistTrack> songs) {
    this._songs.addAll(songs);
  }

  /// 播放
  void play() async {
    var songId = this._songs[curIndex].id;
    var url = await NetUtils().getSongUrl(songId);

    _audioPlayer.play(url);
    // saveCurSong();
  }

  /// 暂停、恢复
  void togglePlay() {
    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      resumePlay();
    } else {
      pausePlay();
    }
  }

  // 暂停
  void pausePlay() {
    _audioPlayer.pause();
  }

  /// 跳转到固定时间
  void seekPlay(int milliseconds) {
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    resumePlay();
  }

  /// 恢复播放
  void resumePlay() {
    _audioPlayer.resume();
  }

  /// 下一首
  void nextPlay() {
    if (curIndex >= _songs.length - 1) {
      curIndex = 0;
    } else {
      curIndex++;
    }
    play();
  }

  void prePlay() {
    if (curIndex <= 0) {
      curIndex = _songs.length - 1;
    } else {
      curIndex--;
    }
    play();
  }

  //从当前播放列表删除歌曲
  void delSong(index) {
    allSongs.removeAt(index);
    notifyListeners();
  }

  // 保存当前歌曲到本地
  // void saveCurSong(){
  //   Application.sp.remove('playing_songs');
  //   Application.sp.setStringList('playing_songs', _songs.map((s) => FluroConvertUtils.object2string(s)).toList());
  //   Application.sp.setInt('playing_index', curIndex);
  // }

  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }
}
