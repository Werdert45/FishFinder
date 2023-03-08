import 'dart:convert';

class Species {
  final String number;
  final String name;
  final String latin_name;
  final String length;
  final String edible;
  final String conservation_state;
  final String catch_state;
  final String catch_time;
  final String general_information;
  final String living_area;
  final String lifecycle;
  final List references;


  Species({this.number, this.name, this.latin_name, this.catch_state, this.edible, this.conservation_state, this.catch_time, this.length, this.general_information, this.living_area, this.lifecycle, this.references});

  factory Species.fromJSON(Map<String, dynamic> json) {
    return new Species(
        number: json['number'] as String,
        name: json['name'] as String,
        latin_name: json['latin_name'] as String,
        catch_state: json['catch_state'] as String,
        edible: json['edible'] as String,
        conservation_state: json['conservation_state'] as String,
        catch_time: json['catch_time'] as String,
        length: json['length'] as String,
        general_information: json['general_information'] as String,
        living_area: json['living_area'] as String,
        lifecycle: json['lifecycle'] as String,
        references: json['references'] as List
    );
  }


}
//
//ListView.builder(
//itemExtent: 80.0,
//itemCount: snapshot.data.documents.length,
//itemBuilder: (context, index) {
//return _buildList(context,snapshot.data.documents[index]);
//}
//);

