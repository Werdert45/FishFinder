import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/models/friends_catch.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/home/fishdex/fishdex.dart';
import 'package:fishfinder_app/screens/home/homescreen/achievements.dart';
import 'package:fishfinder_app/screens/home/homescreen/friends.dart';
import 'package:fishfinder_app/screens/home/homescreen/history_search.dart';
import 'package:fishfinder_app/screens/home/homescreen/recentfriendsscroll.dart';
import 'package:fishfinder_app/services/backup.dart';
import 'package:fishfinder_app/services/calculations/ads.dart';
import 'package:fishfinder_app/services/calculations/language.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth.dart';
import 'package:fishfinder_app/screens/home/camera/camerascreen.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'settings.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/screens/home/homescreen/recentscroll.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_admob/firebase_admob.dart';

var testDevice = 'ca-app-pub-8771008967458694~3342723025';

// @author Ian Ronk
// @class DashboardPage

class DashboardPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  DashboardPage(this.cameras);



  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: [testDevice],
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;


  void initState() {
    FirebaseAdMob.instance.initialize(
        appId: BannerAd.testAdUnitId
    );
//    _bannerAd = createBannerAd()..load()..show();
    super.initState();

  }

  void dispose() {
    // TODO: implement dispose
    _bannerAd.dispose();
    super.dispose();
  }

  @override


  final AuthService _auth = AuthService();

  String languageFromSettings;

  String root_folder = '/data/user/0/machinelearningsolutions.fishfinder_app/app_flutter';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  Future checkSubscription() async {
    final prefs = await _prefs;
    
    if (prefs.getBool("premiumSubscription") == null) {
      await prefs.setBool("premiumSubscription", false);
    }

    return prefs.getBool("premiumSubscription");
  }



  Future dailyScansAmount() async {
    final prefs = await _prefs;

    if (prefs.getStringList("date") == null) {
      await prefs.setStringList("date", [DateFormat.y().format(DateTime.now()), DateFormat.M().format(DateTime.now()), DateFormat.d().format(DateTime.now())]);
    }

    else {
      var dateList = prefs.getStringList("date");
      var dates = [DateFormat.y().format(DateTime.now()), DateFormat.y().format(DateTime.now()), DateFormat.y().format(DateTime.now())];

      for (int i = 0; i < dateList.length; i++) {
        if (dateList[i] != dates[i]) {
          await prefs.setInt("scansAmount", 5);
        }
      }
    }
  }

  Widget _fishdexButton(text, link) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FishDex(widget.cameras)));
      },
      child: Container(
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }


  Widget build(BuildContext context) {
//    rebuildAllChildren(context);
    var user = Provider.of<User>(context);

    createBannerAd(_bannerAd, targetingInfo);

    return FutureBuilder(
        future: getLanguage(_prefs, context),
        builder: (context,snapshot) {
          var lang = snapshot.data;
          Map<String, dynamic> language = jsonDecode(snapshot.data)["home_page"];
          Map<String, dynamic> otherLanguage = jsonDecode(snapshot.data);
          return Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                        child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 40),
                                  // placeholder, will be a loop for all elements in DB
                                  Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          width: (MediaQuery.of(context).size.width - 10),
                                          child: Row(
                                              children: <Widget>[
                                                RichText(
                                                  text: TextSpan(
                                                      text: language["welcome"],
                                                      style: TextStyle(
                                                          color: Colors.black, fontSize: 35)
                                                  ),
                                                ),
//                                                SizedBox(width: (MediaQuery.of(context).size.width - 215)),
                                                IconButton(
                                                    icon: Icon(Icons.settings),
                                                    onPressed: () async {
//                                                      Navigator.pushReplacement(
//                                                          context, MaterialPageRoute(builder: (context) => SettingsPage(user.uid, otherLanguage, widget.cameras))
//                                                      );
                                                    }
                                                )
                                              ],
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          )
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          new OutlineButton(
                                              child: Row(
                                                children: <Widget>[
                                                  IconButton(icon: Icon(Icons.accessibility)),
                                                  Text(language["friends"]),
                                                  SizedBox(width: 8)
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (context) => FriendsPage(uid: user.uid)
                                                ));
                                              },
                                              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                          ),

                                          new StreamBuilder(
                                              stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: user.uid).snapshots(),
                                              builder: (BuildContext context, snapshot) {
                                                var jsonObject = jsonEncode(SyncBackup().backupLocally(snapshot.data.documents[0]));

                                                jsonSave(jsonObject);

                                                if (!snapshot.hasData) {
                                                  return new Center(child: new Text(language["loading"]));
                                                }

                                                else if (snapshot.data.documents[0]['species'] != null) {

                                                  var output = snapshot.data.documents[0]['species'];
                                                  var userCatches = [];
                                                  var catchesTime = [];

                                                  for (int i = 0; i < output.length; i++) {
                                                    output[i].forEach((k, v) => userCatches.add(userCatch(k, v).catchIndex()));
                                                    output[i].forEach((k, v) => catchesTime.add(userCatch(k, v).catchTime()));
                                                  }


                                                  return new FutureBuilder(
                                                      future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                                                      builder: (context, snapshot) {
                                                        List<Species> species = parseJSON(snapshot.data.toString());
                                                        List<Species> userSpecies = [];

                                                        for (int i = 0; i < userCatches.length; i++) {
                                                          userSpecies.add(species[userCatches[i] - 1]);
                                                        }

                                                        return new OutlineButton(
                                                            child: Row(
                                                              children: <Widget>[
                                                                IconButton(icon: Icon(Icons.history)),
                                                                Text(language["history"]),
                                                                SizedBox(width: 8)
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              showSearch(
                                                                  context: context,
                                                                  delegate: HistorySearch([userSpecies, catchesTime])
                                                              );
                                                            },
                                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                                        );
                                                      }
                                                  );
                                                }

                                                else {
                                                  return new FutureBuilder(
                                                      future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                                                      builder: (context, snapshot) {

                                                        List<Species> species = parseJSON(snapshot.data.toString());
                                                        List<Species> userSpecies = [];
                                                        return new OutlineButton(
                                                            child: Row(
                                                              children: <Widget>[
                                                                IconButton(icon: Icon(Icons.history)),
                                                                Text(language["history"]),
                                                                SizedBox(width: 8)
                                                              ],
                                                            ),
                                                            onPressed: () {
                                                              // Give an info box that there is no history
                                                            },
                                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                                                        );
                                                      }
                                                  );
                                                }
                                              }
                                          )
                                        ],
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                      width: (MediaQuery.of(context).size.width - 20),
                                      height: 180,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: Offset(2, 4),
                                                blurRadius: 5,
                                                spreadRadius: 2)
                                          ],
                                          gradient: linearGradient),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Container(
                                                        width: 200,
                                                        child: Text(language["fishdex_title"], textAlign: TextAlign.left, style: TextStyle(fontSize: 20, color: Colors.white)),
                                                      )
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                      width: 200,
                                                      child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: _fishdexButton(language["fishdex_button"], otherLanguage)
                                                      )
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          Image(image: AssetImage('assets/images/animation.png'), width: 120, height: 250)
                                        ],
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(language["recent_catches"], style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black)),
                                              GestureDetector(
                                                child: Text(language["see_all"]),
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FishDex(widget.cameras)));
                                                }
                                              )
                                            ],
                                          )
                                      )),
                                  SizedBox(height: 15),
                                  // The row of recent catches
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0),

                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: new FutureBuilder(
                                                  future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                                                  builder: (context, snapshot) {
                                                    List<Species> species = parseJSON(snapshot.data.toString());
                                                    return species.isNotEmpty
                                                        ? new RecentScroll(species: species, uid: user.uid, language: language)
                                                        : new Center(child: new CircularProgressIndicator());
                                                  }
                                              )
                                          ))),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0, bottom: 0.0),
                                          child: Text(language["friends_catches"], style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black))
                                      )),
                                  SizedBox(height: 15),
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0),

                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: new FutureBuilder(
                                                  future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                                                  builder: (context, snapshot) {
                                                    List<Species> species = parseJSON(snapshot.data.toString());
                                                    return species.isNotEmpty
                                                        ? new RecentFriendsScroll(species: species, uid: user.uid, language: otherLanguage)
                                                        : new Center(child: new CircularProgressIndicator());
                                                  }
                                              )


                                          ))),

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                          margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0, bottom: 0.0),
                                          child: Text(language["achievements"], style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black))
                                      )),
                                  Container(
                                      margin: EdgeInsets.only(left: 10.0),

                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: new FutureBuilder(
                                              future: DefaultAssetBundle.of(context).loadString('assets/json/species.json'),
                                              builder: (context, snapshot) {
                                                List<Species> species = parseJSON(snapshot.data.toString());
                                                return species.isNotEmpty
                                                    ? new Achievements(species: species, uid: user.uid, language: "en")
                                                    : new Center(child: new CircularProgressIndicator());
                                              }
                                          ))),

                                  SizedBox(height: 85),
                                ],
                              ),
                            ]
                        )
                    ),
                  ]
              ),
          );
        }
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

//void rebuildAllChildren(BuildContext context) {
//  void rebuild(Element el) {
//    el.markNeedsBuild();
//    el.visitChildren(rebuild);
//  }
//  (context as Element).visitChildren(rebuild);
//}


