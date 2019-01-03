
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmfx/app_state.dart';
import 'package:tmfx/auth.dart';

class AuthProvider extends StatefulWidget {

  final BaseAuth auth;
  final Widget child;
  final AppState state;

  const AuthProvider({Key key, this.auth, this.child, this.state}) : super(key: key);

  @override
  AuthProviderState createState() {
    return new AuthProviderState();
  }

  static _InheritedContainer of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_InheritedContainer) as _InheritedContainer);
  }


}

class AuthProviderState extends State<AuthProvider> {

  AppState state;

  @override
  void initState() {
    super.initState();
    if(widget.state != null){
      state = widget.state;
    } else {
      state = new AppState.loading();
      startCountdown();
    }
  }


  Future<Null> startCountdown() async {
    const timeOut = const Duration(seconds: 1000);
    new Timer(timeOut, () {
      setState(() => state.isLoading = false);
    });
  }


  @override
  Widget build(BuildContext context) {
    return _InheritedContainer(
      child: widget.child,
      auth: widget.auth,
    );
  }
}

class _InheritedContainer extends InheritedWidget {

  final Widget child;
  final BaseAuth auth;


  _InheritedContainer({Key key,this.child,this.auth}) : super(key:key,child:child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}