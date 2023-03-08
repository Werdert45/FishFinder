import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/elements/accountDropDown.dart';
import 'package:fishfinder_app/services/auth_service.dart';
import 'package:fishfinder_app/services/database_service.dart';
import 'package:fishfinder_app/shared/dashboardFunction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  final uid;

  DashBoard({this.uid});

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override

  final AuthService _auth = AuthService();

  final DatabaseService database = DatabaseService();

  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    Widget _fishdexButton(text) {
      return InkWell(
        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) => FishDex()));
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


    final Streams streams = Streams(uid: widget.uid);

    Future logout() async {
      await _auth.signOut();
    }


    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: streams.UserData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var u = snapshot.data;

                  var completeUser = CompleteUser(uid: u['uid'], name: u['name'], email: u['email'], updates: u['updates'], friend_request: u['friend_request'], friends: u['friends'], catch_record: u['catch_record']);
                  var updates = getUpdates(completeUser.updates);
                  var achievements = achievementsCalc(completeUser.catch_record, completeUser.friends);


                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(20.0),
                                bottomRight: const Radius.circular(20.0),
                              )
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(padding: EdgeInsets.only(left: 20), child: Text("fishFinder", style: TextStyle(fontSize: 24))),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(padding: EdgeInsets.only(right: 20), child: Container(
                                      child: SimpleAccountMenu(
                                        icons: [
                                          Icon(Icons.people),
                                          Icon(Icons.settings),
                                          Icon(Icons.logout)
                                        ],
                                        iconColor: Colors.white,
                                        onChange: (index) {
                                        },
                                      )),
                                  )),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 110,
                          child: Container(
                              width: (MediaQuery.of(context).size.width - 40),
                              height: 165,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                  color: Colors.lightBlueAccent),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                width: 170,
                                                child: Text("Which Fish are you going to catch today?", textAlign: TextAlign.left, style: TextStyle(fontSize: 20, color: Colors.white)),
                                              )
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              width: 170,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: _fishdexButton("Fishdex")
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
                        ),
                        Positioned(
                          top: 290,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Updates", style: TextStyle(fontSize: 20)),
                                Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 150,
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: updates.length > 3 ? 3 : updates.length,
                                    itemBuilder: (context, index) {
                                      return updatesElement(updates[updates.length - index - 1], updates.length - index - 1);
                                    },
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text("Achievements", style: TextStyle(fontSize: 20)),
                                SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width - 60,
                                    child: GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 10, crossAxisCount: 5),
                                      itemCount: achievements.length,
                                      itemBuilder: (context, index) {
                                        return Container(width: 30, height: 30, color: Colors.red);
                                      },
                                    )
                                ),
                                Row(
                                  children: [
                                    RaisedButton(
                                      onPressed: () async {
                                        await _auth.signOut();
                                      },
                                      child: Text("Sign out"),
                                    ),
                                    RaisedButton(
                                      onPressed: () async {
                                        await database.addUpdate(user.uid, 1, null, "friend_name", 5);
                                      },
                                      child: Text("Update+"),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        )
    );
  }

  Widget updatesElement(update, index) {
    // New Species caught
    if (update[0] == 1) {
      return ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          title: Text(update[2] + " caught a new species: " + update[3].toString() + "    " + giveDateInformation(update[4])),
          leading: Icon(Icons.email, size:50)
      );
    }

    // Friend Request
    else if (update[0] == 2) {
      return ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          title: Text(update[2] + " has requested to follow you " + "    " + giveDateInformation(update[4])),
          leading: Icon(Icons.email, size:50),
          trailing: Text("Add Friend")
      );
    }

    // Friend Accepted
    else {
      return ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
          title: Text(update[2] + " added you as a friend" + "    " + giveDateInformation(update[4])),
          leading: Icon(Icons.email, size:50)
      );
    }
  }
}
