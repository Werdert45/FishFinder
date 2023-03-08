import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/services/achievement_calc.dart';
import 'package:fishfinder_app/services/translations.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/models/achievements.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'dart:convert';

class Achievements extends StatelessWidget {
  final List<Species> species;
  final String language;
  Achievements({Key key, this.species, this.uid, this.language}) : super(key: key);

  String uid;

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/json/' + language + '.json'),
        builder: (context,snapshot) {
          var lang = snapshot.data;
          Map<String, dynamic> language = jsonDecode(snapshot.data)["home_page"];
          return new StreamBuilder(
              stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: uid).snapshots(),
              builder: (BuildContext context, snap) {
                var achievements_output = snap.data.documents[0]['achievements'];

                var species_list = snap.data.documents[0]['species'];

                checkAchievements(species_list, uid);

                if (!snapshot.hasData) {
                  return Center(child: new Text('Loading'));
                }
                return Container(
                  height: 240,
                  padding: EdgeInsets.only(right: 20),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.builder(
                      itemCount: 8,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        if (achievements_output[index]["achievement_" + (index + 1).toString()]) {
                          return new GradientCard(
                              gradient: goldLinearGradient,
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.account_balance, size: 40),
                                    SizedBox(height: 10),
                                    Text(language["achievement_" + (index + 1).toString()])
                                  ],
                                ),
                              )
                          );
                        }
                        else {
                          return new GradientCard(
                              gradient: linearGradient,
                              elevation: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.account_balance, size: 40),
                                    SizedBox(height: 10),
                                    Text(language["achievement_" + (index + 1).toString()])
                                  ],
                                ),
                              )
                          );
                        }



                      }
                  ),
                );
              }
          );
        }
    );


  }
}

