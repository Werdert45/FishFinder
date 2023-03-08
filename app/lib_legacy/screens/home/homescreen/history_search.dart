import 'package:fishfinder_app/screens/home/species/species.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:flutter/material.dart';

class HistorySearch extends SearchDelegate<String> {

  final species;

  HistorySearch(this.species);

  @override

  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () {
        query = "";
      })
    ];
  }

  Widget buildLeading(BuildContext context) {
    return IconButton(icon: AnimatedIcon(
      icon: AnimatedIcons.menu_arrow,
      progress: transitionAnimation,
    ), onPressed: (){
      close(context, null);
    });
  }

  Widget buildResults(BuildContext context) {

  }

  Widget buildSuggestions(BuildContext context) {

    var speciesList = [];

    checkQuery(species, query) {
      if (query == "") {
        for (int i = 0; i < species[0].length; i++) {
          speciesList.add(species[0][i]);
        }
      }

      else {
        for (int i = 0; i < species[0].length; i++) {
          if (species[0][i].name.contains(query)) {
            speciesList.add(species[0][i]);
          }
        }
      }
    }


    checkQuery(species, query.toLowerCase());


//    final speciesList = query.isEmpty ? species : species.where((p)=>p.name.contains(query)).toList();

    return ListView.builder(
        itemCount: speciesList.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SpeciesScreen(),
                    settings: RouteSettings(
                        arguments: speciesList[index]
                    )
                )
                );
              },
              leading: Image(image: AssetImage('assets/images/preview/' + speciesList[index].name.toLowerCase() + '.jpg'), width: 60, height: 40),
              title: Text("#" + speciesList[index].number + " " + formatString(speciesList[index].name)),
            trailing: Text(readTimestamp(int.parse(species[1][index])).toString()),
          );
        });
  }
}