import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/resource/Icons.dart' as Icons;

class SubmitButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String buttonText;

  SubmitButton({@required this.onPressed, @required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 50.0,
      margin: EdgeInsets.only(top: 30, right: 16),
      child: RaisedButton(
        onPressed: onPressed,
        elevation: 5,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.colorPrimary,
                  AppColors.colorPrimary
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 350.0, minHeight: 50.0),
            alignment: Alignment.center,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.centerRight,
                image: AssetImage(Icons.ic_arrow_right_red),
              ),
            ),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}