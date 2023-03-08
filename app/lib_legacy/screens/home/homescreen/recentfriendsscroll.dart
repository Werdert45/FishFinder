import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/models/friends_catch.dart';

class RecentFriendsScroll extends StatelessWidget {
  final List<Species> species;
  final Map language;
  RecentFriendsScroll({Key key, this.species, this.uid, this.language}) : super(key: key);

  String uid;

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: uid).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: new Text(language["home_page"]["no_catches_friends"]));
          }

          var output = snapshot.data.documents[0]['friends_catches'];

          if (output.isNotEmpty) {

            var friends_catches = [];
            output.forEach((k, v) => friends_catches.add(friendsCatch(k, v)));

            if (!snapshot.hasData) {
              return new Center(child: new Text('Loading'));
            }
            return Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: friends_catches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 10.0, top: 0.0, right: 0.0, bottom: 0.0),
                                width: 100,
                                height: 100,
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(const Radius.circular(30.0))
                                ),

                                child: AspectRatio(

                                    aspectRatio: 1.0 / 1.0,
                                    child: Image(
                                        image: AssetImage('assets/images/preview/' + species[friends_catches[index].list()[1][1]].name.toLowerCase() + '.jpg'),
                                        fit: BoxFit.fill
                                    )
                                ),

                              ),
                              Positioned(
                                  bottom: -3,
                                  right: -23,
                                  child: new RawMaterialButton(
                                    child: Text(friends_catches[index].list()[1][0][0]),
                                    shape: new CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: const EdgeInsets.all(0.0),
                                  )),
                            ],
                          ),

                          Container(
                              width: 100,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 0),
                              child: Text(formatString(showPreviewString(species[friends_catches[index].list()[1][1]].name, 12)), textAlign: TextAlign.left)
                          ),
                        ],
                      );
                    }
                )
            );
          }

          else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                  child: Text(language["home_page"]["no_catches_friends"])
              )
            );
          }


        }
    );
  }
}

