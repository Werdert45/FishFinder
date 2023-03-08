import 'package:camera/camera.dart';
import 'package:fishfinder_app/screens/authentication/authentication_pages/welcome.dart';
import 'package:flutter/material.dart';

// @author Ian Ronk
// @class Authenticate

class Authenticate extends StatefulWidget {
  final List<CameraDescription> cameras;
  Authenticate(this.cameras);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  // Change view according to whether user chooses register or login
  bool showSignIn = true;

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return Welcome(cameras: widget.cameras);
  }
}