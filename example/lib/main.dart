import 'package:flutter/material.dart';
import 'assets.dart';
import 'localization.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r_flutter',
      localizationsDelegates: [
        StringsDelegate({'en'})
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(Assets.testAsset2),
            Text(Strings.of(context).appName),
            Text(Strings.of(context).stringWithPlaceholder('hello')),
          ],
        ),
      ),
    );
  }
}
