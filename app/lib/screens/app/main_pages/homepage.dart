import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/app/camera_pages/camerascreen.dart';
import 'package:fishfinder_app/screens/app/fishdex_pages/fishdex.dart';
import 'package:fishfinder_app/screens/app/main_pages/dashboard.dart';
import 'package:fishfinder_app/screens/partials/FABBottomAppBarItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final camera;

  HomePage(this.camera);


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;


  var _page = 1;


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);

    _page = 0;
  }


  void _selectPage(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    tabController.dispose();
  }

  @override
  Widget build(context) {
    var user = Provider.of<User>(context);

    var pages = <Widget>[
//      DashBoard(widget.camera),
      DashBoard(uid: user.uid),
      FishDex(widget.camera)
//      FishDex(widget.camera),
    ];

    return new Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _selectPage,
        notchedShape: CircularNotchedRectangle(),
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: "Home"),
          FABBottomAppBarItem(iconData: Icons.assignment, text: "FishDex")
        ],
      ),
      body: pages[_page],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.camera_alt, size:30, color: Colors.white),
        onPressed:() async {
//          await checkSubscription();
//          await dailyScansAmount();
          // Put camera screen on top of home screen and pass camera down
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(widget.camera, user.uid)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}