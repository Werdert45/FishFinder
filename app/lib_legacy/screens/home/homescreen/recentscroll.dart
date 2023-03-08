import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/screens/home/species/species.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:fishfinder_app/models/species.dart';


class RecentScroll extends StatelessWidget {
  final List<Species> species;
  final String uid;
  final Map language;
  RecentScroll({Key key, this.species, this.uid, this.language}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance.collection('fish_catches').where('uid', isEqualTo: uid).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return new Center(child: new Text('Loading'));
          }

          var output_species = snapshot.data.documents[0]['species'];


          if (output_species.isNotEmpty) {
            var output_species = snapshot.data.documents[0]['species'];
            var speciez = [];

            return Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.documents[0]['species'].length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data.documents[0]['species'].length == 0) {
                        return Center(child: Text("New"));
                      }

                      else {
                        for (int i = 0; i < output_species.length; i++) {
                          output_species[i].forEach((k, v) {
                            speciez.add(v);
                          });
                        }

                        return new GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SpeciesScreen(),
                                  settings: RouteSettings(
                                      arguments: species[speciez[index] - 1]
                                  )
                              )
                              );
                            },
                            child: Column(
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
                                            image: AssetImage('assets/images/preview/' + species[speciez[index] - 1].name.toLowerCase() + '.jpg'),
                                            fit: BoxFit.fill
                                        )
                                    )
                                ),
                                Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 0),
                                    child: Text(formatString(showPreviewString(species[speciez[index] - 1].name, 10)), textAlign: TextAlign.left)
                                ),
                              ],
                            )
                        );


                      }
                    }
                )
            );
          }

          else {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                    child: Text(language["no_catches"])
                )
            );
          }

        }
    );
  }
}

//species[(snapshot.data.documents[0]['species'][index] - 1)].name