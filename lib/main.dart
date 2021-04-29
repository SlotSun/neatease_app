import 'dart:convert';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:neatease_app/api/answer.dart';
import 'package:neatease_app/api/netease_cloud_music.dart';
import 'package:neatease_app/provider/play_list_model.dart';
import 'package:neatease_app/provider/play_songs_model.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:neatease_app/route/routes.dart';
import 'package:neatease_app/screen/splash/splash_page.dart';
import 'package:neatease_app/util/sp_util.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'constant/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FluroRouter router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  Application.setupLocator();
  //根据本地服务器接口进行网络调试：实际运行中不使用
  await _startServer();
  //异步实例化sp：怎么确保调用时已实例化完成
  await SpUtil.getInstance();
  Application.setLoveList();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<PlaySongsModel>(
      create: (_) => PlaySongsModel()..init(),
    ),
    ChangeNotifierProvider<UserModel>(
      create: (_) => UserModel(),
    ),
    ChangeNotifierProvider<PlayListModel>(
      create: (_) => PlayListModel(),
    ),
  ], child: MyApp()));
}

Future<HttpServer> _startServer({address = "localhost", int port = 3000}) {
  return HttpServer.bind(address, port, shared: true).then((server) {
    print("start listen at: http://$address:$port");
    server.listen((request) {
      _handleRequest(request);
    });
    return server;
  });
}

void _handleRequest(HttpRequest request) async {
  final answer = await cloudMusicApi(request.uri.path,
          parameter: request.uri.queryParameters, cookie: request.cookies)
      .catchError((e, s) async {
    print(e.toString());
    return Answer();
  });

  request.response.statusCode = answer.status;
  request.response.cookies.addAll(answer.cookie);
  request.response.write(json.encode(answer.body));
  request.response.close();

  print("request[${answer.status}] : ${request.uri}");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'netease_app',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        primaryColor: kBackgroundColor,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScreenUtilInit(
        //设计图size
        designSize: Size(375, 667),
        allowFontScaling: false,
        builder: () {
          return SplashPage();
        },
      ),
    );
  }
}
