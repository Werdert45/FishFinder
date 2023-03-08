import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishfinder_app/screens/authenticate/sign_in.dart';
import 'package:fishfinder_app/screens/wrapper.dart';
import 'package:fishfinder_app/services/backup.dart';
import 'package:fishfinder_app/services/database.dart';
import 'package:fishfinder_app/services/refresh.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'payment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:fishfinder_app/screens/home/homescreen/dashboard.dart';

class Item {
  const Item(this.name, this.id);
  final String name;
  final String id;
}

class SettingsPage extends StatefulWidget {
  final String uid;
  final Map language;
  final List<CameraDescription> cameras;

  SettingsPage(this.uid, this.language, this.cameras);


  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();

  _logoutButton(text) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.2, color: Colors.lightBlue.shade900),
          ),
        ),
        child: ListTile(
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Wrapper(cameras: widget.cameras)));
            },
            title: Text(text),
            leading: Icon(Icons.exit_to_app)
        )
    );
  }

  Map languagePairs = {'English': 'en', 'Nederlands (Dutch)': 'nl', 'Italiano (Italian)': 'it'};

  String languageID;


  Item selectedUser;
  List<Item> users = <Item>[
    const Item('English', 'en'),
    const Item('Nederlands (Dutch)', 'nl'),
  ];


  final emailController = TextEditingController();

  final nameController = TextEditingController();
//  final passwordController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (selectedUser != null) {
      languageID = languagePairs[selectedUser.name];
    }

    var language = widget.language["settings_page"];

    return Scaffold(
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 12),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.close, size: 30, color: Colors.black),
                                  onPressed: () async {
                                    if (selectedUser != null) {
                                      DatabaseService().updateLanguage(languageID, widget.uid);
                                      Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
                                      final prefs = await _prefs;
                                      await prefs.setString("language", languageID);
//                                      languageApp = languageID;
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(widget.cameras)));
                                    }
                                    if (emailController.text != "") {
                                      DatabaseService().updateEmail(emailController.text, widget.uid);
                                    }

                                    if (nameController.text != "") {
                                      DatabaseService().updateName(nameController.text, widget.uid);
                                    }

                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage(widget.cameras)));
                                  },
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(language["title"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                            )
                          ],
                        ),

                        SizedBox(height: 20),
                        new StreamBuilder(
                          stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: widget.uid).snapshots(),
                          builder: (BuildContext context, snapshot) {
                            var output = snapshot.data.documents[0];

                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              width: MediaQuery.of(context).size.width,

                              child: Column(
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(language["account"])
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 0.2, color: Colors.lightBlue.shade900),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: output['email']
                                            )
                                        ),
                                        leading: Icon(Icons.email),
                                      )
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 0.2, color: Colors.lightBlue.shade900),
                                        ),
                                      ),
                                      child: ListTile(
                                          title: TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: output['name']
                                              )

                                          ),
                                          leading: Icon(Icons.account_box)
                                      )
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 0.2, color: Colors.lightBlue.shade900),
                                        ),
                                      ),
                                      child: ListTile(
                                          title: TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '********'
                                            ),
                                          ),
                                          leading: Icon(Icons.lock)
                                      )
                                  ),
                                  SizedBox(height: 25),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(language["language"])
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                      ),
                                      child: ListTile(
                                        title: DropdownButton<Item>(
                                          hint:  Text(language["language_select"]),
                                          value: selectedUser,
                                          onChanged: (Item Value) {
                                            setState(() {
                                              selectedUser = Value;
                                            }
                                            );
                                          },
                                          items: users.map((Item user) {
                                            return  DropdownMenuItem<Item>(
                                              value: user,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    user.name,
                                                    style:  TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        leading: Icon(Icons.flag),
                                      )
                                  ),
                                  SizedBox(height: 50),
                                  Container(
                                      width: (MediaQuery.of(context).size.width - 20),
                                      height: 185,
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Container(
                                                    width: 200,
                                                    child: Text(language["upgrade_title"], textAlign: TextAlign.left, textDirection: TextDirection.ltr ,style: TextStyle(fontSize: 20, color: Colors.white)),
                                                  )
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(language["upgrade_hint_1"], textAlign: TextAlign.left, textDirection: TextDirection.ltr ,style: TextStyle(fontSize: 15, color: Colors.white)),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: Text(language["upgrade_hint_2"], textAlign: TextAlign.left, textDirection: TextDirection.ltr ,style: TextStyle(fontSize: 15, color: Colors.white)),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: <Widget>[
                                              OutlineButton(
                                                child: Container(
                                                    child: SizedBox(
                                                        width: 125,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(language["upgrade_button"], textAlign: TextAlign.left, textDirection: TextDirection.ltr ,style: TextStyle(color: Colors.white)),
                                                          ],
                                                        )
                                                    )
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPaymentScreen()));
                                                },
                                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                                color: Colors.orange,
                                              ),

                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  _logoutButton(language["logout"]),
                                ],
                              ),
                            );
                          }

                        )

                      ],
                    )
                )
            )
          ],
        )
    );
  }
}
