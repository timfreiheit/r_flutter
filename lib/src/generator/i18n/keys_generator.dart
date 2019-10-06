import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

///
/// ```dart
/// class I18nKeys {
///  static const String appName = "appName";
///  static const String string1 = "string1";
/// }
/// ```
///
DartClass generateI18nKeysClass(I18nLocales locales) {
  StringBuffer classString = new StringBuffer("class I18nKeys {\n");

  final items = locales.defaultValues.strings;
  for (var item in items) {
    classString.writeln("  static const String ${item.escapedKey} = \"${item.key}\";");
  }

  classString.writeln("}");
  return DartClass(code: classString.toString());
}