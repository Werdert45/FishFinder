import 'package:flutter/material.dart';


class HomeContent extends StatelessWidget {

  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView.builder(
        itemCount: 9,
        itemBuilder: (content, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text("Test3"),
          );
        },
      ),
    );
  }
}

