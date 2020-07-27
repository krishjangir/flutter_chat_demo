import 'package:flutter/material.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/providers/ContactProvider.dart';
import 'package:flutter_chat_app/providers/Countries.dart';
import 'package:flutter_chat_app/providers/NetworkProvider.dart';
import 'package:flutter_chat_app/providers/PhoneAuthDataProvider.dart';
import 'package:flutter_chat_app/utils/Routes.dart';
import 'package:flutter_chat_app/views/splash/SplashScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => NetworkProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ContactProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => CountryProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PhoneAuthDataProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ChatDataProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _baseTheme,
          home: SplashScreen(),
          routes: routes,
        ));
  }

//App Theme
  ThemeData _baseTheme = ThemeData(
    fontFamily: "Neusa Next Std",
    canvasColor: Colors.transparent,
    hintColor: const Color(0xFF515C6F),
    cursorColor: const Color(0xFFFF6969),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: const Color(0xFF515C6F)),
      labelStyle: TextStyle(color: const Color(0xFF515C6F)),
    ),
  );
}
