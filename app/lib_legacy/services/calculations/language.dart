import 'package:flutter/cupertino.dart';

Future getLanguage(_prefs, context) async {
  final prefs = await _prefs;
  if (prefs.getString("language") == null) {
    await prefs.setString("language", "nl");
  }

  var languageApp = prefs.getString("language");


  return DefaultAssetBundle.of(context).loadString('assets/json/' + languageApp.toString() + '.json');
}