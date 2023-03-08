

getUpdates(Map updates) {
  var dates = [];
  var new_updates = [];

  updates.forEach((key, value) {
    dates.add(int.parse(key));
  });

  dates.sort();

  for (int i = 0; i < dates.length; i++) {
    var update = [];

    update.add(updates[dates[i].toString()][0]);
    update.add(updates[dates[i].toString()][1]);
    update.add(updates[dates[i].toString()][2]);
    update.add(updates[dates[i].toString()][3]);

    update.add(dates[i]);

    new_updates.add(update);
  }

  return new_updates;
}

String giveDateInformation(int time) {
  var date = DateTime.fromMillisecondsSinceEpoch(time);
  var now = DateTime.now();

  Duration difference = now.difference(date);

  if (difference.inDays*365 != 0)
  {
    return ((difference.inDays*365).toString() + "y ago");
  }

  else if (difference.inDays*7 != 0)
  {
    return ((difference.inDays*7).toString() + "w ago");
  }

  else if (difference.inDays != 0)
  {
    return ((difference.inDays).toString() + "d ago");
  }

  else if (difference.inHours != 0)
  {
    return ((difference.inHours).toString() + "h ago");
  }

  else if (difference.inMinutes != 0)
  {
    return ((difference.inMinutes).toString() + "m ago");
  }

  else {
    return "Now";
  }
}

List achievementsCalc(Map species, Map friends)
{
  List species_list = [];
  Map unique_species = {};

  List achievements = [];

  species.forEach((key, value) {
    species_list.add(value);

    if (!unique_species.containsKey(value.toString()))
    {
      unique_species[value.toString()] = value.toString();
    }
  });

  // Achievement 1: More than 5 catches
  if (species_list.length >= 5)
  {
    achievements.add("achievement_1");
  }

  // Achievement 2: More than 50 catches
  if (species_list.length >= 50)
  {
    achievements.add("achievement_2");
  }


  // Achievement 3: More than 5 friends
  if (friends.length >= 5)
  {
    achievements.add("achievement_3");
  }

  // Achievement 4: More than 25 unique catches
  if (unique_species.length >= 25)
  {
    achievements.add("achievement_4");
  }

  // Achievement 5: All species caught
  if (unique_species.length == 61)
  {
    achievements.add("achievement_5");
  }

  return achievements;
}