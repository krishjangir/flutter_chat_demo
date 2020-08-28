import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/customwidgets/ProgressWidget.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/views/chat/Chat.dart';
import 'package:provider/provider.dart';

class ChatsFragment extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsFragment>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // List
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: ProgressWidget());
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 40, left: 10, right: 10),
                    itemBuilder: (context, index) =>
                        buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),

          // Loading
          Positioned(
            child: isLoading ? const ProgressWidget() : Container(),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == currentUserId) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorPrimary),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: AppColors.colorPrimary,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Nickname: ${document['nickname']}',
                          style: TextStyle(color: AppColors.colorWhite),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'About me: ${document['aboutMe'] ?? 'Not available'}',
                          style: TextStyle(color: AppColors.colorWhite),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document['id'],
                          peerAvatar: document['photoUrl'],
                        )));
          },
          color: AppColors.colorPrimary,
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  //getUserId method
  getUserId() async {
    final String userId =await Provider.of<ChatDataProvider>(context, listen: false).getUserId();
    setState(() {
      currentUserId =  userId;
    });
  }
}
