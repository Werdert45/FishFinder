import 'package:fishfinder_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/screens/home/camera/camerascreen.dart';
import 'package:camera/camera.dart';
import 'dart:core';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// @author Ian Ronk
// @class Species

class SpeciesScreen extends StatefulWidget {
  final String single_species;
  SpeciesScreen({Key key, @required this.single_species}) : super(key: key);

  @override
  _SpeciesScreenState createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {

    final Species species = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                    SizedBox(height: 70),
                    Image.asset('assets/images/preview/' + species.name.toLowerCase() + '.jpg', width: MediaQuery.of(context).size.width),
                    SizedBox(height: 10),
                    Text("#" + species.number + " " + formatString(species.name), style: TextStyle(fontSize: 20))
                  ],
                )
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height - 250),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white
                    ),
                    height: 1400,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 40),
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: GridView.count(
                            primary: true,
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 5,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.fastfood),
                                    SizedBox(width: 5),
                                    Text(species.edible, style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.equalizer),
                                    SizedBox(width: 5),
                                    Text(species.conservation_state, style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.wb_sunny),
                                    SizedBox(width: 5),
                                    Text(species.catch_time, style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.explore),
                                    SizedBox(width: 5),
                                    Text(species.length, style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text("General Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text(species.general_information, style: TextStyle(fontSize: 15))),
                              ),
                              SizedBox(height: 25),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text("Living area", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text(species.living_area, style: TextStyle(fontSize: 15))),
                              ),
                              SizedBox(height: 25),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text("Life Cycle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
                              ),
                              SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(child: Text(species.lifecycle, style: TextStyle(fontSize: 15))),
                              ),
                              Container(
                                height: 400,
                                child: ListView.builder(
                                    itemCount: species.references.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Text((index + 1).toString() + ". " + species.references[index]);
                                    }
                                )
                              )


                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 75,
              decoration: BoxDecoration(
                  color: Colors.white
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25),
                  Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.arrow_back), onPressed: () {Navigator.pop(context);}),
                      Text(formatString(species.name))
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
