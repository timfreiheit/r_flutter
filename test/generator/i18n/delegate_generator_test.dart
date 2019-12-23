import 'package:r_flutter/src/generator/i18n/delegate_generator.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:test/test.dart';

void main() {
  test("test single language", () {
    final testData = I18nLocales(
      Locale("en", null),
      [
        I18nLocale(Locale("en", null), []),
      ],
    );

    final result = generateI18nDelegate(testData);
    expect(result.imports,
        ['package:flutter/foundation.dart', 'package:flutter/widgets.dart']);
    expect(
        result.code, """class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();\

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
    final String languageCode = locale != null ? locale.languageCode : "";
    switch (languageCode) {
        case "en":
          return I18nLookup_en();
    }
    return I18nLookup_en();
  }
}
""");
  });

  test("test multiple languages", () {
    final testData = I18nLocales(
      Locale("en", null),
      [
        I18nLocale(Locale("en", null), []),
        I18nLocale(Locale("de", null), []),
        I18nLocale(Locale("pl", null), [])
      ],
    );

    final result = generateI18nDelegate(testData);
    expect(result.imports,
        ['package:flutter/foundation.dart', 'package:flutter/widgets.dart']);
    expect(
        result.code, """class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();\

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
    final String languageCode = locale != null ? locale.languageCode : "";
    switch (languageCode) {
        case "en":
          return I18nLookup_en();
        case "de":
          return I18nLookup_de();
        case "pl":
          return I18nLookup_pl();
    }
    return I18nLookup_en();
  }
}
""");
  });


  test("test multiple languages with country code", () {
    final testData = I18nLocales(
      Locale("en", null),
      [
        I18nLocale(Locale("en", null), []),
        I18nLocale(Locale("de", null), []),
        I18nLocale(Locale("de", "AT"), []),
        I18nLocale(Locale("pl", null), [])
      ],
    );

    final result = generateI18nDelegate(testData);
    expect(result.imports,
        ['package:flutter/foundation.dart', 'package:flutter/widgets.dart']);
    expect(
        result.code, """class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();\

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
    final String lang = locale != null ? locale.toString() : "";
    switch (lang) {
        case "de_AT":
          return I18nLookup_de_AT();
    }
    final String languageCode = locale != null ? locale.languageCode : "";
    switch (languageCode) {
        case "en":
          return I18nLookup_en();
        case "de":
          return I18nLookup_de();
        case "pl":
          return I18nLookup_pl();
    }
    return I18nLookup_en();
  }
}
""");
  });

  test("test multiple languages with country code without base locale support", () {
    final testData = I18nLocales(
      Locale("en", null),
      [
        I18nLocale(Locale("en", null), []),
        I18nLocale(Locale("de", "AT"), []),
        I18nLocale(Locale("pl", null), [])
      ],
    );

    final result = generateI18nDelegate(testData);
    expect(result.imports,
        ['package:flutter/foundation.dart', 'package:flutter/widgets.dart']);
    expect(
        result.code, """class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();\

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
    final String lang = locale != null ? locale.toString() : "";
    switch (lang) {
        case "de_AT":
          return I18nLookup_de_AT();
    }
    final String languageCode = locale != null ? locale.languageCode : "";
    switch (languageCode) {
        case "en":
          return I18nLookup_en();
        case "pl":
          return I18nLookup_pl();
    }
    return I18nLookup_en();
  }
}
""");
  });
}
