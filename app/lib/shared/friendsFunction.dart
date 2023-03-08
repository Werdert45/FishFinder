
import 'package:fishfinder_app/models/friendTile.dart';

List<FriendTile> getUserDataFromSnapshot(users)
{
  var new_users = [];

  for (int i=0; i<users.length; i++)
    {
      new_users.add(FriendTile(users[i]['uid'], users[i]['name']));
    }

  return new_users;
}


