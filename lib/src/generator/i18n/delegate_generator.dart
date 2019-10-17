import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'i18n_generator_utils.dart';

///
/// ```dart
/// class I18nDelegate extends LocalizationsDelegate<I18n> {
///  const I18nDelegate();
///
///  @override
///  Future<I18n> load(Locale locale) {
///    I18n._locale = locale;
///    return SynchronousFuture<I18n>(I18n(_findLookUpFromLocale(locale)));
///  }
///
///  @override
///  bool isSupported(Locale locale) => true;
///
///  @override
///  bool shouldReload(I18nDelegate old) => false;
///
///  I18nLookup _findLookUpFromLocale(Locale locale) {
///    final String lang = locale != null ? locale.toString() : "";
///    switch (lang) {
///        case "de_AT":
///          return I18nLookup_de_AT();
///    }
///    final String languageCode = locale != null ? locale.languageCode : "";
///    switch (languageCode) {
///        case "de":
///          return I18nLookup_de();
///        case "en":
///          return I18nLookup_en();
///        case "pl":
///          return I18nLookup_pl();
///    }
///    return I18nLookup_en();
///  }
///}
/// ```
///
DartClass generateI18nDelegate(I18nLocales locales) {
  StringBuffer classString =
      StringBuffer("""class I18nDelegate extends LocalizationsDelegate<I18n> {
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
""");

  List<Locale> localesWithCountry = findLocalesWithCountry(locales);
  if (localesWithCountry.isNotEmpty) {
    classString
      ..writeln(
          "    final String lang = locale != null ? locale.toString() : \"\";")
      ..write(_generateLookupSwitch("lang", localesWithCountry));
  }

  List<Locale> localesWithoutCountry = findLocalesWithoutCountry(locales);
  if (localesWithoutCountry.isNotEmpty) {
    classString
      ..writeln(
          "    final String languageCode = locale != null ? locale.languageCode : \"\";")
      ..write(_generateLookupSwitch("languageCode", localesWithoutCountry));
  }

  classString
    ..writeln("    return I18nLookup_${locales.defaultLocale.toString()}();")
    ..writeln("  }")
    ..writeln("}");
  return DartClass(
    code: classString.toString(),
    imports: [
      'package:flutter/foundation.dart',
      'package:flutter/widgets.dart'
    ],
  );
}

String _generateLookupSwitch(String condition, List<Locale> locales) {
  StringBuffer switchCode = StringBuffer();
  switchCode.writeln("    switch ($condition) {");

  for (var locale in locales) {
    switchCode
      ..writeln("        case \"${locale.toString()}\":")
      ..writeln("          return I18nLookup_${locale.toString()}();");
  }

  switchCode.writeln("    }");
  return switchCode.toString();
}
