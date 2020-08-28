import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class AppLocalizations {

  static final AppLocalizations _singleton = new AppLocalizations._internal();
  AppLocalizations._internal();
  static AppLocalizations get instance => _singleton;

  Map<dynamic, dynamic> _localisedValues;

  Future<AppLocalizations> load(Locale locale) async {
    String jsonContent =
    await rootBundle.loadString('data/lang_${locale.languageCode}.json');
    _localisedValues = json.decode(jsonContent);
    return this;
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }
}


class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale)  {
    return AppLocalizations.instance.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
