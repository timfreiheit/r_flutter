import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'assets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'r_flutter',
      supportedLocales: I18n.supportedLocales,
      localizationsDelegates: [
        I18n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(I18n.of(context).appName)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image(image: Images.extension),
            Assets.svg,
            Text(Assets.testAsset2),
            Text(I18n.of(context).hello_there),
            Text(I18n.of(context).stringWithPlaceholder('hello')),
          ],
        ),
      ),
    );
  }
}

// this is only needed to run r_flutter tests
// do not add this in your own app
// ignore_for_file: undefined_identifier, undefined_function, uri_does_not_exist
