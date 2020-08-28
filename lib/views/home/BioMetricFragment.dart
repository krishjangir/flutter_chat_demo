import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/resource/Colors.dart' as AppColors;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

class BioMetricFragment extends StatefulWidget {
  @override
  _BioMetricFragmentState createState() => _BioMetricFragmentState();
}

class _BioMetricFragmentState extends State<BioMetricFragment> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _hasFingerPrintSupport = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBuimetricType = List<BiometricType>();

  Future<void> _getBiometricsSupport() async {
    bool hasFingerPrintSupport = false;
    try {
      hasFingerPrintSupport = await _localAuthentication.canCheckBiometrics;
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasFingerPrintSupport = hasFingerPrintSupport;
    });
  }

  Future<void> _getAvailableSupport() async {
    List<BiometricType> availableBuimetricType = List<BiometricType>();
    try {
      availableBuimetricType =
      await _localAuthentication.getAvailableBiometrics();
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _availableBuimetricType = availableBuimetricType;
    });
  }

  Future<void> _authenticateMe() async {
     bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing", // message for dialog
        useErrorDialogs: true,// show error in dialog
        stickyAuth: true,// native process
      );
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _authorizedOrNot = authenticated ? "Authorized" : "Not Authorized";
    });

     authenticated ?Fluttertoast.showToast(msg: "Authorized"):"";
  }

  @override
  void initState() {
    _getBiometricsSupport();
    _getAvailableSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor:AppColors.colorWhite ,
        iconTheme:IconThemeData(color: AppColors.colorPrimary),
        title: Text("BioMetric", style: TextStyle(color: AppColors.colorPrimary, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Has FingerPrint Support : $_hasFingerPrintSupport"),
            Text(
                "List of Biometrics Support: ${_availableBuimetricType.toString()}"),
            Text("Authorized : $_authorizedOrNot"),
            RaisedButton(
              child: Text("Authorize Now", style: TextStyle(color: AppColors.colorWhite, fontWeight: FontWeight.bold)),
              color: AppColors.colorPrimary,
              onPressed: _authenticateMe,
            ),
          ],
        ),
      ),
    );
  }
}
