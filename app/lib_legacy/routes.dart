import 'package:fishfinder_app/main.dart';
import 'package:flutter/widgets.dart';
import 'package:fishfinder_app/screens/home/homescreen/dashboard.dart';
import 'package:fishfinder_app/screens/home/camera/camerascreen.dart';
import 'package:fishfinder_app/screens/wrapper.dart';
import 'package:fishfinder_app/screens/home/fishdex/fishdex.dart';

// @author Ian Ronk
// @function routes

// TODO: Get all of the routes and use them in the whole app

Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => Wrapper(cameras: cameras),
  '/home': (BuildContext context) => DashboardPage(cameras),
//  '/camera': (BuildContext context) => CameraScreen(cameras, uid),
};