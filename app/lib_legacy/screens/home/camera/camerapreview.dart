import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:fishfinder_app/screens/home/species/preview_species.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:tflite/tflite.dart';
import 'package:fishfinder_app/models/species.dart';
import 'package:fishfinder_app/screens/home/species/species.dart';
import 'package:image/image.dart' as Img;
import 'package:shared_preferences/shared_preferences.dart';

// @author Ian Ronk
// @class DisplayPictureScreen

// TODO Add the function of removing the image if the image is taken through the app
// TODO add loading circle

const testDevice = 'ca-app-pub-8771008967458694~3342723025';

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

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    nonPersonalizedAds: true,
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
  );


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
    var directoryPlace = directory.toString().split(" ")[1].replaceAll(RegExp(r"[\']+"), '');

    var tempImage = Img.decodeImage(await File(widget.imagePath).readAsBytes());


    new FileImage(File(widget.imagePath)).resolve(new ImageConfiguration())
    .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));

    var new_image = Img.copyCrop(tempImage, (_imageWidth / 2 - 112).round(), (_imageHeight /2 - 112).round(), 223, 223);

    var cropped = Img.copyResize(tempImage, height: 224);

//    var previewImage = widget.imagePath.split(".");
//    var previewImagePath = previewImage[0] + "_preview.png";


    var previewImagePath = (directoryPlace + '/preview.png').toString();


    File(previewImagePath).writeAsBytesSync(Img.encodePng(new_image));

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
      print(_recognitions);
      // convert the index from the list to a species object
      Species speciesType = Species.fromJSON(speciesName);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => PreviewSpeciesScreen(index: _recognitions[0]['index'], uid: widget.uid, img: previewImagePath),
          settings: RouteSettings(
              arguments: speciesType
          )
      )
      );
    }
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


    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          scansLeft += rewardAmount;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);

    return Scaffold(
      // The image is extracted from either gallery or made picture
      body: Stack(
        children: <Widget>[
          // Get image file by file path
          Image.file(File(widget.imagePath),fit: BoxFit.cover, height: double.infinity, width: double.infinity, alignment: Alignment.center),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Opacity(
                opacity: 0.4,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2 - 112,
                  color: Colors.blue,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 132,
                        height: 224,
                        color: Colors.blue
                    ),
                  ),
                  SizedBox(
                      width: 264,
                      height: 224
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 132,
                        height: 224,
                        color: Colors.blue
                    ),
                  ),
                ],
              ),
              Opacity(
                opacity: 0.4,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2 - 112,
                    color: Colors.blue
                ),
              ),
            ],
          ),

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
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {

          var scanAmount = await ScansAmount();
          print(scanAmount);

          if (scanAmount >= 0) {
            await getScansAmount();
            await predictImagePicker();
          }
          else {
            showDialog(context: context,
                barrierDismissible: false,
                child: AlertDialog(
                  title: Text("No More Scans"),
                  content: Text("No Scans Remaining, Watch an ad for 3 more scans"),
                  actions: [
                    FlatButton(child: Text("Watch an Ad"), onPressed: () async {
                      await RewardedVideoAd.instance.load(
                          adUnitId: RewardedVideoAd.testAdUnitId,
                          targetingInfo: targetingInfo);
                      await RewardedVideoAd.instance.show();
                    }),
                    FlatButton(child: Text("Dismiss"), onPressed: () {Navigator.of(context).pop(widget);})
                  ],

                )
            );
          }
        },
        label: Row(
          children: <Widget>[Text("SCAN"), SizedBox(width: 10), Icon(Icons.done)],
        ),
        icon: Container(),
        backgroundColor: Color(0xff63d5fb),
        splashColor: Color(0xff6bf2eb),
      ),
    );
  }
}
