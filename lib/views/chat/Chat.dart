import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/customwidgets/FullPhoto.dart';
import 'package:flutter_chat_app/customwidgets/MessageRow.dart';
import 'package:flutter_chat_app/customwidgets/ProgressWidget.dart';
import 'package:flutter_chat_app/customwidgets/StickerWidget.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/providers/NetworkProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_app/utils/PrefKey.dart' as PrefKey;
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Images.dart' as AppImages;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  Chat({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        iconTheme: IconThemeData(color: AppColors.colorPrimary),
        title: Row(
          children: <Widget>[
            Material(
              child: peerAvatar != null
                  ? CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.colorPrimary),
                        ),
                        width: 40.0,
                        height: 40.0,
                        padding: EdgeInsets.all(10.0),
                      ),
                      imageUrl: peerAvatar,
                      width: 40.0,
                      height: 40.0,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: AppColors.colorPrimary,
                    ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              clipBehavior: Clip.hardEdge,
            ),
            SizedBox(width: 10),
            Column(children: <Widget>[
              Text(
                'Nickname',
                style: TextStyle(color: AppColors.colorPrimary),
              ),
              Text(
                'Online',
                style: TextStyle(color: AppColors.colorPrimary, fontSize: 12),
              )
            ]),
          ],
        ),
      ),
      body: ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  File imageFile;

  String id;
 // String groupChatId;
  bool isShowSticker;
  SharedPreferences prefs;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
   // groupChatId = '';
    isShowSticker = false;
    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  //read pref data method
  readLocal() async {
  /*  prefs = await SharedPreferences.getInstance();
    id = prefs.getString(PrefKey.USER_ID) ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    Provider.of<ChatDataProvider>(context, listen: false).groupChatId = groupChatId;
    Firestore.instance.collection('users').document(id).updateData({'chattingWith': peerId});*/

    Provider.of<ChatDataProvider>(context, listen: false).readLocal(peerId);

    setState(() {});
  }

  //get Sticker method
  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  //get image from gallery
  Future getImage(ChatDataProvider chatDataProvider) async {
    setState(() {
      isShowSticker = false;
    });
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (imageFile != null) {
      chatDataProvider.loading = true;
      chatDataProvider.uploadFile(imageFile);
    } else {
      chatDataProvider.loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatDataProvider =
        Provider.of<ChatDataProvider>(context, listen: false);
    final loader = chatDataProvider.loading;

    chatDataProvider.setMethods(
        onMessageSending: onMessageSending,
        onMessageSent: onMessageSent,
        onMessageFailed: onMessageFailed,
        onError: onError);

    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(chatDataProvider),

              // Sticker
              (isShowSticker
                  ? StickerWidget(chatDataProvider: chatDataProvider)
                  : Container()),

              // Input content
              buildInput(chatDataProvider),
            ],
          ),

          // Loading
          Positioned(
            child: loader ? const ProgressWidget() : Container(),
          )
        ],
      ),
      onWillPop: () => chatDataProvider.onBackPress(context),
    );
  }

  //Input message widgets
  Widget buildInput(ChatDataProvider chatDataProvider) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: () => getImage(chatDataProvider),
                color: AppColors.colorPrimary,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: AppColors.colorPrimary,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: AppColors.colorPrimary, fontSize: 15.0),
                controller: chatDataProvider.textMessageController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: AppColors.colorPrimary),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => chatDataProvider.onSendMessage(
                    chatDataProvider.textMessageController.text, 0),
                color: AppColors.colorPrimary,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: AppColors.colorPrimary, width: 0.5)),
          color: Colors.white),
    );
  }

  //Message List widget
  Widget buildListMessage(ChatDataProvider chatDataProvider) {
    return Flexible(
      child: chatDataProvider.groupChatId == ''
          ? Center(child: ProgressWidget())
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('messages')
                  .document(chatDataProvider.groupChatId)
                  .collection(chatDataProvider.groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(40)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: ProgressWidget());
                } else {
                  chatDataProvider.listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => MessageRow(
                        index: index,
                        document: snapshot.data.documents[index],
                        chatDataProvider: chatDataProvider,
                        peerAvatar: peerAvatar),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: chatDataProvider.listScrollController,
                  );
                }
              },
            ),
    );
  }

  //----------------  message callbacks ----------
  onMessageSending() {
    Fluttertoast.showToast(msg: "Posting");
  }

  onMessageSent() {
    Fluttertoast.showToast(msg: "Sent");
  }

  onMessageFailed() {
    Fluttertoast.showToast(msg: "Failed");
  }

  onError() {
    Fluttertoast.showToast(msg: "Error");
  }
}
