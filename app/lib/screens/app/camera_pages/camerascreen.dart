import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:fishfinder_app/screens/app/camera_pages/camerapreview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:io';

// @author Ian Ronk
// @class CameraScreen

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String uid;

  CameraScreen(this.cameras, this.uid);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  // set variable to add path to
  var _path;

  CameraController controller;
  Future<void> _initializeControllerFuture;

  var scansAmount;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  Future getScansAmount() async {
    final prefs = await _prefs;

    if (prefs.getInt("scansAmount") == null) {
      await prefs.setInt("scansAmount", 5);
    }

    if (prefs.getBool("premiumSubscription")) {
      return "\u221E";
    }

    scansAmount = prefs.getInt("scansAmount");

    return scansAmount;
  }

  Future checkSubscription() async {
    final prefs = await _prefs;

    if (prefs.getBool("premiumSubscription") == null) {
      await prefs.setBool("premiumSubscription", false);
    }

    return prefs.getBool("premiumSubscription");
  }


  // function to add image from Gallery (note add extra information for iOS
  _accessGallery() async {
    // get image with ImagePicker
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    var path = picture.path;
    this.setState(() {
      _path = path;
    });
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: _path)
    ));
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[0],
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // initialize controller to return a future
    _initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: Stack(children: <Widget>[
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Container(
            margin: const EdgeInsets.only(left: 10.0, top: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    tooltip: "Go Back",
                    icon: new Icon(Icons.clear, color: Colors.white, size: 30.0),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
                FutureBuilder(
                    future: getScansAmount(),
                    builder: (context, snapshot) {
                      return Text("Scans Left:  " + snapshot.data.toString(), style: TextStyle(fontSize: 20, color: Colors.white));
                    }
                )

              ],
            )
        ),


        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      child: IconButton(icon: Icon(
                          Icons.switch_camera, color: Colors.white,
                          size: 30,
                          semanticLabel: 'Hello'), onPressed: () {
                        // TODO Flip camera
                      })),
                  new Container(
                      margin: const EdgeInsets.only(right: 20, bottom: 20),
                      child: IconButton(icon: Icon(
                          Icons.add_photo_alternate, color: Colors.white,
                          size: 30), onPressed: () {
                        _accessGallery();
                      })
                  )
                ]
            )
        ),
      ]),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.lightBlueAccent,
        child: Center(
            child: Icon(Icons.camera_alt, size: 40, color: Colors.white)),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved.
            await controller.takePicture(path);

            print(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              // TODO add route to DisplayPictureScreen
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: path, uid: widget.uid),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
