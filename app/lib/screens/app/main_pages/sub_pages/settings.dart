import 'package:firebase_image/firebase_image.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/services/auth_service.dart';
import 'package:fishfinder_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  final data;

  SettingsPage({this.data});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
//  final userManagement = UserManageme();
  final DatabaseService database = DatabaseService();


  TextEditingController _groupCodeController;
  var _groupCode = "";
  List groupsList = [];

  bool isDark = false;
  bool sendNotifications = false;

  bool wrongGroupCode = false;
  bool brightness = false;

  bool isSwitched = false;
  var user_data;

  bool changePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    getDarkModeSetting().then((val) {
//      brightness = val;
//    });
  }

  @override

  Widget build(BuildContext context) {

//    user_data = widget.data;
    var user = Provider.of<User>(context);
//    getDarkModeSetting().then((val) {
//      brightness = val;
//    });

//    var color = brightness ? darkmodeColor : lightmodeColor;

//    groupsList = user_data.groups;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                        children: [
                          wrongGroupCode ?
                          GestureDetector(
                              child: Container(
                                  color: Colors.red,
                                  width: MediaQuery.of(context).size.width - 140,
                                  height: 40,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      child: Center(
                                          child: Text("Wrong group code, try again")
                                      )
                                  )
                              ),
                              onTap: () {
                                setState(() {
                                  wrongGroupCode = false;
                                });
                              }
                          ) : SizedBox(),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 170,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
//                                color: color['foregroundColor'],
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
//                                Align(
//                                  alignment: Alignment.centerLeft,
//                                  child: Padding(
//                                      padding: EdgeInsets.only(left: 20, top: 20),
//                                      child: Container(
//                                        width: 70,
//                                        height: 70,
//                                        child: GestureDetector(
//                                          onTap: () {
////                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeProfilePicturePage(user_data)));
//                                          },
//                                          child: ClipRRect(
//                                            borderRadius: BorderRadius.circular(35),
//                                            child: Image(fit: BoxFit.fill, image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + user_data.profile_picture.toString())),
//                                          ),
//                                        ),
//                                      )
//                                  ),
//                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 110, top: 50),
                                      child: Container(
                                        height: 70,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Change your settings,", style: TextStyle(color: Colors.white70)),
                                            Text("Ian", style: TextStyle(fontSize: 20, color: Colors.white))
                                          ],
                                        ),
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 70,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Text("General"),
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 70,
                                height: 1,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          Container(
                            height: 140,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              children: ListTile.divideTiles(
                                  context: context,
                                  tiles: [
                                    ListTile(
                                      leading: Icon(Icons.brightness_3),
                                      title: Text("Dark Mode"),
                                      trailing: Switch(
                                        value: isDark,
                                        onChanged: (value) {
                                          if (value) {
//                                            ThemeBuilder.of(context).changeTheme(Brightness.dark);
                                          }

                                          else {
//                                            ThemeBuilder.of(context).changeTheme(Brightness.light);
                                          }

//                                          darkModeToSF(value);

                                          setState(() {
                                            isDark = value;
                                          });
                                        },
//                                        activeTrackColor: color['primaryColorFocus'],
//                                        activeColor: color['primaryColor'],
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.language),
                                      title: Text("Language"),
                                      trailing: Text("English"),
                                    ),
                                  ]
                              ).toList(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 70,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Text("Personal"),
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 70,
                                height: 1,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          Container(
                              height: changePassword ? 400 : 200,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                  primary: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: ListTile.divideTiles(
                                      context: context,
                                      tiles: [
                                        ListTile(
                                          leading: Icon(Icons.notifications),
                                          title: Text("Notifications"),
                                          trailing: Switch(
                                            value: sendNotifications,
                                            onChanged: (value) {
//                                              notificationsToSF(value);

                                              setState(() {
                                                sendNotifications = value;
                                              });
                                            },
//                                            activeTrackColor: color['primaryColorFocus'],
//                                            activeColor: color['primaryColor'],
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.email),
                                          title: Text("Change email"),
                                          trailing: Container(
                                            width: 155,
                                            height: 30,
                                            child: Row(
                                              children: [
                                                Text("ianronk@gmail.com"),
//                                                Text(user_data.email.length < 18 ? user_data.email.toLowerCase() : user_data.email.substring(0,16).toLowerCase() + "..."),
                                                SizedBox(width: 4,),
                                                Icon(Icons.arrow_forward_ios, size: 12,)
                                              ],
                                            ),
                                          ),
                                          onTap: () {
//                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmail(email: user_data.email)));
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.lock),
                                          title: Text("Change password"),
                                          trailing: Container(
                                            width: 94,
                                            height: 30,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text("***********"),
                                                ),
                                                SizedBox(width: 4,),
                                                Icon(Icons.arrow_forward_ios, size: 12,)
                                              ],
                                            ),
                                          ),
                                          onTap: () {
//                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(email: user_data.email)));
                                          },
                                        )
                                      ]
                                  ).toList()
                              )
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 100,
                                height: 1,
                                color: Colors.grey,
                              ),
                              Text("Premium"),
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 100,
                                height: 1,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          ListTile(
                            leading: Icon(Icons.star),
                            title: Text("Go Premium"),
                            trailing: IconButton(icon: Icon(Icons.arrow_forward_ios, size: 12), onPressed: () {}),
//                            onTap: _launchURL,
                          ),
                          SizedBox(height: 20),
                          Container(
                              width: MediaQuery.of(context).size.width - 50,
                              height: 1,
                              color: Colors.grey
                          ),
                          ListTile(
                            leading: Icon(Icons.library_books),
                            title: Text("Licensing"),
//                            onTap: _launchURL,
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}

//_launchURL() async {
//  const url = 'https://ianronk.nl/privacy_policy/taskcollab';
//  if (await canLaunch(url)) {
//    await launch(url);
//  } else {
//    throw 'Could not launch $url';
//  }
//}