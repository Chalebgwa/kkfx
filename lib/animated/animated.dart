import 'package:flutter/material.dart';

class Screen extends StatelessWidget{
  const Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
  const Candle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100,
      width: 10,
      color: Colors.red,
    );

  }

}

