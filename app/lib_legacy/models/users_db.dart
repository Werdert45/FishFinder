class usersDB {
  String uid;
  String name;

  usersDB(this.uid, this.name);

  @override
  List list() {
    return [this.uid, this.name];
  }
}