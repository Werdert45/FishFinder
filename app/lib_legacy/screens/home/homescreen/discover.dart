import 'package:camera/camera.dart';
import 'package:fishfinder_app/services/calculations/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image/image.dart' as img;

// Positioning of tiles
// First the last one, due to easier modulo operations
List positioning = [[1,1], [1,1], [1,1], [1,2], [2,1], [1,1], [1,1]];

List<Widget> _tiles = const <Widget>[
  const _PictureTileTile(Colors.green, Icons.widgets),
  const _PictureTileTile(Colors.lightBlue, Icons.wifi),
  const _PictureTileTile(Colors.amber, Icons.panorama_wide_angle),
  const _PictureTileTile(Colors.brown, Icons.map),
  const _PictureTileTile(Colors.deepOrange, Icons.send),
  const _PictureTileTile(Colors.indigo, Icons.airline_seat_flat),
  const _PictureTileTile(Colors.red, Icons.bluetooth),
  const _PictureTileTile(Colors.pink, Icons.battery_alert),
  const _PictureTileTile(Colors.green, Icons.widgets),
  const _PictureTileTile(Colors.lightBlue, Icons.wifi),
  const _PictureTileTile(Colors.amber, Icons.panorama_wide_angle),
  const _PictureTileTile(Colors.brown, Icons.map),
  const _PictureTileTile(Colors.deepOrange, Icons.send),
  const _PictureTileTile(Colors.indigo, Icons.airline_seat_flat),
  const _PictureTileTile(Colors.red, Icons.bluetooth),
  const _PictureTileTile(Colors.pink, Icons.battery_alert),
];

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {

  List<StaggeredTile> staggeredTileGeneration() {

    List<StaggeredTile> _staggeredTiles = [];

    for (int i = 0; i < _tiles.length; i++) {
      _staggeredTiles.add(StaggeredTile.count(positioning[i % positioning.length][0], positioning[i % positioning.length][1]));
    }

    return _staggeredTiles;
  }


  @override
  Widget build(BuildContext context) {

    List<StaggeredTile> _staggeredTiles = staggeredTileGeneration();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Discover", style: TextStyle(fontSize: 34)),
          ),
          SizedBox(height: 10),
          // Row with icons as tabs
          //
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: [
//              Container(
//                width: 60,
//                height: 60,
//                child: Column(
//                  children: [
//                    Icon(Icons.location_on, size: 40),
//                    Text("Nearby")
//                  ],
//                ),
//              ),
//              Container(
//                width: 60,
//                height: 60,
//                child: Column(
//                  children: [
//                    Icon(Icons.equalizer, size: 40),
//                    Text("Top")
//                  ],
//                ),
//              ),
//              Container(
//                width: 60,
//                height: 60,
//                child: Column(
//                  children: [
//                    Icon(Icons.people_outline, size: 40),
//                    Text("Friends")
//                  ],
//                ),
//              ),
//              Container(
//                width: 60,
//                height: 60,
//                child: Column(
//                  children: [
//                    Icon(Icons.filter_list, size: 40),
//                    Text("Filter")
//                  ],
//                ),
//              )
//            ],
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 20,),
                    SizedBox(width: 5),
                    Text("Nearby", style: TextStyle(fontSize: 14))
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group, size: 20),
                    SizedBox(width: 5),
                    Text("Friends", style: TextStyle(fontSize: 14))
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.equalizer, size: 20,),
                    SizedBox(width: 5),
                    Text("Top", style: TextStyle(fontSize: 14))
                  ],
                ),
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 210,
            child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: new StaggeredGridView.count(
                  crossAxisCount: 3,
                  staggeredTiles: _staggeredTiles,
                  children: _tiles,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  padding: const EdgeInsets.all(0),
                )),
          ),
        ],
      ),
    );
  }
}

class _PictureTileTile extends StatelessWidget {
  const _PictureTileTile(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;



  @override
  Widget build(BuildContext context) {

    var image = Image.network('https://image.shutterstock.com/image-photo/gold-fish-isolated-on-white-260nw-580306465.jpg');
    return Padding(
      padding: EdgeInsets.all(0),
        child: new Container(
//      color: backgroundColor,
            decoration: BoxDecoration(
                color: backgroundColor,
//                borderRadius: BorderRadius.circular(5),
//                image: DecorationImage(
//                    image: NetworkImage('https://image.shutterstock.com/image-photo/gold-fish-isolated-on-white-260nw-580306465.jpg'),
//                    fit: BoxFit.fill
//                )
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: constraints.maxWidth,
                        height: 50,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Snoekbaars", style: TextStyle(color: Colors.white, fontSize: 16)),
                              SizedBox(height: 3),
                              Text("Ian Ronk", style: TextStyle(color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          )
    );
  }
}
