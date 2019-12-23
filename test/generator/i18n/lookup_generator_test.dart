import 'package:r_flutter/src/generator/i18n/lookup_generator.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:test/test.dart';

void main() {
  final testData = I18nLocales(Locale("en"), [
    I18nLocale(Locale("en"), [
      I18nString(key: "key_1", value: "value_KEY_1"),
      I18nString(key: "key.2", value: "value_KEY_2"),
      I18nString(
        key: "key_3",
        value: "value_KEY_3 {p1}",
        placeholders: ["p1"],
      ),
      I18nString(
        key: "key_4",
        value: "value_KEY_4 {p1} {p2} {p3}",
        placeholders: ["p1", "p2", "p3"],
      ),
      I18nString(
        key: "key_5",
        value: "value_KEY_5 {p1}, {p1}, {p2}, {p3}",
        placeholders: ["p1", "p2", "p3"],
      ),
      I18nString(
        key: "key_5",
        value: "value_KEY_5 {p1}",
        placeholders: ["p1", "p2", "p3", "p4"],
      )
    ]),
    I18nLocale(Locale("de"), [
      I18nString(
        key: "key_5",
        value: "value_KEY_5 {p1}",
        placeholders: ["p1", "p2", "parameter_not_set_in_default_locale"],
      )
    ]),
    I18nLocale(Locale("de", "DE"), [
      I18nString(key: "key_1", value: "value_de_DE"),
    ]),
    I18nLocale(Locale("zh", "HK"), [
      I18nString(key: "key_1", value: "value_zh_HK"),
    ]),
    I18nLocale(Locale("pl"), [
      I18nString(key: "key_1", value: "value_KEY_1"),
    ]),
    I18nLocale(Locale("ru"), [
      I18nString(key: "unknown_key_1", value: "value_KEY_1"),
    ]),
    I18nLocale(Locale("gr"), [
      I18nString(key: "key_1", value: "value_KEY_1"),
      I18nString(key: "unknown_key_2", value: "value_KEY_2"),
      I18nString(key: "key.2", value: "value_KEY_3"),
    ]),
  ]);

  test("test secondary language", () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("pl")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_pl extends I18nLookup_en {
  @override
  String get key_1 {
    return "value_KEY_1";
  }
}
""");
  });

  test(
      "test secondary language with different placeholder list. should take values from default locale",
      () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("de")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_de extends I18nLookup_en {
  @override
  String key_5(String p1, String p2, String p3) {
    return "value_KEY_5 \${p1}";
  }
}
""");
  });

  test("test default lookup", () {
    final lookupClass = generateLookupClass(
        i18n: testData, value: testData.locales[0], isDefaultClass: true);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup {
  String getString(String key, [Map<String, String> placeholders]) {
    return null;
  }

  String get key_1 {
    return getString(I18nKeys.key_1);
  }

  String get key_2 {
    return getString(I18nKeys.key_2);
  }

  String key_3(String p1) {
    return getString(I18nKeys.key_3, {"p1": p1});
  }

  String key_4(String p1, String p2, String p3) {
    return getString(I18nKeys.key_4, {"p1": p1, "p2": p2, "p3": p3});
  }

  String key_5(String p1, String p2, String p3) {
    return getString(I18nKeys.key_5, {"p1": p1, "p2": p2, "p3": p3});
  }

  String key_5(String p1, String p2, String p3, String p4) {
    return getString(I18nKeys.key_5, {"p1": p1, "p2": p2, "p3": p3, "p4": p4});
  }
}
""");
  });

  test(
      "test additional keys in none default locales are ignored",
      () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("ru")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_ru extends I18nLookup_en {
}
""");
  });

  test(
      "test additional keys in none default locales are ignored 2",
      () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("gr")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_gr extends I18nLookup_en {
  @override
  String get key_1 {
    return "value_KEY_1";
  }

  @override
  String get key_2 {
    return "value_KEY_3";
  }
}
""");
  });

  test(
      "test locale with country code overrides the same locale without country code",
      () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("de", "DE")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_de_DE extends I18nLookup_de {
  @override
  String get key_1 {
    return "value_de_DE";
  }
}
""");
  });

    test(
      "test locale with country code without base locale support",
      () {
    final lookupClass = generateLookupClass(
        i18n: testData,
        value: testData.locales.firstWhere((it) => it.locale == Locale("zh", "HK")),
        isDefaultClass: false);
    expect(lookupClass.imports, []);
    expect(lookupClass.code, """class I18nLookup_zh_HK extends I18nLookup_en {
  @override
  String get key_1 {
    return "value_zh_HK";
  }
}
""");
  });
}