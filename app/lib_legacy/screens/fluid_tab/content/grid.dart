import 'package:flutter/material.dart';

class GridContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.aspectRatio > 1;
    var columnCount = isLandscape ? 3 : 2;

    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 20),
      child: GridView.count(
        crossAxisCount: columnCount,
        children: List.generate(20, (index) {
          return Text("Test2");
        }),
      ),
    );
  }
}

