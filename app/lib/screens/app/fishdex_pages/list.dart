import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/screens/partials/searchSpecies.dart';
import 'package:fishfinder_app/services/database_service.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/screens/app/species_pages/speciesInformation.dart';
import 'dart:core';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SpeciesList extends StatefulWidget {
  final List<Species> species;
  final String uid;
  final Map language;

  SpeciesList({Key key, this.species, this.uid, this.language}) : super(key: key);

  @override
  _SpeciesListState createState() => _SpeciesListState();
}


class _SpeciesListState extends State<SpeciesList> {
  @override

  Widget build(BuildContext context) {

    final Streams streams = Streams(uid: widget.uid);


    return Stack(
        children: <Widget>[
          new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new StreamBuilder(
                  stream: streams.UserData,
                  builder: (BuildContext context, snapshot) {

                    var speciesFromDB = snapshot.data['catch_record'];
                    var speciesList = [];
                    var uniqueSpecies = [];

                    for (int i = 0; i < speciesFromDB.length; i++) {
                      speciesFromDB[i].forEach((k, v) {
                        speciesList.add(v);
                        if (!uniqueSpecies.contains(v)) {
                          uniqueSpecies.add(v);
                        }
                      });
                    }

                    if (!snapshot.hasData) {
                      return new Center(child: new Text("loading"));
                    }
                    return Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(30.0),
                                bottomRight: const Radius.circular(30.0),
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: IconButton(
                                        icon: Icon(Icons.search, size: 25),
                                        onPressed: () {
                                          showSearch(
                                              context: context,
                                              delegate: SpeciesSearch(widget.species)
                                          );
                                        }
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 40), child: Text("fishDex", style: TextStyle(fontSize: 24))),
                                Padding(
                                  padding: const EdgeInsets.only(top: 75),
                                  child: Text("Check which fish you have caught\nand which ones are still missing"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.species == null ? 0 : widget
                                .species.length,
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 4/3,
                                crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              return new GestureDetector(
                                  child: new Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: new Card(
                                        color: Color(0xffe77f70),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              15.0),
                                        ),
                                        elevation: 1.0,
                                        child: Stack(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(top: 15, left: 15),
                                                child: SizedBox(
                                                    width: 105,
                                                    child: Text(widget.species[index].name.substring(0,1).toUpperCase() + widget.species[index].name.substring(1), style: TextStyle(fontSize: 14))
                                                )
                                            ),
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 15, top: 15),
                                                  child: Text(widget.species[index].number),
                                                )
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15, bottom: 15),
                                                child: Container(
                                                  height: 41,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          width: 65,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                                              color: Colors.lightBlueAccent),
                                                          child: Center(child: Text("1m - 3m", style: TextStyle(fontSize: 10)))
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                          width: 65,
                                                          height: 18,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(15)),
                                                              color: Colors.lightBlueAccent),
                                                          child: Center(child: Text("1m - 3m", style: TextStyle(fontSize: 10)))
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.bottomRight,
                                                child: Padding(
                                                  padding: EdgeInsets.only(bottom: 8, right: 8),
                                                  child: Container(
                                                    width: 60,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/images/preview/' +
                                                                    widget
                                                                        .species[index]
                                                                        .name
                                                                        .toLowerCase() +
                                                                    '.jpg'),
                                                            fit: BoxFit.cover
                                                        )
                                                    ),
                                                  ),
                                                )
                                            )
                                          ],
                                        )
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => SpeciesScreen(),
                                        settings: RouteSettings(
                                            arguments: widget.species[index]
                                        )
                                    )
                                    );
                                  }
                              );
                            }),
                        SizedBox(height: 50)
                      ],
                    );
                  }
              )
          ),
        ]
    );
  }

}


//Container(
//width: 200,
//height: 100,
//decoration: BoxDecoration(
//image: DecorationImage(
//image: AssetImage(
//'assets/images/preview/' +
//widget
//    .species[index]
//.name
//    .toLowerCase() +
//'.jpg'),
//fit: BoxFit.cover
//)
//),
//),


//widget
//    .species[index]
//.number)