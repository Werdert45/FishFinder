// @author Ian Ronk
// @model User

class User {
  final String uid;

  User({ this.uid });
}

class CompleteUser {
  final String uid;
  final String email;
  final String name;
  final Map catch_record;
  final Map friend_request;
  final Map pending_friends;
  final Map friends;
  final Map updates;

  CompleteUser({ this.uid, this.email, this.name, this.catch_record, this.friend_request, this.friends, this.updates, this.pending_friends });

  factory CompleteUser.fromMap(Map data) {
    data = data ?? {};
    return CompleteUser(
        uid: data['uid'] ?? '',
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        catch_record: data['catch_record'] ?? {},
        friend_request: data['friend_request'] ?? {},
        friends: data['friends'] ?? {},
        updates: data['updates'] ?? {},
        pending_friends: data['pending_friends'] ?? {}
    );
  }
}