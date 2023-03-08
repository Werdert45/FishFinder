import 'package:camera/camera.dart';
import 'package:fishfinder_app/screens/authenticate/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fishfinder_app/shared/constants.dart';
import 'Widget/bezierContainer.dart';
import 'package:fishfinder_app/services/auth.dart';

class LoginPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  LoginPage({Key key, this.title, this.cameras}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Variables for user information
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
            // Check if user exists and then login (user != null)
            if (_formKey.currentState.validate()) {
              dynamic result = await _auth.signInWithEmail(email, password);
              Navigator.pop(context, widget.cameras);

              if (result == null) {
                setState(() => error = 'No user found with this email');
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
              gradient: linearGradient),
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
    );
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {

            },
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUpPage(cameras: widget.cameras))
                );
              },
              child: Text(
                'Register',
                style: TextStyle(
                    color: Color(0xff63d5fb),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
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
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
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
                                SizedBox(height: 20),
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
                                SizedBox(height: 20),
                                Text(
                                    error,
                                    style: TextStyle(color: Colors.red, fontSize: 14.0)
                                )
                              ],
                            )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password ?',
                              style:
                              TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createAccountLabel(),
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
