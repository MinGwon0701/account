import 'dart:math';

import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  Random random = new Random();
  int index = 0;
  List colors = [Colors.blueAccent, Colors.lightBlue, Colors.lightBlueAccent, Colors.blue];

  void selectColor() {
    setState(() => index = random.nextInt(4));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: ListWheelScrollView(
          itemExtent: 50,
          diameterRatio: 1.5,
          children: [
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),
            Container(
              width: size.width * 0.85,
              color: colors[index],
              child: Text('data'),
            ),


          ],
        ));
  }
}
