import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/firebase/auth.dart';
import 'package:flutter_chat_app/locale/AppLocalizations.dart';
import 'package:flutter_chat_app/providers/AppLanguage.dart';
import 'package:flutter_chat_app/providers/LocationProvider.dart';
import 'package:flutter_chat_app/views/contacts/Contacts.dart';
import 'package:flutter_chat_app/views/login/AuthPhoneScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:flutter_chat_app/utils/PrefKey.dart' as PrefKey;

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: null,
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerAboutMe;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString(PrefKey.USER_ID) ?? '';
    nickname = prefs.getString(PrefKey.USER_NAME) ?? '';
    aboutMe = prefs.getString(PrefKey.USER_ABOUT_ME) ?? '';
    photoUrl = prefs.getString(PrefKey.USER_PROFILE_PIC) ?? '';

    controllerNickname = TextEditingController(text: nickname);
    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance.collection('users').document(id).updateData({
            'nickname': nickname,
            'aboutMe': aboutMe,
            'photoUrl': photoUrl
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleLogOut() {
    prefs.clear();
    FireBase.auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PhoneAuthGetPhone()));
  }

  void handleContacts() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Contacts()));
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance.collection('users').document(id).updateData({
      'nickname': nickname,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl
    }).then((data) async {
      await prefs.setString(PrefKey.USER_NAME, nickname);
      await prefs.setString(PrefKey.USER_ABOUT_ME, aboutMe);
      await prefs.setString(PrefKey.USER_PROFILE_PIC, photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    /* final locationProvider = Provider.of<LocationProvider>(context);
    locationProvider.getLocation();
    locationProvider.getLocationAddress();*/
    var appLanguage = Provider.of<AppLanguage>(context);

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Avatar
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                              ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.colorPrimary),
                                      ),
                                      width: 90.0,
                                      height: 90.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: photoUrl,
                                    width: 90.0,
                                    height: 90.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45.0)),
                                  clipBehavior: Clip.hardEdge,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 90.0,
                                  color: AppColors.colorPrimary,
                                ))
                          : Material(
                              child: Image.file(
                                avatarImageFile,
                                width: 90.0,
                                height: 90.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: AppColors.colorPrimary,
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.only(left: 60.0, top: 60),
                        splashColor: Colors.transparent,
                        highlightColor: AppColors.colorPrimary,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.only(
                    left: 20.0, top: 40, right: 20.0, bottom: 20),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    child: Text(
                      'Nickname',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary),
                    ),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: AppColors.colorPrimary),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'john',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: AppColors.colorPrimary),
                        ),
                        controller: controllerNickname,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickname,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, right: 30.0),
                  ),

                  // About me
                  Container(
                    child: Text(
                      'About me',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: AppColors.colorPrimary),
                    ),
                    margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                  ),
                  Container(
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: AppColors.colorPrimary),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Busy',
                          contentPadding: EdgeInsets.all(5.0),
                          hintStyle: TextStyle(color: AppColors.colorPrimary),
                        ),
                        controller: controllerAboutMe,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                    margin: EdgeInsets.only(left: 5.0, right: 30.0),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              /*  Container(
                child: Text(
                  '${locationProvider.currentLocationAddress.toString()} Location: Lat : ${locationProvider.currentLocation?.latitude}, Long : ${locationProvider.currentLocation?.longitude}',
                  style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: AppColors.colorPrimary),
                ),
                margin: EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
              ),*/

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.instance.text('welcome'),
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    AppLocalizations.instance.text('thank_you'),
                    style: TextStyle(fontSize: 32),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          appLanguage.changeLanguage(Locale("en"));
                        },
                        child: Text('English'),
                      ),
                      RaisedButton(
                        onPressed: () {
                          appLanguage.changeLanguage(Locale("hi"));
                        },
                        child: Text('हिन्दी'),
                      )
                    ],
                  )
                ],
              ),
              // Button
              Container(
                child: FlatButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'UPDATE',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: AppColors.colorPrimary,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 30.0),
              ),

              // Button
              Container(
                child: FlatButton(
                  onPressed: handleLogOut,
                  child: Text(
                    'LogOut',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: AppColors.colorPrimary,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 20.0),
              ),
              // Button
              Container(
                child: FlatButton(
                  onPressed: handleContacts,
                  child: Text(
                    'Contacts',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: AppColors.colorPrimary,
                  highlightColor: Color(0xff8d93a0),
                  splashColor: Colors.transparent,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 15, left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.colorPrimary)),
                  ),
                  color: Colors.white.withOpacity(0.8),
                )
              : Container(),
        ),
      ],
    );
  }
}
