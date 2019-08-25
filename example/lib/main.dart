import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:r_flutter/localization.dart';

final i18n = StringsBinding();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r_flutter',
      localizationsDelegates: [
        RuntimeArbDelegate({'en'})
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
            Text(i18n.appName),
            Text(i18n.stringWithPlaceholder('hello')),
          ],
        ),
      ),
    );
  }
}
