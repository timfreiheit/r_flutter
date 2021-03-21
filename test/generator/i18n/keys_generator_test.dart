import 'package:r_flutter/src/generator/i18n/keys_generator.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:test/test.dart';

void main() {
  test("test generateI18nKeysClass", () {
    final testData = I18nLocales(Locale("en", null), [
      I18nLocale(Locale("en", null), [
        I18nString(key: "key_1", value: "must_be_not_null"),
        I18nString(key: "key.2", value: "must_be_not_null"),
        I18nString(
            key: "key_3", value: "must_be_not_null", placeholders: ["name"]),
      ])
    ]);
    final resultClass = generateI18nKeysClass(testData);
    expect(resultClass.imports, []);
    expect(resultClass.code, """class I18nKeys {
  static const String key_1 = "key_1";
  static const String key_2 = "key.2";
  static const String key_3 = "key_3";
}
""");
  });
}
