import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_app/utils/PrefKey.dart' as PrefKey;
import 'package:flutter_chat_app/resource/Colors.dart' as AppColor;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      goNext();
    });
  }

  goNext() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final bool isLogin = myPrefs.getBool(PrefKey.IS_LOGGED_IN);

    if (isLogin != null) {
      isLogin
          ? Navigator.of(context).pushReplacementNamed('/HomeScreen')
          : Navigator.of(context).pushReplacementNamed('/LogInScreen');
    } else {
      Navigator.of(context).pushReplacementNamed('/LogInScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: AppColor.colorPrimary,
          )
        ],
      ),
    );
  }
}
