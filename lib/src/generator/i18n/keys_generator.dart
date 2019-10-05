import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

DartClass generateI18nKeysClass(I18nLocales locales) {
  String classString = "class I18nKeys {\n";

  final items = locales.defaultValues.strings;
  for (var item in items) {
    classString += "  static const String ${item.escapedKey} = \"${item.key}\";\n";
  }

  classString += "}\n";
  return DartClass(code: classString);
}