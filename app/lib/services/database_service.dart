import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fishfinder_app/models/user.dart';

// TODO get all recent catches from the database and all of the species

// @author Ian Ronk
// @class DatabaseService
class Streams {

  final String uid;
  Streams({ this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }

  Stream get UserData {
    return usersCollection.document(uid).snapshots();
  }
}

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('users');


  Future createUser(puid, name, email) async {
    await usersCollection.document(puid).setData({
      'uid': puid,
      'name': name,
      'email': email,
      'friends': {},
      'friend_request': {},
      'catch_record': {},
      'updates': {},
      'pending_friends': {}
    });
  }

  Future addUpdate(puid, type, friend_uid, friend_name, species_int) async {
    var data = await usersCollection.document(puid).get();
    var complete_user = CompleteUser.fromMap(data.data);
    var updates = complete_user.updates;
    var now = DateTime.now().millisecondsSinceEpoch.toString();

    updates[now] = [type, friend_uid, friend_name, species_int];

    await usersCollection.document(puid).updateData({
      'updates': updates
    });
  }

  Future sendFriendRequest(puid, friend_uid) async {
    var user_1 = await usersCollection.document(puid).get();
    var complete_user_1 = CompleteUser.fromMap(user_1.data);

    var user_2 = await usersCollection.document(friend_uid).get();
    var complete_user_2 = CompleteUser.fromMap(user_2.data);

    var pending_map = complete_user_1.pending_friends;
    var request_map = complete_user_2.friend_request;

    pending_map[friend_uid] = complete_user_2.name;
    request_map[puid] = complete_user_1.name;

    // Set the update for the User 2, to receive
    var updates_map = complete_user_2.updates;
    var now = DateTime.now().millisecondsSinceEpoch.toString();

    updates_map[now] = [2, friend_uid, complete_user_2.name, null];

    // Set the Pending Friends of User 1 to contain the User 2
    await usersCollection.document(puid).updateData({
      'pending_friends': pending_map
    });

    // Set the Friend Requests of User 2 to contain the User 1
    // Set the update
    await usersCollection.document(friend_uid).updateData({
      'friend_request': request_map,
      'updates': updates_map
    });
  }


  Future removeFromPending(puid, friend_uid) async {
    var user_1 = await usersCollection.document(puid).get();
    var complete_user_1 = CompleteUser.fromMap(user_1.data);

    var user_2 = await usersCollection.document(friend_uid).get();
    var complete_user_2 = CompleteUser.fromMap(user_2.data);

    var pending_map = complete_user_1.pending_friends;
    var request_map = complete_user_2.friend_request;

    pending_map.remove(friend_uid);
    request_map.remove(puid);

    var updates_map = complete_user_2.updates;

    var update_to_remove = "";

    // Check which
    updates_map.forEach((key, value) {
      if (value[1] == uid)
        {
          update_to_remove = key;
        }
    });

    updates_map.remove(update_to_remove);

    // Set the Pending Friends of User 1 to remove the User 2
    await usersCollection.document(puid).updateData({
      'pending_friends': pending_map
    });

    // Set the Friend Requests of User 2 to remove the User 1
    // Set the updates with the removed update

    await usersCollection.document(friend_uid).updateData({
      'friend_request': request_map,
      'updates': updates_map
    });
  }


  Future addUserToFriends(puid, friend_uid) async {
    await removeFromPending(friend_uid, puid);

    // User 1: The user that accepts the friends request
    // User 2: The user that send the friends request

    var user_1 = await usersCollection.document(puid).get();
    var complete_user_1 = CompleteUser.fromMap(user_1.data);

    var user_2 = await usersCollection.document(friend_uid).get();
    var complete_user_2 = CompleteUser.fromMap(user_2.data);

    var friends_map_1 = complete_user_1.friends;
    var friends_map_2 = complete_user_2.friends;

    // Add the user's entries to their respective friends map
    friends_map_1[friend_uid] = [complete_user_2.name];
    friends_map_2[puid] = [complete_user_1.name];

    // TODO: Add updates to the first user, to tell that he has been accepted
    var updates_map_1 = complete_user_2.updates;

    var now = DateTime.now().millisecondsSinceEpoch.toString();
    updates_map_1[now] = [3, puid, complete_user_1.name, null];


    await usersCollection.document(puid).updateData({
      'friends': friends_map_1,
    });

    await usersCollection.document(friend_uid).updateData({
      'friends': friends_map_2,
      'updates': updates_map_1
    });
  }
}

