import 'package:camera/camera.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/models/species.dart';
import 'dart:convert';
import 'package:fishfinder_app/screens/app/fishdex_pages/list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Widget build(BuildContext context) {

//    var langage = widget.language["fishdex"];

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
                          return new Center(child: new Text("loading"));
                        }

                        List<Species> species = parseJSON(snapshot.data.toString());
                        return species.isNotEmpty
                            ? new SpeciesList(species: species, uid: user.uid)
                            : new Center(child: new CircularProgressIndicator());
                      }
                  )
              )
          ),
        ],
      ),
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
