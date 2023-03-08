import 'package:camera/camera.dart';
import 'package:fishfinder_app/screens/authenticate/authenticate.dart';
import 'package:fishfinder_app/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/home/homescreen/dashboard.dart';

class Wrapper extends StatefulWidget {
  // Set cameras, to pass down to other screens
  final List<CameraDescription> cameras;
  Wrapper({this.cameras});



  @override
  _WrapperState createState() => _WrapperState();
}


class _WrapperState extends State<Wrapper> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if the user is instantiated by either register or login, user != null
    final user = Provider.of<User>(context);

    if (user == null) {
      // return authenticate screen
      return Authenticate(widget.cameras);
    } else {
      // pass camera element to main menu

      return HomePage(widget.cameras);
    }
  }
}

