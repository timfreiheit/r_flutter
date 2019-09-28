import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'asset_classes.dart';
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

class Fonts {
  static const String testFont = "TestFont";
}

class Assets {
  /// ![](file:///Users/user/path/lib/assets/sub/sub/test_asset.txt)
  static const String subSubTestAsset = "lib/assets/sub/sub/test_asset.txt";
  /// ![](file:///Users/user/path/lib/assets/sub/test_asset.txt)
  static const String assetsSubTestAsset = "lib/assets/sub/test_asset.txt";
  /// ![](file:///Users/user/path/lib/assets/sub/temp.txt)
  static const String temp = "lib/assets/sub/temp.txt";
  /// ![](file:///Users/user/path/lib/assets/sub2/sub2.txt)
  static const String sub2 = "lib/assets/sub2/sub2.txt";
  /// ![](file:///Users/user/path/lib/assets/svg.svg)
  static const SvgFile svg = SvgFile("lib/assets/svg.svg");
  /// ![](file:///Users/user/path/lib/assets/test_asset2.txt)
  static const String testAsset2 = "lib/assets/test_asset2.txt";
  /// ![](file:///Users/user/path/lib/assets/%C3%A4%C3%9Fet.txt)
  static const String aesset = "lib/assets/äßet.txt";
}

class Images {
  /// ![](file:///Users/user/path/lib/assets/extension.png)
  static AssetImage get extension => const AssetImage("lib/assets/extension.png");
}

