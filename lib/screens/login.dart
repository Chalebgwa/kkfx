import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tmfx/animated/animated.dart';
import 'package:tmfx/auth_provider.dart';
import 'package:tmfx/screens/home.dart';

class LoginPage extends StatefulWidget {
  final String title;
  final VoidCallback onSignIn;

  const LoginPage({Key key, this.title, this.onSignIn}) : super(key: key);

  @override
  State<LoginPage> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KKFX"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(icon: Icon(Icons.menu),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>new Screen()));
            },),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: AnimatedBackground(
        vsync: this,
        behaviour:
            RacingLinesBehaviour(direction: LineDirection.Ttb, numLines: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Container(
                child: Image.asset("assets/logo.png"),
              ),
            ),
            Expanded(
                flex: 3,
                child: ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      color: Colors.amber,
                      splashColor: Colors.black26,
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        AuthProvider.of(context).auth.signIn(context).then((user){
                          if(user!=null){
                            widget.onSignIn();
                          }
                        }).catchError(
                            (error){
                              Fluttertoast.showToast(msg: "error");
                            });
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
