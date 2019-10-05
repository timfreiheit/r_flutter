import 'package:r_flutter/src/model/i18n.dart';

/// Escape the string for use in generated Dart code.
String escapeStringLiteral(String value) {
  const Map<String, String> escapes = const {
    r"\": r"\\",
    '"': r'\"',
    "\b": r"\b",
    "\f": r"\f",
    "\n": r"\n",
    "\r": r"\r",
    "\t": r"\t",
    "\v": r"\v",
    "'": r"\'",
    r"$": r"\$"
  };

  String _escape(String s) => escapes[s] ?? s;

  return value.splitMapJoin("", onNonMatch: _escape);
}

List<Locale> findLocalesWithCountry(I18nLocales i18n) {
  return i18n.locales
      .map((it) => it.locale)
      .where((it) => it.countryCode != null)
      .toList();
}

List<Locale> findLocalesWithoutCountry(I18nLocales i18n) {
  return i18n.locales
      .map((it) => it.locale)
      .where((it) => it.countryCode == null)
      .toList();
}

String generateMethod(
    {String resurnType = "String",
    String name,
    List<String> parameters,
    String code}) {
  String methodCode = "";
  if (parameters.isEmpty) {
    methodCode += '  $resurnType get $name {\n$code\n  }\n';
  } else {
    methodCode += '  $resurnType $name(';
    for (var parameter in parameters) {
      if (!methodCode.endsWith("(")) {
        methodCode += ", ";
      }
      methodCode += "String $parameter";
    }
    methodCode += ") {\n";
    methodCode += code;
    methodCode += "\n  }\n";
  }
  return methodCode;
}
