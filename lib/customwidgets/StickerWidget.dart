import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Gifs.dart' as AppGifs;

class StickerWidget extends StatelessWidget {
  final ChatDataProvider chatDataProvider;

  StickerWidget({@required this.chatDataProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi1', 2),
                child: Image.asset(
                  AppGifs.gif_mimi1,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi2', 2),
                child: Image.asset(
                  AppGifs.gif_mimi2,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi3', 2),
                child: Image.asset(
                  AppGifs.gif_mimi3,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi4', 2),
                child: Image.asset(
                  AppGifs.gif_mimi4,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi5', 2),
                child: Image.asset(
                  AppGifs.gif_mimi5,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi6', 2),
                child: Image.asset(
                  AppGifs.gif_mimi6,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi7', 2),
                child: Image.asset(
                  AppGifs.gif_mimi7,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi8', 2),
                child: Image.asset(
                  AppGifs.gif_mimi8,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => chatDataProvider.onSendMessage('mimi9', 2),
                child: Image.asset(
                  AppGifs.gif_mimi9,
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: AppColors.colorPrimary, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }
}