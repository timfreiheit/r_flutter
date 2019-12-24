import 'package:r_flutter/src/model/i18n.dart';

/// Escape the string for use in generated Dart code.
String escapeStringLiteral(String value) {
  const Map<String, String> escapes = {
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
  final methodCode = StringBuffer("");
  if (parameters.isEmpty) {
    methodCode.writeln('  $resurnType get $name {\n$code\n  }');
  } else {
    methodCode.write('  $resurnType $name(');

    bool isFirstParameter = true;
    for (final parameter in parameters) {
      if (!isFirstParameter) {
        methodCode.write(", ");
      }
      isFirstParameter = false;
      methodCode.write("String $parameter");
    }
    methodCode.write(") {\n");
    methodCode.write(code);
    methodCode.writeln("\n  }");
  }
  return methodCode.toString();
}
