
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Images.dart' as AppImages;

import 'ChatsFragment.dart';
import 'SettingsFragment.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String currentUserId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        color: AppColors.colorTextActiveTab,
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 4,
          child: new Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar:null,
            body: new Container(
              child: new TabBarView(
                children: [
                  new Container(child: ChatsFragment()),
                  new Container(child: ChatsFragment()),
                  new Container(child: ChatsFragment()),
                  new Container(child: Settings())
                ],
              ),
            ),
            bottomNavigationBar: new TabBar(
              tabs: [
                new Container(
                    height: 64.0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Tab(icon: new Icon(Icons.chat, size: 30)),
                          new Container(
                            transform:
                            Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: new Text("Chats"),
                          ),
                        ])),
                new Container(
                    height: 64.0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Tab(icon: new Icon(Icons.question_answer, size: 30)),
                          new Container(
                            transform:
                            Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: new Text("Status"),
                          ),
                        ])),
                new Container(
                    height: 64.0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Tab(icon: new Icon(Icons.call, size: 30)),
                          new Container(
                            transform:
                            Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: new Text("Calls"),
                          ),
                        ])),

                new Container(
                    height: 64.0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Tab(icon: new Icon(Icons.settings, size: 30)),
                          new Container(
                            transform:
                            Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: new Text("Setting"),
                          ),
                        ])),
              ],
              labelColor: AppColors.colorTextActiveTab,
              unselectedLabelColor: AppColors.colorTextDeActiveTab,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.transparent,
            ),
            backgroundColor: AppColors.colorWhite,
          ),
        ));
  }
}
