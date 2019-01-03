import 'package:flutter/material.dart';
import 'package:tmfx/app_state.dart';
import 'package:tmfx/auth_provider.dart';
import 'package:tmfx/screens/login.dart';
import 'package:tmfx/screens/home.dart';
import 'app_state.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_SIGNED_IN,
  SIGNED_IN,
}

class RootPage extends StatefulWidget {

  final AppState state;

  const RootPage({Key key, this.state}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  void didChangeDependencies() {

    AuthProvider.of(context).auth.currentUser().then((user) {
      setState(() {
        authStatus =
        user == null ? AuthStatus.NOT_SIGNED_IN : AuthStatus.SIGNED_IN;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SIGNED_IN;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_SIGNED_IN;
    });
  }


  Widget _buildWaitingScreen() { 
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();

      case AuthStatus.NOT_SIGNED_IN:

        return new LoginPage(
          title: "Login",
          onSignIn: _signedIn,
        );

      case AuthStatus.SIGNED_IN:
        return new Home(
          onSignOut: _signedOut,
        );

    }
  }
}
