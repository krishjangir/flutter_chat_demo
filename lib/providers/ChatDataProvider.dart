import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, VoidCallback;
import 'package:flutter/widgets.dart'
    show BuildContext, Curves, FocusNode, Navigator, ScrollController, TextEditingController;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_app/utils/PrefKey.dart' as PrefKey;

enum ChatState {
  MessageSending,
  MessageSent,
  MessageFailed,
  Error,
}

class ChatDataProvider with ChangeNotifier {
  VoidCallback onMessageSending, onMessageSent, onMessageFailed, onError;

  //Controllers
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _listScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  //variables
  bool _loading = false;
  ChatState _status;
  String _message;
  String _userId;
  String _peerId;
  String _groupChatId;
  bool _isShowSticker= false;
  var _listMessage;
  SharedPreferences myPrefs;

  //set listeners
  setMethods(
      {VoidCallback onError,
      VoidCallback onMessageSending,
      VoidCallback onMessageSent,
      VoidCallback onMessageFailed}) {
    this.onMessageSending = onMessageSending;
    this.onMessageSent = onMessageSent;
    this.onMessageFailed = onMessageFailed;
    this.onError = onError;
  }

  //ChatStatusMessage getter outside
  get message => _message;

  //ChatStatusMessage setter outside
  set message(String value) {
    _message = value;
    notifyListeners();
  }

  //ChatStatus getter outside
  ChatState get status => _status;

  //ChatStatus setter outside
  set status(ChatState value) {
    _status = value;
    notifyListeners();
  }

  //textMessageController getter
  TextEditingController get textMessageController => _textMessageController;

  //focusNode getter
  FocusNode  get focusNode => _focusNode;

  //listScrollController getter
  ScrollController get listScrollController => _listScrollController;

  //loading getter
  bool get loading => _loading;

  //loading setter
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  //user id getter
  get userId => _userId;

  //user id setter
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  //peerId getter
  get peerId => _peerId;

  //peerId setter
  set peerId(String value) {
    _peerId = value;
    notifyListeners();
  }

  //groupChatId getter
  get groupChatId => _groupChatId;

  //groupChatId setter
  set groupChatId(String value) {
    _groupChatId = value;
    notifyListeners();
  }

  //isShowSticker getter
  get isShowSticker => _isShowSticker;

  //isShowSticker setter
  set isShowSticker(bool value) {
    _isShowSticker = value;
    notifyListeners();
  }

  //listMessage getter
  get listMessage => _listMessage;

  //listMessage setter
  set listMessage(var document) {
    _listMessage = document;
    notifyListeners();
  }

  //send media message
  Future uploadFile(File imageFile) async {
    message = "Message sending";
    status = ChatState.MessageSending;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      String imageUrl = downloadUrl;
      onSendMessage(imageUrl, 1 /*, groupChatId, userId, peerId*/);
    }, onError: (err) {
      message = "Server Error";
      status = ChatState.Error;
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  //send message
  Future onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      _textMessageController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': userId,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      message = "Message sent";
      status = ChatState.MessageSent;
      loading = false;
      if (onMessageSent != null) onMessageSent();
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  //groupChatId
  Future readLocal(String peerID) async {
    myPrefs = await SharedPreferences.getInstance();
    userId = myPrefs.getString(PrefKey.USER_ID);
    peerId = peerID;
    if (userId.hashCode <= peerId.hashCode) {
      groupChatId = '$userId-$peerId';
    } else {
      groupChatId = '$peerId-$userId';
    }
    await Firestore.instance.collection('users').document(userId).updateData({'chattingWith': peerId});
    notifyListeners();
  }

  //getUser method
  Future<String> getUserId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final String _userId = myPrefs.getString(PrefKey.USER_ID);
    userId = _userId;
    return userId;
  }

  //backPress handle method
  Future<bool> onBackPress(BuildContext context) {
    if (isShowSticker) {
      isShowSticker = false;
    } else {
      Firestore.instance
          .collection('users')
          .document(userId)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  //get sticker method
  void getSticker() {
    // Hide keyboard when sticker appear
   focusNode.unfocus();
   isShowSticker = !isShowSticker;
  }

  //onFocusChange method
  void onFocusChange() {
    if (focusNode.hasFocus) {
      isShowSticker = false;
    }
  }

  //isLastMessageLeft handle method
  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] ==userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  //isLastMessageRight handle method
  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] !=userId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

}
