import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/models/friendTile.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/elements/search_bar/searchBar.dart';
import 'package:fishfinder_app/services/database_service.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/screens/elements/search_bar/no_item_found.dart';
import 'package:provider/provider.dart';


class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {

  List<FriendTile> getUserDataFromSnapshot(List<DocumentSnapshot> users)
  {
    var new_users = [];

    for (int i=0; i<users.length; i++)
    {
      new_users.add(FriendTile(users[i]['uid'], users[i]['name']));
    }

    return new_users;
  }

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);

    final Streams streams = Streams(uid: user.uid);
    final DatabaseService database = DatabaseService();

    return Scaffold(
      body: StreamBuilder<Object>(
        stream: streams.UserData,
        builder: (context, current_user) {

          return SafeArea(
            child: StreamBuilder(
              stream: streams.users,
              builder: (context, snapshot) {
                var users = snapshot.data.documents;
                List<FriendTile> list = [];

                for (int i=0; i<users.length; i++)
                {
                  list.add(FriendTile(users[i]['uid'], users[i]['name']));
                }

                DocumentSnapshot currentUser = current_user.data;
                print(currentUser['friend_request'].length);

                List requestFriendsList = [];
                List requestFriendsUIDs = [];

                List friendsList = [];
                List friendsUIDs = [];

                currentUser['friend_request'].forEach((k,v) {
                  requestFriendsList.add(v);
                  requestFriendsUIDs.add(k);
                });

                currentUser['friends'].forEach((k,v) {
                  friendsList.add(v);
                  friendsUIDs.add(k);
                });

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 60, child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {Navigator.pop(context);})),
                          SizedBox(width: 140, child: Text("Friends", style: TextStyle(fontSize: 28))),
                          SizedBox(width: 0)
                            ],
                      ),
                      SizedBox(height: 15),
                      SearchWidget<FriendTile>(
                        dataList: list,
                        hideSearchBoxWhenItemSelected: false,
                        listContainerHeight: MediaQuery.of(context).size.height / 4,
                        queryBuilder: (String query, List<FriendTile> list) {
                          return list.where((FriendTile item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
                        },
                        popupListItemBuilder: (FriendTile item) {
                          return PopupListItemWidget(item, current_user.data);
                        },
                        selectedItemBuilder: (FriendTile selectedItem, VoidCallback deleteSelectedItem) {
                          return Container();
                        },
                        // widget customization
                        noItemsFoundWidget: NoItemsFound(),
                        textFieldBuilder: (TextEditingController controller, FocusNode focusNode) {
                          return MyTextField(controller, focusNode);
                        },
                      ),
                      SizedBox(height: 20),
                      // Body of the friends
                      currentUser['friend_request'].length != 0 ? Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 20,
                          child: Text("Friend Requests", style: TextStyle(fontSize: 18)),
                        )
                      ) : SizedBox(),
                      currentUser['friend_request'].length != 0 ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 3*50.0,
                              child: ListView.builder(
                                itemBuilder: (context, index)
                                {
                                  return ListTile(
                                    visualDensity: VisualDensity(horizontal: -2, vertical: -2),
                                    title: Text(requestFriendsList[index]),
                                    leading: Icon(Icons.email, size:30),
                                    trailing: Container(
                                      width: 120,
                                      child: Row(
                                        children: [
                                          ButtonTheme(
                                            height: 25,
                                            minWidth: 50,
                                            child: RaisedButton(
                                              child: Text("Accept", style: TextStyle(fontSize: 10)),
                                              onPressed: () async {
                                                await database.addUserToFriends(currentUser['uid'], requestFriendsUIDs[index]);
                                              },
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.more_horiz)
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: currentUser['friend_request'].length,
                              ),
                            )
                          ],
                        ),
                      ) : SizedBox(),
                      friendsList.length != 0 ? SizedBox(height: 30) : SizedBox(),
                      friendsList.length != 0 ? Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Text("Friends List", style: TextStyle(fontSize: 18)),
                          )
                      ) : SizedBox(),
                      friendsList.length != 0 ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 3*50.0,
                              child: ListView.builder(
                                itemBuilder: (context, index)
                                {
                                  return ListTile(
                                    visualDensity: VisualDensity(horizontal: -2, vertical: -2),
                                    title: Text(friendsList[index][0]),
                                    leading: Icon(Icons.email, size:30),
                                    trailing: Container(
                                      width: 150,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Latest Catch: Tiendoornig...", style: TextStyle(fontSize: 10)),
                                          Text("FishDex: 40/64 (72%)", style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: friendsList.length
                              )
                            )
                          ]
                        )
                      ) : SizedBox()
                    ]
                  )
                );
              }
            ),
          );
        }
      )
    );
  }
}


class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search here...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.people,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          "No Users Found",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item, this.currentUser);

  final FriendTile item;
  final DocumentSnapshot currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser['uid'] != item.uid)
      {
        return Container(
          height: 50,
          child: ListTile(
            leading: Icon(Icons.people, size: 25),
            title: Text(
              item.name,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: Container(
                child: TrailingFriend(currentUser, item.name, item.uid, currentUser['friend_request'], currentUser['friends'], currentUser['pending_friends'])
            ),
          ),
        );
      }
    else {
      return SizedBox();
    }
  }
}

Widget TrailingFriend(user, name, uid, Map friend_request, Map friend_list, Map pending_friends)
{
  final DatabaseService database = DatabaseService();

  var requestIDs = friend_request.keys.toList();
  var friendIDs = friend_list.keys.toList();
  var pendingIDs = pending_friends.keys.toList();

  if (requestIDs.contains(uid))
    {
      // Get friend as requested friend
      return Container(
        width: 115,
        child: Row(
          children: [
            ButtonTheme(
              height: 25,
              minWidth: 50,
              child: RaisedButton(
                child: Text("Accept", style: TextStyle(fontSize: 10)),
                onPressed: () async {
                  print(user['uid']);

                  await database.addUserToFriends(user['uid'], uid);
                },
              ),
            ),
            IconButton(
                icon: Icon(Icons.more_horiz)
            )
          ],
        ),
      );
    }

  else if (friendIDs.contains(uid))
    {
      // Get friend as added friend
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Latest Catch: Tiendoornig...", style: TextStyle(fontSize: 10)),
          Text("FishDex: 40/64 (72%)", style: TextStyle(fontSize: 10)),
        ],
      );
    }

  else if (pendingIDs.contains(uid))
    {
      // Get friend as pending
      return SizedBox(
        width: 105,
        child: Row(
          children: [
            Text("Pending"),
            IconButton(icon: Icon(Icons.cancel), onPressed: () async {
              await database.removeFromPending(user['uid'], uid);
            })
          ],
        ),
      );
    }

  else {
    // Get as unknown person
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        await database.sendFriendRequest(user['uid'], uid);
      },
    );
  }



}
