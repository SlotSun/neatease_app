import 'package:flutter/material.dart';
import 'package:neatease_app/util/navigator_util.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startHome();
  }

  startHome() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      NavigatorUtil.goHomePage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Image.asset(
            'assets/images/welcome.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
