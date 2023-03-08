import 'dart:async';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:fishfinder_app/routes.dart';

// @author Ian Ronk
// @class MyApp

List<CameraDescription> cameras;

// Add a future to app
Future<Null> main() async {
  // Set the app
  WidgetsFlutterBinding.ensureInitialized();
  cameras  = await availableCameras();
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of the application
  @override
  Widget build(BuildContext context) {
    // Get stream of information and pass down user
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,

      ),
    );
  }
}
