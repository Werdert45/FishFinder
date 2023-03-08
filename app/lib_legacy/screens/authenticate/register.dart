import 'package:camera/camera.dart';
import 'package:fishfinder_app/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fishfinder_app/services/auth.dart';
import 'Widget/bezierContainer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fishfinder_app/shared/constants.dart';

class SignUpPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  SignUpPage({Key key, this.title, this.cameras}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  // Set variables for user information from Firebase
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String error = '';

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
        onTap: () async {
          // onPressed, check if the form is submitted and register email in Firebase and user != null
          if (_formKey.currentState.validate()) {
            dynamic result = await _auth.registerWithEmail(email, password, name);
            Navigator.pop(context);
            if (result == null) {
              setState(() => error = 'please supply a valid email');
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
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
          child: Text(
            'Register Now',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
    );
  }

  Widget _loginAccountLabel() {
    return Container(

      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LoginPage())
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: Color(0xff63d5fb),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              )
            )

          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child:Container(
              height: MediaQuery.of(context).size.height,
              child:Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        _title(),
                        SizedBox(
                          height: 50,
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                                children: <Widget>[
                                  TextFormField(
                                      validator: (val) => val.isEmpty ? 'Enter your name' : null,
                                      decoration: textInputDecoration.copyWith(hintText: 'Name'),
                                      onChanged: (val) {
                                        setState(() => name = val);
                                      }
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                                      decoration: textInputDecoration.copyWith(hintText: 'Email'),
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      }
                                  ),
                                  SizedBox(height: 15),
                                  TextFormField(
                                    validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: true,
                                  ),
                                ])
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _loginAccountLabel(),
                  ),
                  Positioned(top: 40, left: 0, child: _backButton()),
                  Positioned(
                      top: -MediaQuery.of(context).size.height * .25,
                      right: -MediaQuery.of(context).size.width * .45,
                      child: BezierContainer())
                ],
              ),
            )
        )
    );
  }
}