import 'dart:io';
import 'package:r_flutter/src/assets_parser.dart';
import 'package:r_flutter/src/strings_parser.dart';
import 'package:recase/recase.dart';

class Output {
  final List<String> fonts;
  final List<Asset> assets;
  final List<StringReference> stringReferences;

  Output({
    this.fonts,
    this.assets,
    this.stringReferences,
  });

  String generateFile() {
    String outputString = "";
    outputString += _generateStringBindingClass(stringReferences);
    outputString += "\n";
    outputString += _generateFontClass(fonts);
    outputString += "\n";
    outputString += _generateAssetsClass(assets);
    return outputString;
  }
}

String _generateFontClass(List<String> fonts) {
  String classString = "class Fonts {\n";
  for (var font in fonts) {
    classString +=
        "  static const String ${_createVariableName(font)} = \"$font\";\n";
  }
  classString += "}\n";
  return classString;
}

String _generateAssetsClass(List<Asset> assets) {
  String classString = "class Assets {\n";
  for (var asset in assets) {
    classString +=
        "  static const String ${_createVariableName(asset.name)} = \"${asset.path}\";\n";
  }
  classString += "}\n";
  return classString;
}

String _generateStringBindingClass(List<StringReference> stringReferences) {
  if (stringReferences.isEmpty) {
    return "";
  }

  String classString = "import 'package:intl/intl.dart';\n\nclass StringsBinding {\n";
  for (var ref in stringReferences) {
      if (ref.placeholders.isEmpty) {
        classString +=
        '  String get ${ref.name} => Intl.message("", name: "${ref.name}");\n';
      } else {
        classString +=
        '  String ${ref.name}(';
        for (var placeholder in ref.placeholders) {
          if (!classString.endsWith("(")){
            classString += ", ";
          }
          classString += "String ${placeholder}";
        }
        classString += ") {\n";
        classString += '    return Intl.message("", name: "${ref.name}", args: ['; // number])
        for (var placeholder in ref.placeholders) {
          if (!classString.endsWith("[")){
            classString += ", ";
          }
          classString += placeholder;
        }
        classString += "]);\n";
        classString += "  }\n";
      }
  }
  classString += "}\n";
  return classString;
}

String _createVariableName(String name) {
  return ReCase(name)
      .camelCase
      .replaceAll(r"ä", "ae")
      .replaceAll(r"ö", "oe")
      .replaceAll(r"ü", "ue")
      .replaceAll(r"Ä", "Ae")
      .replaceAll(r"Ö", "Oe")
      .replaceAll(r"Ü", "Üe")
      .replaceAll(r"ß", "ss")
      .replaceAll(RegExp(r"[^a-zA-Z0-9]"), "");
}
