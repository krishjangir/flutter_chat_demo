import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;

class ProgressWidget extends StatelessWidget {

  const ProgressWidget({
    Key key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          height: 120.0,
          width: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  'Please wait!',
                  style: TextStyle(
                      color: Colors.black54, fontSize: 18.0),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
    );
  }
}
