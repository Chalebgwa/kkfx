import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tmfx/auth_provider.dart';
import 'root.dart';
import 'auth.dart';
import 'app_state_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KKFX',
        theme: ThemeData(
          primaryColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.amber,
          ),
        ),
        home: RootPage(),
      ),
    );
  }
}