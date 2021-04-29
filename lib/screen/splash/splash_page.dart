import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neatease_app/provider/user_model.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  UserModel _userModel;

  @override
  void initState() {
    super.initState();
    _userModel = Provider.of<UserModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        startHome();
      }
    });
  }

  startHome() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {
      _userModel.loginAuto(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: ScreenUtil().screenWidth,
        child: Image.asset(
          'assets/images/welcome.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
