import 'dart:io';

class Locale {
  final String languageCode;
  final String countryCode;

  Locale(this.languageCode, this.countryCode);

  @override
  String toString() {
    if (countryCode == null) {
      return languageCode;
    }
    return "${languageCode}_${countryCode}";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Locale &&
          runtimeType == other.runtimeType &&
          languageCode == other.languageCode &&
          countryCode == other.countryCode;

  @override
  int get hashCode => languageCode.hashCode ^ countryCode.hashCode;
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

  I18nString({this.key, this.value, this.placeholders});

  String get escapedKey => key.replaceAll(".", "_");
}
