import 'package:recase/recase.dart';

class Locale {
  final String languageCode;
  final String? countryCode;
  final String? scriptCode;

  Locale(this.languageCode, [this.countryCode]) : scriptCode = null;

  Locale.fromSubtags({
    required this.languageCode,
    this.scriptCode,
    this.countryCode,
  });

  @override
  String toString() {
    if (countryCode == null && scriptCode == null) {
      return languageCode;
    }
    if (scriptCode == null) {
      return "${languageCode}_$countryCode";
    }
    if (countryCode == null) {
      return "${languageCode}_$scriptCode";
    }
    return "${languageCode}_${scriptCode}_$countryCode";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Locale &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode &&
          countryCode == other.countryCode &&
          scriptCode == other.scriptCode;

  @override
  int get hashCode => toString().hashCode;
}

class I18nLocales {
  final Locale defaultLocale;
  final List<I18nLocale> locales;

  I18nLocales(this.defaultLocale, this.locales);

  I18nLocale get defaultValues =>
      locales.firstWhere((locale) => locale.locale == defaultLocale);
}

class I18nLocale {
  final Locale locale;
  final List<I18nString> strings;

  I18nLocale(this.locale, this.strings);
}

class I18nString {
  final String key;
  final String value;
  final List<String> placeholders;

  I18nString(
      {required this.key, required this.value, this.placeholders = const []});

  String get escapedKey =>
      key.replaceAll(".", "_").replaceAll("-", "_").replaceAll(" ", "_");
}

class I18nFeature {
  I18nFeature({required this.locales, required this.name, this.path})
      : featureClassName = ReCase(name).pascalCase,
        featurePropertyName = ReCase(name).camelCase;

  final String name;
  final String? path;
  final I18nLocales locales;
  final String featureClassName;
  final String featurePropertyName;
}
