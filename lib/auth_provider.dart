
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmfx/app_state.dart';
import 'package:tmfx/auth.dart';

class AuthProvider extends StatefulWidget {

  final BaseAuth auth;
  final Widget child;
  final AppState? state;

  const AuthProvider({Key? key, required this.auth, required this.child, this.state}) : super(key: key);

  @override
  AuthProviderState createState() {
    return AuthProviderState();
  }

  static _InheritedContainer? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<_InheritedContainer>();
  }


}

class AuthProviderState extends State<AuthProvider> {

  late AppState state;

  @override
  void initState() {
    super.initState();
    if(widget.state != null){
      state = widget.state!;
    } else {
      state = AppState.loading();
      startCountdown();
    }
  }


  Future<void> startCountdown() async {
    const timeOut = Duration(seconds: 1000);
    Timer(timeOut, () {
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

  final BaseAuth auth;


  const _InheritedContainer({Key? key, required Widget child, required this.auth}) : super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

}