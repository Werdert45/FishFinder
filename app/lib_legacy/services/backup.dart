import 'dart:convert';
import 'dart:io';

import 'package:fishfinder_app/models/syncDB.dart';
import 'package:path_provider/path_provider.dart';

class SyncBackup {
  backupLocally(document) {
    return syncDB(
        document['achievements'],
        document['email'],
        document['friends_catches'],
        document['friends_id'],
        document['language'],
        document['species'],
        document['uid']).toJSON();
  }
}


Future jsonSave(jsonObject) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = await directory.path;
  final file = File('$path/local_sync.json');
  return file.writeAsString(jsonObject.toString());
}

//jsonSave(jsonObject);

Future jsonLoad() async {
  final directory = await getApplicationDocumentsDirectory();
  final path = await directory.path;
  final file = File('$path/local_sync.json');

  String sync = await file.readAsString();
  return sync;
}

