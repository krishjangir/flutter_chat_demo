import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';

class NetworkProvider with ChangeNotifier {


  //Connection variable
  bool _isConnected = false;

  //Connection getter
  bool get Connected => _isConnected;

  //Connection setter
  set Connected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  //Check network Connection
  Future isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      Connected= true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Connected= true;
    }
    Connected= false;
  }
}
