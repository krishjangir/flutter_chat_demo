import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Images.dart' as AppImages;
import 'package:intl/intl.dart';

import 'FullPhoto.dart';

class MessageRow extends StatelessWidget {
  final ChatDataProvider chatDataProvider;
  final int index;
  final DocumentSnapshot document;
  final String peerAvatar;

  MessageRow({@required this.index, @required this.document,@required this.chatDataProvider,@required this.peerAvatar});

  @override
  Widget build(BuildContext context) {
    if (document['idFrom'] == chatDataProvider.userId) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: AppColors.colorWhite),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            decoration: BoxDecoration(
                color: AppColors.receiveTextBg,
                borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(
                bottom: chatDataProvider.isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : document['type'] == 1
          // Image
              ? Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.colorPrimary),
                    ),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(70.0),
                    decoration: BoxDecoration(
                      color: AppColors.receiveTextBg,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      AppImages.img_user_ph,
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: chatDataProvider.isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
          // Sticker
              : Container(
            child: Image.asset(
              'assets/gifs/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: chatDataProvider.isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[chatDataProvider.isLastMessageLeft(index)
                  ? Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.colorPrimary),
                    ),
                    width: 35.0,
                    height: 35.0,
                    padding: EdgeInsets.all(10.0),
                  ),
                  imageUrl: peerAvatar,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              )
                  : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimary,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : document['type'] == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.colorPrimary),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: AppColors.colorPrimary,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Material(
                              child: Image.asset(
                                AppImages.img_user_ph,
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullPhoto(
                                  url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(
                  child: Image.asset(
                    'assets/gifs/${document['content']}.gif',
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.only(
                      bottom: chatDataProvider.isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
              ],
            ),

            // Time
            chatDataProvider.isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: AppColors.colorPrimary,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}