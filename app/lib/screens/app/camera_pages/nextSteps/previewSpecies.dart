import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewSpeciesScreen extends StatefulWidget {
  final species_list;

  PreviewSpeciesScreen({ this.species_list });

  @override
  _PreviewSpeciesScreenState createState() => _PreviewSpeciesScreenState();
}

class _PreviewSpeciesScreenState extends State<PreviewSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.arrow_back_ios)),
                SizedBox(width: 220, child: Text("Select Species", style: TextStyle(fontSize: 28))),
                SizedBox()
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height - 95,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index)
                {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 170,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
//                                color: color['foregroundColor'],
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 200,
                              height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0)),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/preview/' +
                                          widget.species_list[index]['label'].toLowerCase() +
                                              '.jpg'),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(widget.species_list[index]['label'])
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: widget.species_list.length,
              )
            )
          ],
        ),
      ),
    );
  }
}
