import 'dart:io';
import 'package:r_flutter/src/assets_parser.dart';
import 'package:recase/recase.dart';

class Output {
  final List<String> fonts;
  final List<Asset> assets;

  Output({this.fonts, this.assets});

  String generateFile() {
    String outputString = "";
    outputString += _generateFontClass(fonts);
    outputString += "\n";
    outputString += _generateAssetsClass(assets);
    return outputString;
  }
}

String _generateFontClass(List<String> fonts) {
  String classString = "class Fonts {\n";
  for (var font in fonts) {
    String fontName = ReCase(font).camelCase;
    classString += "  static const String $fontName = \"$font\";\n";
  }
  classString += "}\n";
  return classString;
}

String _generateAssetsClass(List<Asset> assets) {
  String classString = "class Assets {\n";
  for (var asset in assets) {
    String assetName = ReCase(asset.name).camelCase;
    classString += "  static const String $assetName = \"${asset.path}\";\n";
  }
  classString += "}\n";
  return classString;
}
