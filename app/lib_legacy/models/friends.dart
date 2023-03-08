class Friends {
  String friends_name;
  String friends_uid;

  Friends(this.friends_name, this.friends_uid);

  @override

  List list() {
    return [this.friends_name, this.friends_uid];
  }
}