import 'package:fishfinder_app/screens/home/fishdex/fishdex.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io';

// @author Ian Ronk
// @class Species
const testDevice = 'ca-app-pub-8771008967458694~3342723025';


class PreviewSpeciesScreen extends StatefulWidget {
  final String single_species;
  final String uid;
  final String img;
//  int index;

  PreviewSpeciesScreen({Key key, @required this.single_species, this.index, this.uid, this.img}) : super(key: key);

  int index;

  @override
  _PreviewSpeciesScreenState createState() => _PreviewSpeciesScreenState();
}

class _PreviewSpeciesScreenState extends State<PreviewSpeciesScreen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? [testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );


  @override


  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  void initState() {
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
  }

  @override

  void dispose() {
    // TODO: implement dispose
    _interstitialAd?.dispose();

    super.dispose();
  }


  @override


  Widget build(BuildContext context) {
    final Species species = ModalRoute.of(context).settings.arguments;
    final int index = widget.index;

    Future currentUser(puid) async {
      var database = DatabaseService();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      database.updateSpeciesList(puid, int.parse(species.number));
    }

    return StreamBuilder(
        stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: widget.uid).snapshots(),
        builder: (BuildContext context, snapshot) {
          var friends_id = snapshot.data.documents[0]['friends_id'];

          if (!snapshot.hasData) {
            return new Center(child: new Text('Loading'));
          }

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(species.name),
                backgroundColor: Colors.lightBlueAccent,
                elevation: 0.0,
                actions: <Widget>[
                  Row(
                    children: <Widget>[
                      OutlineButton(
                        child: Row(
                          children: <Widget>[
                            Text('Add'),
                            SizedBox(width: 5),
                            Icon(Icons.add)
                          ],
                        ),
                        onPressed: ()  async {
                          if (friends_id.isNotEmpty) {
                            await DatabaseService().addSpeciesToFriends(friends_id, [widget.uid, index + 1]);
                          }

                          _interstitialAd?.dispose();
                          _interstitialAd = createInterstitialAd()..load();


                          await _interstitialAd?.show();

                          await DatabaseService().updateSpeciesList(widget.uid, index + 1);


                          // AdMob here

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
//                          Navigator.push(context, MaterialPageRoute(builder: (context) => FishDex(widget.cameras, uid, language)));
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10)
                    ],
                  )

                ],

              ),
              body: SingleChildScrollView(
                  child: Stack(
                      children: <Widget>[Column(
                        children: <Widget>[
                          Image.file(File(widget.img)),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.adb),
                                      SizedBox(width: 5),
                                      Text(species.latin_name, style: TextStyle(fontSize: 14))
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.assignment_turned_in),
                                      SizedBox(width: 5),
                                      Text(species.catch_state, style: TextStyle(fontSize: 14))
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.fastfood),
                                      SizedBox(width: 5),
                                      Text(species.edible, style: TextStyle(fontSize: 14))
                                    ],
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.equalizer),
                                      SizedBox(width: 5),
                                      Text(species.conservation_state, style: TextStyle(fontSize: 14))
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.wb_sunny),
                                      SizedBox(width: 5),
                                      Text(species.catch_time, style: TextStyle(fontSize: 14))
                                    ],
                                  ),
                                  SizedBox(width: 40),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.explore),
                                      SizedBox(width: 5),
                                      Text(species.length, style: TextStyle(fontSize: 14))
                                    ],
                                  )
                                ],
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text("General information", style: TextStyle(fontSize: 18))
                                  ),
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(species.general_information),
                                  )
                                ],
                              )
                          )


                        ],
                      ),
                      ]
                  )
              )
          );

        });


    }
  }