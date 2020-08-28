import 'package:flutter/material.dart';
import 'package:flutter_chat_app/locale/AppLocalizations.dart';
import 'package:flutter_chat_app/providers/ChatDataProvider.dart';
import 'package:flutter_chat_app/providers/ContactProvider.dart';
import 'package:flutter_chat_app/providers/Countries.dart';
import 'package:flutter_chat_app/providers/LocationProvider.dart';
import 'package:flutter_chat_app/providers/NetworkProvider.dart';
import 'package:flutter_chat_app/providers/PhoneAuthDataProvider.dart';
import 'package:flutter_chat_app/utils/Routes.dart';
import 'package:flutter_chat_app/views/splash/SplashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/AppLanguage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          ChangeNotifierProvider(
            create: (context) => LocationProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AppLanguage(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _baseTheme,
          localizationsDelegates: [
            const AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('es', ''),
          ],
          localeResolutionCallback:
              (Locale locale, Iterable<Locale> supportedLocales) {
            for (Locale supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode ||
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
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
