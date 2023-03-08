import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/models/users_db.dart';
import 'package:fishfinder_app/screens/home/homescreen/friends_search.dart';
import 'package:fishfinder_app/services/database.dart';
import 'package:flutter/material.dart';


class FriendsPage extends StatefulWidget {
  final String uid;
  FriendsPage({Key key, this.uid}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder(
              stream: Firestore.instance.collection('fish_catches').where(
                'uid', isEqualTo: widget.uid).snapshots(),
              builder: (BuildContext context, snapshot) {

                if (!snapshot.hasData) {
                  return new Center(child: new Text('Loading ...'));
                }

                if (snapshot.data.documents[0]['friends_name'] == null && snapshot.data.documents[0]['friends_requests_name'] == null) {
                  var snapper = snapshot.data.documents[0];
                  var friends_added = snapshot.data.documents[0]['friends_name'];
                  var friends_id = snapshot.data.documents[0]['friends_id'];

                  return Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            ),
                            Text("Friends", style: TextStyle(fontSize: 25)),
//                          SizedBox(width: MediaQuery.of(context).size.width - 175),
                            StreamBuilder(
                                stream: Firestore.instance.collection('general_information').document('IOpIw5GzEBdFtx7jHUqz').snapshots(),
                                builder: (context, snapshot) {
                                  // Make an if statement if data is not present (also check the friends again)
                                  var map = snapshot.data['users'];
                                  var users = [];

                                  for (int i = 0; i < map.length; i++) {
                                    if (map[i].toList()[0][0] != snapper['name'] || !snapper['friends_id'].contains(map[i].toList()[0][0])) {
                                      map[i].forEach((k, v) => users.add(usersDB(k, v).list()));
                                    }

                                  }

                                  var others = (snapper['friends_pending_id'] != null) ? snapper['friends_pending_id'] : [];

                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        icon: Icon(Icons.add, size: 25),
                                        onPressed: () {
                                          showSearch(
                                              context: context,
                                              delegate: FriendsSearch(users, widget.uid, others, snapper['friends_id'], snapper['name'])
                                          );
                                        }
                                    ),
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                Center(child: Text("No friends"))
                    ],
                  );


                }

                else {
                  var snapper = snapshot.data.documents[0];
                  var friends_added = snapshot.data.documents[0]['friends_name'];
                  var friends_id = snapshot.data.documents[0]['friends_id'];


                  return Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Container(
                        width: (MediaQuery.of(context).size.width),
                        padding: EdgeInsets.only(bottom: 20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                            ),
                            Text("Friends", style: TextStyle(fontSize: 25)),
//                          SizedBox(width: MediaQuery.of(context).size.width - 175),
                            StreamBuilder(
                                stream: Firestore.instance.collection('general_information').document('IOpIw5GzEBdFtx7jHUqz').snapshots(),
                                builder: (context, snapshot) {
                                  // Make an if statement if data is not present (also check the friends again)

                                  var map = snapshot.data['users'];
                                  var users = [];

                                  for (int i = 0; i < map.length; i++) {
                                    map[i].forEach((k, v) => users.add(usersDB(k, v).list()));
                                  }

                                  var others = (snapper['friends_pending_id'] != null) ? snapper['friends_pending_id'] : [];

                                  return Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        icon: Icon(Icons.add, size: 25),
                                        onPressed: () {
                                          showSearch(
                                              context: context,
                                              delegate: FriendsSearch(users, widget.uid, others, snapper['friends_id'], snapper['name'])
                                          );
                                        }
                                    ),
                                  );
                                }
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("All Friends", style: TextStyle(fontSize: 16))
                        ),
                      ),
                      Container(
                          height: 180,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              itemCount: snapshot.data.documents[0]['friends_name'].length,
                              itemBuilder: (context, int index) {
                                if (snapshot.data.documents[0]['friends_name'].length == 0) {
                                  return Center(
                                    child: Text("No Friends yet, try to add them"),
                                  );
                                }
                                else {
                                  return ListTile(
                                      title: Text(snapshot.data.documents[0]['friends_name'][index]),
                                      leading: Icon(Icons.account_box),
                                    trailing: IconButton(
                                        icon: Icon(Icons.close),
                                      onPressed: () {
                                          DatabaseService().removeFriend(snapshot.data.documents[0]['friends_name'][index], snapshot.data.documents[0]['friends_id'][index], widget.uid, snapshot.data.documents[0]['name']);
                                      },
                                    ),
                                  );
                                }

                              }
                          )
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Friend Requests", style: TextStyle(fontSize: 16))
                        ),
                      ),
                      Container(
                          height: 180,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              itemCount: (snapshot.data.documents[0]['friends_requests_name'] != null) ? snapshot.data.documents[0]['friends_requests_name'].length : 0,
                              itemBuilder: (context, int index) {
                                if (snapshot.data.documents[0]['friends_requests_name'].length == 0) {
                                  return Center(
                                    child: Text("No Friends yet, try to add them"),
                                  );
                                }
                                else {
                                  return ListTile(
                                    title: Text(snapshot.data.documents[0]['friends_requests_name'][index]),
                                    leading: Icon(Icons.account_box),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.done),
                                          onPressed: () {
                                            DatabaseService().acceptFriendsRequest(snapshot.data.documents[0]['friends_requests_name'][index], snapshot.data.documents[0]['friends_requests_id'][index], widget.uid, snapshot.data.documents[0]['name']);
                                          },
                                        ),
                                        SizedBox(width: 0),
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            DatabaseService().denyFriendsRequest(snapshot.data.documents[0]['friends_requests_name'][index], snapshot.data.documents[0]['friends_requests_id'][index], widget.uid, snapshot.data.documents[0]['name']);
                                          },
                                        ),
                                      ],
                                    )
                                  );
                                }

                              }
                          )
                      ),
                      SizedBox(height: 30),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Friend Pending", style: TextStyle(fontSize: 16))
                        ),
                      ),
                      Container(
                          height: 180,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              itemCount: (snapshot.data.documents[0]['friends_pending_name'] != null) ? snapshot.data.documents[0]['friends_pending_name'].length : 0,
                              itemBuilder: (context, int index) {
                                if (snapshot.data.documents[0]['friends_pending_name'].length == 0) {
                                  return Center(
                                    child: Text("No Friends yet, try to add them"),
                                  );
                                }
                                else {
                                  return ListTile(
                                    title: Text(snapshot.data.documents[0]['friends_pending_name'][index]),
                                    leading: Icon(Icons.account_box),
                                    trailing: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {},
                                    ),
                                  );
                                }

                              }
                          )
                      )
                    ],
                  );
                }

              }
          )
        )
      ],
    )
    );
  }
}
