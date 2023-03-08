import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/screens/home/homescreen/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/screens/home/species/species.dart';
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
    var language = widget.language;

    return Stack(
        children: <Widget>[
          new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new StreamBuilder(
                  stream: Firestore.instance.collection('fish_catches').where(
                      'uid', isEqualTo: widget.uid).snapshots(),
                  builder: (BuildContext context, snapshot) {


                    var speciesFromDB = snapshot.data.documents[0]['species'];
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
                      return new Center(child: new Text(language["loading"]));
                    }
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 50),
                        Container(
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width - 40),
                          padding: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: <Widget>[
                              Text(language["title"], style: TextStyle(fontSize: 25)),
                              SizedBox(width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 175),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    icon: Icon(Icons.search, size: 25),
                                    onPressed: () {
                                      showSearch(
                                          context: context,
                                          delegate: SpeciesSearch(widget.species)
                                      );
                                    }
                                ),
                              )
                            ],
                          ),
                        ),


                        Container(
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width - 20),
                            height: 180,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
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
                                Container(
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width - 200),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  child: Text(language["stats"],
                                                      textAlign: TextAlign.left,
                                                      textDirection: TextDirection
                                                          .ltr,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white)),
                                                )
                                            ),
                                            SizedBox(width: 100),

                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            Text(language["latest_catch"],
                                                textAlign: TextAlign.left,
                                                textDirection: TextDirection
                                                    .ltr,
                                                style: TextStyle(fontSize: 16,
                                                    color: Colors.white))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text((speciesList.isNotEmpty ? '#' + index_show(speciesList.last).toString() + " " + formatString(widget.species[speciesList.last - 1].name) : language["no_catches"]),
                                                textAlign: TextAlign.left,
                                                textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.blueGrey))
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: <Widget>[
                                            Text(language["most_frequent"],
                                                textAlign: TextAlign.left,
                                                textDirection: TextDirection.ltr,
                                                style: TextStyle(fontSize: 16,
                                                    color: Colors.white))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text((speciesList.isNotEmpty ? '#' + index_show(most_frequent(speciesList)[0]) + " " + formatString(widget.species[most_frequent(speciesList)[0] - 1].name) : language["no_catches"]),
                                                textAlign: TextAlign.left,
                                                textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.blueGrey))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(speciesList.isNotEmpty ? most_frequent(speciesList)[1].toString() + language["times"] : "",
                                                textAlign: TextAlign.left,
                                                textDirection: TextDirection.ltr,
                                                style: TextStyle(
                                                    color: Colors.blueGrey))
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: <Widget>[
                                          ],
                                        )
                                      ],
                                    )
                                ),
                                CircularPercentIndicator(
                                  radius: (MediaQuery.of(context).size.width - 300),
                                  lineWidth: 20,
                                  percent: (uniqueSpecies).length / 64,
                                  center: new Text(uniqueSpecies.isNotEmpty ? (uniqueSpecies.length / 64 * 100).toString().substring(0, 4) + "%" : "0%",
                                      style: TextStyle(fontSize: 15)),
                                  progressColor: Colors.green,
                                )
                              ],
                            )
                        ),
                        GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.species == null ? 0 : widget
                                .species.length,
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                            itemBuilder: (BuildContext context, int index) {
                              if (speciesList.contains(index + 1)) {
                                return new GestureDetector(
                                    child: new Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: new GradientCard(
                                          gradient: linearGradient,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          elevation: 5.0,
                                          child: new Container(
                                              alignment: Alignment.center,
                                              child: new Column(
                                                children: <Widget>[
                                                  SizedBox(height: 20),
                                                  Container(
                                                    width: 200,
                                                    height: 100,
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
                                                  SizedBox(height: 7),
                                                  Text.rich(
                                                      TextSpan(
                                                          children: <TextSpan>[
                                                            TextSpan(text: "#"),
                                                            TextSpan(
                                                                text: widget
                                                                    .species[index]
                                                                    .number),
                                                            TextSpan(text: " "),
                                                            TextSpan(
                                                                text: showPreviewString(
                                                                    formatString(
                                                                        widget
                                                                            .species[index]
                                                                            .name),
                                                                    16)),

                                                          ]
                                                      )
                                                  ),
                                                ],
                                              )

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
                              }

                              else {
                                return new GestureDetector(
                                    child: new Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: new Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0),
                                          ),
                                          elevation: 5.0,
                                          child: new Container(
                                              alignment: Alignment.center,
                                              child: new Column(
                                                children: <Widget>[
                                                  SizedBox(height: 20),
                                                  Container(
                                                    width: 200,
                                                    height: 100,
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
                                                  SizedBox(height: 7),

                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text.rich(
                                                          TextSpan(
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: "#"),
                                                                TextSpan(
                                                                    text: widget
                                                                        .species[index]
                                                                        .number),
                                                                TextSpan(
                                                                    text: " "),
                                                                TextSpan(
                                                                    text: showPreviewString(
                                                                        formatString(
                                                                            widget
                                                                                .species[index]
                                                                                .name),
                                                                        16)),

                                                              ]
                                                          )
                                                      )
                                                  )
                                                ],
                                              )

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
                              }
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
