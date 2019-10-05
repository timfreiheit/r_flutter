import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'i18n_generator_utils.dart';

DartClass generateI18nDelegate(I18nLocales locales) {
  String classString =
      """class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  Future<I18n> load(Locale locale) {
    I18n._locale = locale;
    return SynchronousFuture<I18n>(I18n(_findLookUpFromLocale(locale)));
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  bool shouldReload(I18nDelegate old) => false;

  I18nLookup _findLookUpFromLocale(Locale locale) {
""";

  List<Locale> localesWithCountry = findLocalesWithCountry(locales);
  if (localesWithCountry.isNotEmpty) {
    classString +=
        "    final String lang = locale != null ? locale.toString() : \"\";\n";
    classString += _generateLookupSwitch("lang", localesWithCountry);
  }

  List<Locale> localesWithoutCountry = findLocalesWithoutCountry(locales);
  if (localesWithoutCountry.isNotEmpty) {
    classString +=
        "    final String languageCode = locale != null ? locale.languageCode : \"\";\n";

    classString += _generateLookupSwitch("languageCode", localesWithoutCountry);
  }

  classString +=
      "    return I18nLookup_${locales.defaultLocale.toString()}();\n";
  classString += "  }\n";

  classString += "}\n";
  return DartClass(
    code: classString,
    imports: [
      'package:flutter/foundation.dart',
      'package:flutter/widgets.dart'
    ],
  );
}

String _generateLookupSwitch(String condition, List<Locale> locales) {
  String switchCode = "";
  switchCode += "    switch ($condition) {\n";

  for (var locale in locales) {
    switchCode += "        case \"${locale.toString()}\":\n";
    switchCode += "          return I18nLookup_${locale.toString()}();\n";
  }

  switchCode += "    }\n";
  return switchCode;
}
