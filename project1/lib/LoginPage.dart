import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  doLogin(){
    googleSignIn().then((FirebaseUser user){
      setState(() {
        MyNavigator.goHome(context);
      });
    }).catchError((e)=>print(e.toString()));
  }
  
  Future<FirebaseUser> googleSignIn() async{
    GoogleSignInAccount gsia = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gsiauth = await gsia.authentication;
    
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: gsiauth.idToken, 
        accessToken: gsiauth.accessToken
    );
    
    FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: blue),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('img/Qu+.png', width: 200, height: 200,),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      "QUINGET REMINDER",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    FlatButton (
                      color: white,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Login via Google",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: blue,
                              ),
                            ),
                            SizedBox(width: 3),
                            FaIcon(FontAwesomeIcons.google, size: 15, color: Colors.red,),
                          ],
                        ),
                      ),
                      onPressed: (){
                        doLogin();
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
