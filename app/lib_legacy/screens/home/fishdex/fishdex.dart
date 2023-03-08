import 'package:camera/camera.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/models/species.dart';
import 'dart:convert';
import 'package:fishfinder_app/screens/home/fishdex/list.dart';
import 'package:fishfinder_app/screens/home/camera/camerascreen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list.dart';

class FishDex extends StatefulWidget {
  final List<CameraDescription> cameras;

  FishDex(this.cameras);

  @override
  _FishDexState createState() => _FishDexState();
}

class _FishDexState extends State<FishDex> {
  @override

  List data;
  @override

  String languageFromSettings;

  String root_folder = '/data/user/0/machinelearningsolutions.fishfinder_app/app_flutter';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  Future getLanguage() async {
    final prefs = await _prefs;
    if (prefs.getString("language") == null) {
      await prefs.setString("language", "nl");
    }

    var languageApp = prefs.getString("language");


    return DefaultAssetBundle.of(context).loadString('assets/json/' + languageApp.toString() + '.json');
  }

  Widget build(BuildContext context) {

//    var language = widget.language["fishdex"];

    return FutureBuilder(
      future: getLanguage(),
      builder: (context, snapshot) {

        // Get the language and user
        Map<String, dynamic> language = jsonDecode(snapshot.data)["fishdex"];
        var user = Provider.of<User>(context);

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              new Container(
                  child: Center(
                      child: new FutureBuilder(
                          future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return new Center(child: new Text(language["loading"]));
                            }

                            List<Species> species = parseJSON(snapshot.data.toString());
                            return species.isNotEmpty
                                ? new SpeciesList(species: species, uid: user.uid, language: language)
                                : new Center(child: new CircularProgressIndicator());
                          }
                      )
                  )
              ),
            ],
          ),
        );
      },
    );
  }

  List<Species> parseJSON(String response) {
    if (response == null) {
      return [];
    }
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Species>((json) => new Species.fromJSON(json)).toList();
  }
}
