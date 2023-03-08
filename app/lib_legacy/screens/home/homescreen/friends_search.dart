import 'package:fishfinder_app/services/database.dart';
import 'package:flutter/material.dart';

class FriendsSearch extends SearchDelegate<String> {

  final users;
  final uid;
  final others;
  final added;
  final username;

  FriendsSearch(this.users, this.uid, this.others, this.added, this.username);

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
    var userList = [];
    var userIDs = [];

    bool pending = false;


    checkQuery(user, query) {
      if (query == "") {
        for (int i = 0; i < user.length; i++) {
          userList.add(user[i][1]);
          userIDs.add(user[i][0]);
        }

        return true;
      }

      for (int i = 0; i < user.length; i++) {
        if (user[i][1].toString().toLowerCase().contains(query)) {
          userList.add(user[i][1]);
          userIDs.add(user[i][0]);
        }
      }
    }

    checkQuery(users[0], query.toLowerCase());

//    final userList = query.isEmpty ? user : user.where((p)=>p.name.contains(query)).toList();

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {

          if (users[index][0] == uid) {
            return SizedBox(height: 0);
          }

          else if (others.contains(users[index][0])) {
            return ListTile(
              title: Text(users[index][1]),
              trailing: Text("Pending")
            );
          }
          else {
            return ListTile(
              title: Text(users[index][1]),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  DatabaseService().sendFriendsRequest(users[index][1], users[index][0], uid, username);
                  close(context, null);
                },
              ),
            );
          }

        });
  }
}