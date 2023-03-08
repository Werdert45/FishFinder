import 'package:fishfinder_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fishfinder_app/models/species.dart';

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
        backgroundColor: Color(0xffe77f70),
        body: Stack(
          children: [
            Positioned(
              top: 75,
              child: IconButton(icon: Icon(Icons.arrow_back_ios, size: 24), onPressed: () {
                Navigator.pop(context);
              }),
            ),
            // General info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80),
              child: Container(
                width: MediaQuery.of(context).size.width - 80,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                          width: 200,
                          child: Column(
                            children: [
                              Text("Afrikaanse Meerval", style: TextStyle(fontSize: 30)),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                      width: 80,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          color: Colors.lightBlueAccent),
                                      child: Center(child: Text("1m - 3m", style: TextStyle(fontSize: 14)))
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                      width: 80,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          color: Colors.lightBlueAccent),
                                      child: Center(child: Text("1m - 3m", style: TextStyle(fontSize: 14)))
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text("#001", style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.6,
//                color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0),
                        )
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: 80,
                                child: Center(child: Text("General Info"))
                            ),
                            Container(
                                width: 80,
                                child: Center(child: Text("Catch Tips"))
                            ),
                            Container(
                                width: 80,
                                child: Center(child: Text("Photos"))
                            )
                          ],
                        )
                      ],
                    )
                )
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.57,
              left: MediaQuery.of(context).size.width / 2 - 75,
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                borderRadius: new BorderRadius.all(Radius.circular(10.0)),
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/preview/' + species.name.toLowerCase() + '.jpg'),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
          ],
        )
    );
  }
}
