import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/customwidgets/ProgressWidget.dart';
import 'package:flutter_chat_app/views/login/SelectCountryScreen.dart';
import 'package:flutter_chat_app/views/login/OTPVerifyScreen.dart';
import 'package:flutter_chat_app/providers/Countries.dart';
import 'package:flutter_chat_app/providers/PhoneAuthDataProvider.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:provider/provider.dart';
import 'package:flutter_chat_app/customwidgets/widgets.dart';

class PhoneAuthGetPhone extends StatefulWidget {

  final String title = "Login";

  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  double _height, _width, _fixedPadding;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;
    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor:  AppColors.colorBackground,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: _getBody(countriesProvider),
              ),
            ),
            loader ? ProgressWidget() : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _getBody(CountryProvider countriesProvider) => Card(
        color: AppColors.colorPrimary,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          width: _width,
          child: countriesProvider.countries.length > 0
              ? _getColumnBody(countriesProvider)
              : Center(child: ProgressWidget()),
        ),
      );

  Widget _getColumnBody(CountryProvider countriesProvider) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title:
          Padding(
              padding: EdgeInsets.only(top: 40,bottom: 20),
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700))),

          Padding(
            padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
            child: SubTitle(text: 'Select your country'),
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: _fixedPadding, right: _fixedPadding),
              child: ShowSelectedCountry(
                country: countriesProvider.selectedCountry,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelectCountry()),
                  );
                },
              )),

          //  Subtitle for Enter your phone
          Padding(
            padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
            child: SubTitle(text: 'Enter your phone'),
          ),
          //  PhoneNumber TextFormFields
          Padding(
            padding: EdgeInsets.only(
                left: _fixedPadding,
                right: _fixedPadding,
                bottom: _fixedPadding),
            child: PhoneNumberField(
              controller:
                  Provider.of<PhoneAuthDataProvider>(context, listen: false)
                      .phoneNumberController,
              prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
            ),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: _fixedPadding),
              Icon(Icons.info, color: Colors.white, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'We will send ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: 'One Time Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: ' to this mobile number',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                ])),
              ),
              SizedBox(width: _fixedPadding),
            ],
          ),

          SizedBox(height: _fixedPadding * 1.5),
          RaisedButton(
            elevation: 16.0,
            onPressed: startPhoneAuth,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'SEND OTP',
                style: TextStyle(
                    color:  AppColors.colorPrimary, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
          SizedBox(height: _fixedPadding * 1.5),
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState.showSnackBar(snackBar);
  }


  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: countryProvider.selectedCountry.dialCode,
        onCodeSent: () {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              builder: (BuildContext context) => PhoneAuthVerify()));
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }
}
