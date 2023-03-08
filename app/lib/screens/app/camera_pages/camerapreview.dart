import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:fishfinder_app/screens/app/camera_pages/nextSteps/previewSpecies.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:fishfinder_app/screens/home/species/preview_species.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:tflite/tflite.dart';
//import 'package:fishfinder_app/models/species.dart';
//import 'package:fishfinder_app/screens/home/species/species.dart';
import 'package:image/image.dart' as Img;
import 'package:shared_preferences/shared_preferences.dart';

// @author Ian Ronk
// @class DisplayPictureScreen

// TODO Add the function of removing the image if the image is taken through the app
// TODO add loading circle

//const testDevice = 'ca-app-pub-8771008967458694~3342723025';

class DisplayPictureScreen extends StatefulWidget {

  // Get path to image
  final String imagePath;
  final String uid;
  const DisplayPictureScreen({Key key, this.imagePath, this.uid}) : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  File _image;
  List _recognitions;
  List test;
  double _imageHeight;
  double _imageWidth;
  bool _busy = false;

  int scansLeft = 5;



  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getScansAmount() async {
    final prefs = await _prefs;

    if (prefs.getInt("scansAmount") == null) {
      await prefs.setInt("scansAmount", 5);
    }

    var scansAmount = prefs.getInt("scansAmount");

    await prefs.setInt("scansAmount", scansAmount - 1);

    return prefs.getInt("scansAmount");
  }

  Future ScansAmount() async {
    final prefs = await _prefs;

    if (prefs.getBool("premiumSubscription")) {
      return 1;
    }

    return prefs.getInt("scansAmount");
  }

  Future updateScansAmount() async {
    final prefs = await _prefs;

    if (prefs.getInt("scansAmount") == 0) {
      return false;
    }

    return true;
  }

  Future predictImagePicker() async {
    var directory = await getApplicationDocumentsDirectory();
    var directoryPlace = directory.toString().split(" ")[1].replaceAll(
        RegExp(r"[\']+"), '');

    var tempImage = Img.decodeImage(await File(widget.imagePath).readAsBytes());


    new FileImage(File(widget.imagePath)).resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));
//
//    var new_image = Img.copyCrop(tempImage, (_imageWidth / 2 - 112).round(),
//        (_imageHeight / 2 - 112).round(), 223, 223);

    var cropped;

    if (_imageHeight > _imageWidth)
    {
      cropped = Img.copyResize(tempImage, height: 224);
    }
    else
    {
      cropped = Img.copyResize(tempImage, width: 224);
    }
//    var previewImage = widget.imagePath.split(".");
//    var previewImagePath = previewImage[0] + "_preview.png";


    var previewImagePath = (directoryPlace + '/preview.png').toString();


    File(previewImagePath).writeAsBytesSync(Img.encodePng(cropped));

    var image = await File(previewImagePath);
    if (image == null) return;
    setState(() {
      _busy = true;
    });

    if (image == null) return;

    setState(() {
      _image = image;
      _busy = false;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _recognitions = recognitions;
    });

    String speciesList = await DefaultAssetBundle.of(context).loadString(
        'assets/json/species.json');
    List<dynamic> species = json.decode(speciesList);

    var speciesName = species[_recognitions[0]['index']];

    // Check if _recognitions are made
    if (_recognitions != null) {
      return _recognitions;

//      print(_recognitions);
    }
  }

  Future getImageInformation() async {
    var directory = await getApplicationDocumentsDirectory();
//    var directoryPlace = directory.toString().split(" ")[1].replaceAll(
//        RegExp(r"[\']+"), '');

//    var tempImage = Img.decodeImage(await File(widget.imagePath).readAsBytes());


    new FileImage(File(widget.imagePath)).resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    return [_imageHeight, _imageWidth];
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/tflite/fishfinder.tflite",
      labels: "assets/tflite/labels.txt",
    );
  }


  @override
  void initState() {
    super.initState();

    _busy = true;

    loadModel().then((val) {
      setState(() {
        _busy = false;
      });
    });


//    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//    RewardedVideoAd.instance.listener =
//        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//      print("RewardedVideoAd event $event");
//      if (event == RewardedVideoAdEvent.rewarded) {
//        setState(() {
//          scansLeft += rewardAmount;
//        });
//      }
//    };
//  }

  }


  Widget build(BuildContext context) {

    return Scaffold(
      // The image is extracted from either gallery or made picture
      body: FutureBuilder(
        future: getImageInformation(),
        builder: (context, snapshot) {

          return Stack(
            children: <Widget>[
              // Get image file by file path
              snapshot.data[0] < snapshot.data[1] ?
              Image.file(File(widget.imagePath), fit: BoxFit.fitWidth,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center)
                  :
              Image.file(File(widget.imagePath), fit: BoxFit.fitHeight,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center),

              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      margin: const EdgeInsets.only(top: 30, right: 30),
                      child: IconButton(
                        icon: Icon(Icons.clear, size: 40, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                  )
              ),


            ],
          );
        }
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
//          var scanAmount = await ScansAmount();
//          print(scanAmount);

//          if (scanAmount >= 0) {
            await getScansAmount();
            var predictions = await predictImagePicker();

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PreviewSpeciesScreen(species_list: predictions)));


//          }
//          else {
//            showDialog(context: context,
//                barrierDismissible: false,
//                child: AlertDialog(
//                  title: Text("No More Scans"),
//                  content: Text("No Scans Remaining, Watch an ad for 3 more scans"),
//                  actions: [
//                    FlatButton(child: Text("Watch an Ad"), onPressed: () async {
//                      await RewardedVideoAd.instance.load(
//                          adUnitId: RewardedVideoAd.testAdUnitId,
//                          targetingInfo: targetingInfo);
//                      await RewardedVideoAd.instance.show();
//                    }),
//                    FlatButton(child: Text("Dismiss"), onPressed: () {Navigator.of(context).pop(widget);})
//                  ],
//
//                )
//            );
//          }
        },
        label: Row(
          children: <Widget>[
            Text("SCAN"),
            SizedBox(width: 10),
            Icon(Icons.done)
          ],
        ),
        icon: Container(),
        backgroundColor: Color(0xff63d5fb),
        splashColor: Color(0xff6bf2eb),
      ),
    );
  }
}