class friendsCatch {
  String timestamp;
  List info;

  friendsCatch(this.timestamp, this.info);

  @override

  List list() {
    return [this.timestamp, this.info];
  }
}

class userCatch {
  String timestamp;
  int index;

  userCatch(this.timestamp, this.index);

  @override

  int catchIndex() {
    return this.index;
  }

  String catchTime() {
    return this.timestamp;
  }
}