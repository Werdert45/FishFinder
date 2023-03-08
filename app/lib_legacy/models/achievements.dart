class AchievementsModel {
  String achievement;
  bool achieved;

  AchievementsModel(this.achievement, this.achieved);

  @override

  List list() {
    return [this.achievement, this.achieved];
  }
}

