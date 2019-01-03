import 'package:flutter/material.dart';
import 'package:tmfx/auth_provider.dart';
import 'root.dart';
import 'auth.dart';
import 'app_state_container.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth:new Auth(),
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KKFX',

        theme: new ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.amber
        ),
        home: new RootPage(),
      ),
    );
  }
}