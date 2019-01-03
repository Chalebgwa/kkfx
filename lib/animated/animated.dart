import 'package:flutter/material.dart';

class Screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: <Widget>[
            Candle(),
            Candle(),
            Candle(),
          ],
        ),
      ),
    );
  }

}

class Candle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      width: 10,
      color: Colors.red,
    );

  }

}

