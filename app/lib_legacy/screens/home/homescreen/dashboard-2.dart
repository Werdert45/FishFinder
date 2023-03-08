import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/fluid_tab/content/account.dart';
import 'package:fishfinder_app/screens/fluid_tab/content/grid.dart';
import 'package:fishfinder_app/screens/fluid_tab/content/home.dart';
import 'package:fishfinder_app/screens/fluid_tab/fluid_nav_bar.dart';
import 'package:fishfinder_app/screens/home/fishdex/fishdex.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';


// @author Ian Ronk
// @class DashBoardPage

class DashBoardPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  DashBoardPage(this.cameras);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  Widget _child;
  @override

  void initState() {
    super.initState();

  }
  final AuthService _auth = AuthService();

  Widget _fishdexButton(text, link) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FishDex(widget.cameras)));
      },
      child: Container(
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }


  Widget build(BuildContext context) {
//    rebuildAllChildren(context);
    var user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Color(0xFF75B7E1),
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 200, width: double.infinity),
              FluidNavBar(onChange: _handleNavigationChange),
              Container(height: 400, width: double.infinity, color: Colors.red, child: _child)
            ],
          ),
        ),
      ),
    );

  }


  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = HomeContent();
          break;
        case 1:
          _child = AccountContent();
          break;
        case 2:
          _child = GridContent();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,);
    });
  }

}

