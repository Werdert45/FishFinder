import 'package:cloud_firestore/cloud_firestore.dart';

// TODO get all recent catches from the database and all of the species

// @author Ian Ronk
// @class DatabaseService
class Streams {

  final String uid;
  Streams({ this.uid});

  // collection reference
  final CollectionReference fishCatchesCollection = Firestore.instance.collection('fish_catches');


  Stream<DocumentSnapshot> get fishCatches {
    return fishCatchesCollection.document(uid).snapshots();
  }
}

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid});

  // collection reference
  final CollectionReference fishCatchesCollection = Firestore.instance
      .collection('fish_catches');

  final CollectionReference generalInformationCollection = Firestore.instance.collection('general_information');


  Future updateName(name, puid) async {
    await fishCatchesCollection.document(puid).updateData({
      'name': name
    });

    await generalInformationCollection.document('IOpIw5GzEBdFtx7jHUqz').updateData({
      'users': FieldValue.arrayUnion([{puid: name}])
    });
  }

  Future updateEmail(email, puid) async {
    await fishCatchesCollection.document(puid).updateData({
      'email': email
    });
  }

  Future updateLanguage(language, puid) async {
    await fishCatchesCollection.document(puid).updateData({
      'language': language
    });
  }

  Future sendFriendsRequest(friend_name, friend_id, puid, username) async {
    await fishCatchesCollection.document(puid).updateData({
      'friends_pending_id': FieldValue.arrayUnion([friend_id]),
      'friends_pending_name': FieldValue.arrayUnion([friend_name])
    });

    await fishCatchesCollection.document(friend_id).updateData({
      'friends_requests_id': FieldValue.arrayUnion([puid]),
      'friends_requests_name': FieldValue.arrayUnion([username])
    });
  }

  Future acceptFriendsRequest(friend_name, friend_id, puid, username) async {
    await fishCatchesCollection.document(puid).updateData({
      'friends_requests_id': FieldValue.arrayRemove([friend_id]),
      'friends_requests_name': FieldValue.arrayRemove([friend_name]),
      'friends_id': FieldValue.arrayUnion([friend_id]),
      'friends_name': FieldValue.arrayUnion([friend_name])
    });

    await fishCatchesCollection.document(friend_id).updateData({
      'friends_pending_id': FieldValue.arrayRemove([puid]),
      'friends_pending_name': FieldValue.arrayRemove([username]),
      'friends_id': FieldValue.arrayUnion([puid]),
      'friends_name': FieldValue.arrayUnion([username])
    });
  }

  Future denyFriendsRequest(friend_name, friend_id, puid, username) async {
    await fishCatchesCollection.document(puid).updateData({
      'friends_requests_id': FieldValue.arrayRemove([friend_id]),
      'friends_requests_name': FieldValue.arrayRemove([friend_name])
    });

    await fishCatchesCollection.document(friend_id).updateData({
      'friends_pending_id': FieldValue.arrayRemove([puid]),
      'friends_pending_name': FieldValue.arrayUnion([username])
    });
  }

  Future removePendingFriend(friend_name, friend_id, puid, username) async {
    await fishCatchesCollection.document(puid).updateData({
      'friends_pending_id': FieldValue.arrayRemove([friend_id]),
      'friends_pending_name': FieldValue.arrayRemove([friend_name])
    });

    await fishCatchesCollection.document(friend_id).updateData({
      'friends_requests_id': FieldValue.arrayRemove([puid]),
      'friends_requests_name': FieldValue.arrayRemove([username])
    });
  }

  Future removeFriend(friend_name, friend_id, puid, username) async {
    await fishCatchesCollection.document(puid).updateData({
      'friends_id': FieldValue.arrayRemove([friend_id]),
      'friends_name': FieldValue.arrayRemove([friend_name])
    });

    await fishCatchesCollection.document(friend_id).updateData({
      'friends_id': FieldValue.arrayRemove([puid]),
      'friends_name': FieldValue.arrayRemove([username])
    });
  }

  Future removeCatchesFromFriend(friend_id, puid) async {
    // loop through all friends catches and remove occurrences with the friends_id
  }

  Future addSpeciesToFriends(friends, data) async {
    for (int i = 0; i < friends.length; i++) {
      await fishCatchesCollection.document(friends[i]).updateData({
        'friends_catches': {DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(): [data[0], data[1]]}
      });
    }
  }

  Future updateAchievement(achievement, puid) async {
    await fishCatchesCollection.document(puid).updateData({
      'achievements': FieldValue.arrayRemove([achievement]),
      'achievements': FieldValue.arrayUnion([{achievement: true}])
    });
  }

  Future addNameUser(String name) async {
    return await fishCatchesCollection.document(uid).setData({
      'name': name
    });
  }

  Future updateUserData(String email, List species, String name) async {
    await generalInformationCollection.document('IOpIw5GzEBdFtx7jHUqz').updateData({
      'users': FieldValue.arrayUnion([{uid: name}])
    });

    return await fishCatchesCollection.document(uid).setData({
      'email': email,
      'uid': uid,
      'name': name,
      'species': [],
      'friends_catches': {},
      'friends_pending_id': [],
      'friends_pending_name': [],
      'friends_requests_name': [],
      'friends_requests_id': [],
      'friends_id': [],
      'friends_name': [],
      'language': "en",
      'achievements': [
        {"achievement_1": false},
        {"achievement_2": false},
        {"achievement_3": false},
        {"achievement_4": false},
        {"achievement_5": false},
        {"achievement_6": false},
        {"achievement_7": false},
        {"achievement_8": false}
        ]
    });
  }

  Future registerOthers(String firstName, String lastName,
      bool premiumUser) async {
    return await fishCatchesCollection.document(uid).setData({
      'firstname': firstName,
      'surname': lastName,
      'premium': premiumUser
    });
  }

  Future updateSpeciesList(currentUser, newSpecies) async {
    return await fishCatchesCollection.document(currentUser).updateData({
      'species': FieldValue.arrayUnion([{DateTime.now().millisecondsSinceEpoch.toString(): newSpecies}])
    });
  }
}

