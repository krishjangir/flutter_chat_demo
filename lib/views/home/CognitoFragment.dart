import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/aws/ConfirmationScreen.dart';
import 'package:flutter_chat_app/aws/LoginScreen.dart';
import 'package:flutter_chat_app/aws/SecureCounterScreen.dart';
import 'package:flutter_chat_app/aws/SignUpScreen.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;

class CognitoFragment extends StatefulWidget {
  @override
  _CognitoFragmentState createState() => _CognitoFragmentState();
}

class _CognitoFragmentState extends State<CognitoFragment> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor:AppColors.colorWhite ,
        iconTheme:IconThemeData(color: AppColors.colorPrimary),
        title: Text("Cognito", style: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding:
              new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Sign Up',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SignUpScreen()),
                  );
                },
                color: AppColors.colorPrimary,
              ),
            ),
            new Container(
              padding:
              new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Confirm Account',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ConfirmationScreen()),
                  );
                },
                color: AppColors.colorPrimary,
              ),
            ),
            new Container(
              padding:
              new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Login',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new LoginScreen()),
                  );
                },
                color:AppColors.colorPrimary,
              ),
            ),
            new Container(
              padding:
              new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(
                  'Secure Counter',
                  style: new TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SecureCounterScreen()),
                  );
                },
                color:AppColors.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
