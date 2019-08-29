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
  String get xxxx => Intl.message("", name: "xxxx");
}

class Fonts {
  static const String testFont = "TestFont";
}

class Assets {
  static const String testAsset2 = "lib/assets/test_asset2.txt";
  static const String aesset = "lib/assets/äßet.txt";
  static const String temp = "lib/assets/sub/temp.txt";
  static const String assetsSubTestAsset = "lib/assets/sub/test_asset.txt";
  static const String subSubTestAsset = "lib/assets/sub/sub/test_asset.txt";
  static const String test = "lib/assets/sub/ignore2/test.txt";
  static const String sub2 = "lib/assets/sub2/sub2.txt";
}

class Images {
  static AssetImage get extension => const AssetImage("lib/assets/extension.png");
}

