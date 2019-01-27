import 'package:r_flutter/src/generator/generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';

DartClass generateFontClass(List<String> fonts) {
  if (fonts.length == 0) {
    return null;
  }
  String classString = "class Fonts {\n";
  for (var font in fonts) {
    classString +=
        "  static const String ${createVariableName(font)} = \"$font\";\n";
  }
  classString += "}\n";
  return DartClass(code: classString);
}
