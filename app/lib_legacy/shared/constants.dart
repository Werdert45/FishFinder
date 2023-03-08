import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/intl.dart';


// @author Ian Ronk
// @constants textInputDecoration

// TODO insert these constants into the app and generalize styling

// STYLES
const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.pink, width: 2.0),
  ),
);

const linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xff63d5fb), Color(0xff6bf2eb)]);


const goldLinearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xfff0db51), Color(0xfffcdd0f)]);

// FUNCTIONALITY
most_frequent(List list) {
  var map = Map();
  var new_list = List();
  var most_frequent = 0;
  int amount = 0;

  list.forEach((element) {
    if(!map.containsKey(element)) {
      map[element] = 1;
    }
    else {
      map[element] += 1;
    }
  });

  map.forEach((k,v) => new_list.add([k,v]));

  for (var i = 0; i < new_list.length; i++) {
    if (new_list[i][1] >= amount) {
      amount = new_list[i][1];
      most_frequent = new_list[i][0];
    }
  }

  return [most_frequent, amount, index_show];
}

index_show(int index) {
  String index_show;

  if (index < 10) {
    index_show = "00" + index.toString();
  }

  else {
    index_show = "0" + index.toString();
  }

  return index_show;
}

// Get the current users
getUser() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseUser user = await _auth.currentUser();
  String uid = user.uid;
  return uid.toString();
}

getSpeciesList() async {
  var document = Firestore.instance.collection('fish_catches').where(getUser().toString()).snapshots();

}


showPreviewString(String string, int length) {
  if (string.length < length) {
    return string;
  }
  else {
    String substring = string.substring(0,length);
    return substring + "...";
  }

}

formatString(String str) {
  var splitStr = str.toLowerCase().split(' ');
  for (var i = 0; i < splitStr.length; i++) {
    // You do not need to check if i is larger than splitStr length, as your for does that for you
    // Assign it back to the array
    splitStr[i] = splitStr[i][0].toUpperCase() + splitStr[i].substring(1);
  }
  // Directly return the joined string
  return splitStr.join(' ');
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  print(now);
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now).abs();
  var time = '';

  if (diff.inDays < 1) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}
