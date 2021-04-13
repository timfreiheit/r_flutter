import 'package:r_flutter/src/generator/i18n/i18n_generator.dart';
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
    I18nLocale(Locale("de", "DE"), [
      I18nString(
        key: "key.2",
        value: "DE value_KEY_2",
      ),
      I18nString(
        key: "key_3",
        value: "DE value_KEY_3",
      )
    ]),
    I18nLocale(Locale.fromSubtags(languageCode: "en", countryCode: "UK"), [
      I18nString(key: "key_1", value: "en_UK_value_KEY_1"),
      I18nString(key: "key.2", value: "en_UK_value_KEY_2"),
    ]),
    I18nLocale(Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans"), [
      I18nString(key: "key_1", value: "zh_Hans_value_KEY_1"),
      I18nString(key: "key.2", value: "zh_Hans_value_KEY_2"),
    ]),
    I18nLocale(Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant"), [
      I18nString(key: "key_3", value: "zh_Hant_value_KEY_3"),
      I18nString(key: "key.4", value: "zh_Hant_value_KEY_4"),
    ]),
    I18nLocale(
        Locale.fromSubtags(
            languageCode: "zh", scriptCode: "Hans", countryCode: "CN"),
        [
          I18nString(key: "key_5", value: "zh_Hans_CN_value_KEY_5"),
          I18nString(key: "key.6", value: "zh_Hans_CN_value_KEY_6"),
        ]),
    I18nLocale(
        Locale.fromSubtags(
            languageCode: "zh", scriptCode: "Hant", countryCode: "TW"),
        [
          I18nString(key: "key_7", value: "zh_Hant_TW_value_KEY_5"),
          I18nString(key: "key.8", value: "zh_Hant_TW_value_KEY_6"),
        ]),
  ]);

  test("test i18n generation", () {
    final generatedClass = generateI18nClass(testData);
    expect(generatedClass.imports, []);
    expect(generatedClass.code, """class I18n {
  final I18nLookup _lookup;

  I18n(this._lookup);

  static Locale? _locale;

  static Locale? get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup? customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n)!;

  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en"),
      Locale("de", "DE"),
      Locale("en", "UK"),
      Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans"),
      Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant"),
      Locale.fromSubtags(languageCode: "zh", scriptCode: "Hans", countryCode: "CN"),
      Locale.fromSubtags(languageCode: "zh", scriptCode: "Hant", countryCode: "TW")
    ];
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_1"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td>"en_UK_value_KEY_1"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td>"zh_Hans_value_KEY_1"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String get key_1 {
    return customLookup?.key_1 ?? _lookup.key_1;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td>"DE value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td>"en_UK_value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td>"zh_Hans_value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String get key_2 {
    return customLookup?.key_2 ?? _lookup.key_2;
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_3 {p1}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td>"DE value_KEY_3"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td>"zh_Hant_value_KEY_3"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String key_3(String p1) {
    return customLookup?.key_3(p1) ?? _lookup.key_3(p1);
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_4 {p1} {p2} {p3}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String key_4(String p1, String p2, String p3) {
    return customLookup?.key_4(p1, p2, p3) ?? _lookup.key_4(p1, p2, p3);
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_5 {p1}, {p1}, {p2}, {p3}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td>"zh_Hans_CN_value_KEY_5"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String key_5(String p1, String p2, String p3) {
    return customLookup?.key_5(p1, p2, p3) ?? _lookup.key_5(p1, p2, p3);
  }

  ///
  /// <table style="width:100%">
  ///   <tr>
  ///     <th>Locale</th>
  ///     <th>Translation</th>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en</td>
  ///     <td>"value_KEY_5 {p1}, {p1}, {p2}, {p3}"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">de_DE</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">en_UK</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hans_CN</td>
  ///     <td>"zh_Hans_CN_value_KEY_5"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">zh_Hant_TW</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String key_5(String p1, String p2, String p3, String p4) {
    return customLookup?.key_5(p1, p2, p3, p4) ?? _lookup.key_5(p1, p2, p3, p4);
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nKeys.key_1:
        return key_1;
      case I18nKeys.key_2:
        return key_2;
      case I18nKeys.key_3:
        return key_3(placeholders?["p1"] ?? "");
      case I18nKeys.key_4:
        return key_4(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "");
      case I18nKeys.key_5:
        return key_5(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "");
      case I18nKeys.key_5:
        return key_5(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "", placeholders?["p4"] ?? "");
    }
    return null;
  }
}
""");
  });
}
