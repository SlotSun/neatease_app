import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:neatease_app/entity/mv_player_entity.dart';
import 'package:neatease_app/util/cache_image.dart';
import 'package:neatease_app/util/net_util.dart';
import 'package:neatease_app/widget/loading.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final int mvid;

  PlayVideo({@required this.mvid});

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController _controller;
  MvPlayerEntity _mvPlayerEntity;
  String url;
  int isLoading = 0;
  ChewieController chewieController;

  _PlayVideoState();

  //是否关注
  bool isFavorite = false;

  //切换源
  int selectSource = 0;

  @override
  void initState() {
    super.initState();
    initRoom();
  }

  Future<void> initRoom() async {
    NetUtils().getMvUrl(widget.mvid).then((value) => url = value).then((value) {
      _controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          chewieController = ChewieController(
            videoPlayerController: _controller,
            aspectRatio: 3 / 2, //宽高比
            autoPlay: false, //自动播放
            looping: false, //循环播放
          );
          setState(() {
            isLoading++;
          });
        });
    });
    NetUtils()
        .getMvPlayer(widget.mvid)
        .then((value) => _mvPlayerEntity = value)
        .then((value) {
      setState(() {
        isLoading++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading != 2) {
      return Scaffold(
        body: LoadingPage(),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          buildPlayer(),
          buildRoomInfo(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Widget buildPlayer() {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: _controller.value.initialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(
                  controller: chewieController,
                ),
              )
            : Container(),
      ),
    );
  }

  Widget buildRoomInfo() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400], width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10),
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageHelper.getImage(
              '${_mvPlayerEntity.data.cover}',
              height: 50,
            )),
        title: Text(_mvPlayerEntity.data.name),
        subtitle: Text(_mvPlayerEntity.data.artists.first.name),
        trailing: IconButton(
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.pink : Colors.grey[400],
            ),
            onPressed: favoriteOrCancel),
      ),
    );
  }

  void favoriteOrCancel() {
    setState(() {
      isFavorite = !isFavorite;
    });
    //读取关注列表
  }

  // Future<void> onDroChanged(int i) async {
  //   await player.reset();
  //   await player.setDataSource(urlB[i], autoPlay: true);
  // }

  // Widget buildPlayer() {
  //   var width = MediaQuery.of(context).size.width;
  //   return Container(
  //       color: Colors.black54,
  //       child: SafeArea(
  //         child: FijkView(
  //           width: width,
  //           height: 240,
  //           player: player,
  //           cover: Image.network(
  //             roomThumb,
  //           ).image,
  //           color: Colors.black,
  //           fit: FijkFit.fill,
  //         ),
  //       ));
  // }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    chewieController.dispose();
  }
}
