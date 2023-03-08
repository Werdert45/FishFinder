import 'dart:async';
import 'package:fishfinder_app/models/user.dart';
import 'package:fishfinder_app/screens/app/main_pages/homepage.dart';
import 'package:fishfinder_app/screens/authentication/authentication_pages/register.dart';
import 'package:fishfinder_app/screens/authentication/authentication_pages/sign_in.dart';
import 'package:fishfinder_app/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

// @author Ian Ronk
// @class MyApp

List<CameraDescription> cameras;

// Add a future to app
Future<Null> main() async {
  // Set the app
  WidgetsFlutterBinding.ensureInitialized();
  cameras  = await availableCameras();
  print(cameras);
  runApp(new MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of the application
  @override
  Widget build(context) {
    // Get stream of information and pass down user
    print(cameras);

    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.teal,
        ),
        home: Wrapper(cameras: cameras),
//        initialRoute: '/',
        routes: <String, WidgetBuilder>{
        '/signup': (context) => new SignUpPage(),
        '/login': (context) => new LoginPage(),
        '/homepage': (context) => new HomePage(cameras),
      },

      ),
    );
  }
}
