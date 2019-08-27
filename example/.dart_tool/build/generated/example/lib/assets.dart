import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class StringsBinding {
  String get appName => Intl.message("", name: "appName");
  String get string1 => Intl.message("", name: "string1");
  String stringWithPlaceholder(String placeholder) {
    return Intl.message("", name: "stringWithPlaceholder", args: [placeholder]);
  }
  String get hello => Intl.message("", name: "hello");
  String get withLineBreak => Intl.message("", name: "withLineBreak");
  String get hello_there => Intl.message("", name: "hello_there");
}

class Assets {
  static const String assetsTestAsset = "assets/test_asset.txt";
  static const String assetsSubTestAsset = "assets/sub/test_asset.txt";
  static const String subSubTestAsset = "assets/sub/sub/test_asset.txt";
  static const String testAsset2 = "assets/test_asset2.txt";
  static const String aesset = "assets/äßet.txt";
  static const String temp = "assets/sub/temp.txt";
  static const String sub2 = "assets/sub2/sub2.txt";
}

class Images {
  static AssetImage get extension => const AssetImage("assets/extension.png");
}

