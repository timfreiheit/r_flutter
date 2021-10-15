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
    I18nLocale(Locale("de"), [
      I18nString(
        key: "key.2",
        value: "DE value_KEY_2",
      ),
      I18nString(
        key: "key_3",
        value: "DE value_KEY_3",
      )
    ]),
    I18nLocale(Locale("pl"), [
      I18nString(key: "key_1", value: "pl_value_KEY_1"),
      I18nString(key: "key.2", value: "pl_value_KEY_2"),
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
      Locale("de"),
      Locale("pl")
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_1"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_2"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_3"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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

  test("test i18n generation with features", () {
    final generatedClass = generateI18nClass(
      testData,
      [
        I18nFeature(
          name: 'home',
          locales: I18nLocales(Locale('de'), []),
        ),
        I18nFeature(
          name: 'profile',
          locales: I18nLocales(Locale('de'), []),
        ),
      ],
    );
    expect(generatedClass.imports, []);
    expect(generatedClass.code, """class I18n {
  final I18nLookup _lookup;

  I18n(this._lookup)
      : home = I18nHome(_lookup.createHomeLookup()),
        profile = I18nProfile(_lookup.createProfileLookup());

  static Locale? _locale;

  static Locale? get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup? customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n)!;

  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en"),
      Locale("de"),
      Locale("pl")
    ];
  }

  final I18nHome home;

  final I18nProfile profile;

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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_1"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_2"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_3"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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

  test("test i18n generation for a feature", () {
    final generatedClass = generateI18nFeatureClass(
      I18nFeature(
        name: 'home',
        locales: testData,
      ),
    );
    expect(generatedClass.imports, []);
    expect(generatedClass.code, """class I18nHome {
  I18nHome(this._lookup);

  final I18nHomeLookup _lookup;

  /// add custom locale lookup which will be called first
  static I18nHomeLookup? customLookup;

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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_1"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_2"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td>"pl_value_KEY_2"</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td>"DE value_KEY_3"</td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
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
  ///     <td style="width:60px;">de</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///   <tr>
  ///     <td style="width:60px;">pl</td>
  ///     <td><font color="yellow">⚠</font></td>
  ///   </tr>
  ///  </table>
  ///
  String key_5(String p1, String p2, String p3, String p4) {
    return customLookup?.key_5(p1, p2, p3, p4) ?? _lookup.key_5(p1, p2, p3, p4);
  }

  String? getString(String key, [Map<String, String>? placeholders]) {
    switch (key) {
      case I18nHomeKeys.key_1:
        return key_1;
      case I18nHomeKeys.key_2:
        return key_2;
      case I18nHomeKeys.key_3:
        return key_3(placeholders?["p1"] ?? "");
      case I18nHomeKeys.key_4:
        return key_4(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "");
      case I18nHomeKeys.key_5:
        return key_5(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "");
      case I18nHomeKeys.key_5:
        return key_5(placeholders?["p1"] ?? "", placeholders?["p2"] ?? "", placeholders?["p3"] ?? "", placeholders?["p4"] ?? "");
    }
    return null;
  }
}
""");
  });
}
