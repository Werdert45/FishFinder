import 'package:camera/camera.dart';
import 'package:fishfinder_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fishfinder_app/screens/authentication/authentication_pages/sign_in.dart';
import 'package:fishfinder_app/screens/authentication/authentication_pages/register.dart';

// @author Ian Ronk
// @class Welcome

class Welcome extends StatefulWidget {

  // toggleView is true, will show the Welcome page
  final Function toggleView;
  final List<CameraDescription> cameras;
  Welcome({ this.toggleView, this.cameras});

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage(cameras: widget.cameras))
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff63d5fb).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xff63d5fb)),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage(cameras: widget.cameras))
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Quick login with Touch ID',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(
              height: 20,
            ),
            Icon(Icons.fingerprint, size: 90, color: Colors.white),
            SizedBox(
              height: 20,
            ),
            Text(
              'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ));
  }

  Widget _title() {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 20),
            child: Image(image: AssetImage('assets/images/animation.png'), width: 180, height: 250)
        ),
        Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'fi',
                style: GoogleFonts.portLligatSans(
                  textStyle: Theme.of(context).textTheme.display1,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff046c8e),
                ),
                children: [
                  TextSpan(
                    text: 'sh',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  TextSpan(
                    text: 'Fin',
                    style: TextStyle(color: Color(0xff046c8e), fontSize: 30),
                  ),
                  TextSpan(
                    text: 'der',
                    style: TextStyle(color: Colors.black, fontSize: 30),
                  ),
                ]),
          )
        )
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: linearGradient
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _title(),
                  SizedBox(height: 140),
                  _submitButton(),
                  SizedBox(height: 20),
                  _signUpButton(),
                ],
              ),
            )
        )
    );
  }
}