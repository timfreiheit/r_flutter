import 'asset_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class I18n {
  final I18nLookup _lookup;

  I18n(this._lookup);

  static Locale _locale;

  static Locale get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n);

  static List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en"),
      Locale("de"),
      Locale("pl"),
      Locale("de", "AT")
    ];
  }

  ///
  /// en (default): "AppName"
  ///
  /// de: not set
  ///
  /// de_AT: not set
  ///
  /// pl: not set
  ///
  String get appName {
    return customLookup?.appName ?? _lookup.appName;
  }

  ///
  /// en (default): "Content"
  ///
  /// de: "Text"
  ///
  /// de_AT: "Text_AT"
  ///
  /// pl: "tekst"
  ///
  String get string1 {
    return customLookup?.string1 ?? _lookup.string1;
  }

  ///
  /// en (default): "String with {placeholder}"
  ///
  /// de: "String mit {placeholder}"
  ///
  /// de_AT: not set
  ///
  /// pl: "Tekst z {placeholder}"
  ///
  String stringWithPlaceholder(String placeholder) {
    return customLookup?.stringWithPlaceholder(placeholder) ?? _lookup.stringWithPlaceholder(placeholder);
  }

  ///
  /// en (default): "Hola"
  ///
  /// de: "Hallo"
  ///
  /// de_AT: not set
  ///
  /// pl: "cześć"
  ///
  String get hello {
    return customLookup?.hello ?? _lookup.hello;
  }

  ///
  /// en (default): "test\n\nlint\nbreak"
  ///
  /// de: "test\n\nmit\nbreak"
  ///
  /// de_AT: not set
  ///
  /// pl: not set
  ///
  String get withLineBreak {
    return customLookup?.withLineBreak ?? _lookup.withLineBreak;
  }

  ///
  /// en (default): "hello_there"
  ///
  /// de: "hallo_hier"
  ///
  /// de_AT: not set
  ///
  /// pl: not set
  ///
  String get hello_there {
    return customLookup?.hello_there ?? _lookup.hello_there;
  }

  String getString(String key, [Map<String, String> placeholders]) {
    switch (key) {
      case I18nKeys.appName:
        return appName;
      case I18nKeys.string1:
        return string1;
      case I18nKeys.stringWithPlaceholder:
        return stringWithPlaceholder(placeholders["placeholder"]);
      case I18nKeys.hello:
        return hello;
      case I18nKeys.withLineBreak:
        return withLineBreak;
      case I18nKeys.hello_there:
        return hello_there;
    }
    return null;
  }
}

class I18nKeys {
  static const String appName = "appName";
  static const String string1 = "string1";
  static const String stringWithPlaceholder = "stringWithPlaceholder";
  static const String hello = "hello";
  static const String withLineBreak = "withLineBreak";
  static const String hello_there = "hello_there";
}

class I18nLookup {
  String getString(String key, [Map<String, String> placeholders]) {
    return null;
  }

  String get appName {
    return getString(I18nKeys.appName);
  }

  String get string1 {
    return getString(I18nKeys.string1);
  }

  String stringWithPlaceholder(String placeholder) {
    return getString(I18nKeys.stringWithPlaceholder, {"placeholder": placeholder});
  }

  String get hello {
    return getString(I18nKeys.hello);
  }

  String get withLineBreak {
    return getString(I18nKeys.withLineBreak);
  }

  String get hello_there {
    return getString(I18nKeys.hello_there);
  }
}

class I18nLookup_de extends I18nLookup_en {
  @override
  String get string1 {
    return "Text";
  }

  @override
  String stringWithPlaceholder(String placeholder) {
    return "String mit ${placeholder}";
  }

  @override
  String get hello {
    return "Hallo";
  }

  @override
  String get withLineBreak {
    return "test\n\nmit\nbreak";
  }

  @override
  String get hello_there {
    return "hallo_hier";
  }
}

class I18nLookup_en extends I18nLookup {
  @override
  String get appName {
    return "AppName";
  }

  @override
  String get string1 {
    return "Content";
  }

  @override
  String stringWithPlaceholder(String placeholder) {
    return "String with ${placeholder}";
  }

  @override
  String get hello {
    return "Hola";
  }

  @override
  String get withLineBreak {
    return "test\n\nlint\nbreak";
  }

  @override
  String get hello_there {
    return "hello_there";
  }
}

class I18nLookup_pl extends I18nLookup_en {
  @override
  String get string1 {
    return "tekst";
  }

  @override
  String stringWithPlaceholder(String placeholder) {
    return "Tekst z ${placeholder}";
  }

  @override
  String get hello {
    return "cześć";
  }
}

class I18nLookup_de_AT extends I18nLookup_de {
  @override
  String get string1 {
    return "Text_AT";
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
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
    final String lang = locale != null ? locale.toString() : "";
    switch (lang) {
        case "de_AT":
          return I18nLookup_de_AT();
    }
    final String languageCode = locale != null ? locale.languageCode : "";
    switch (languageCode) {
        case "de":
          return I18nLookup_de();
        case "en":
          return I18nLookup_en();
        case "pl":
          return I18nLookup_pl();
    }
    return I18nLookup_en();
  }
}

class Fonts {
  static const String testFont = "TestFont";
}

class Assets {
  /// ![](file:///Users/user/path/lib/assets/sub/sub/test_asset.txt)
  static const String subSubTestAsset = "lib/assets/sub/sub/test_asset.txt";
  /// ![](file:///Users/user/path/lib/assets/sub/test_asset.txt)
  static const String assetsSubTestAsset = "lib/assets/sub/test_asset.txt";
  /// ![](file:///Users/user/path/lib/assets/sub/temp.txt)
  static const String temp = "lib/assets/sub/temp.txt";
  /// ![](file:///Users/user/path/lib/assets/sub2/sub2.txt)
  static const String sub2 = "lib/assets/sub2/sub2.txt";
  /// ![](file:///Users/user/path/lib/assets/svg.svg)
  static const SvgFile svg = SvgFile("lib/assets/svg.svg");
  /// ![](file:///Users/user/path/lib/assets/test_asset2.txt)
  static const String testAsset2 = "lib/assets/test_asset2.txt";
  /// ![](file:///Users/user/path/lib/assets/%C3%A4%C3%9Fet.txt)
  static const String aesset = "lib/assets/äßet.txt";
}

class Images {
  /// ![](file:///Users/user/path/lib/assets/extension.png)
  static AssetImage get extension => const AssetImage("lib/assets/extension.png");
}

