import 'package:flutter/material.dart';
import 'assets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r_flutter',
      home: Scaffold(
        appBar: AppBar(),
        body: Text(Assets.testAsset2),
      ),
    );
  }
}
