import 'package:collection/collection.dart';
import 'package:r_flutter/src/generator/i18n/i18n_generator_utils.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:recase/recase.dart';

List<DartClass> generateI18nMainClasses(
  I18nLocales i18n,
  Map<String, I18nLocales>? i18nFeatures,
) {
  final classes = <DartClass>[];

  classes.add(generateI18nClass(i18n, i18nFeatures?.keys));

  i18nFeatures?.forEach((feature, locales) {
    classes.add(generateI18nFeatureClass(locales, feature));
  });

  return classes;
}

DartClass generateI18nFeatureClass(I18nLocales i18n, String feature) {
  final featureClass = ReCase(feature).pascalCase;

  final classString = StringBuffer('class I18n$featureClass {\n');
  classString.writeln('  I18n$featureClass(this._lookup);');
  classString.writeln();
  classString.writeln('  final I18n${featureClass}Lookup _lookup;');
  classString.writeln();
  classString
      .writeln('  /// add custom locale lookup which will be called first');
  classString.writeln('  static I18n${featureClass}Lookup? customLookup;');
  classString.writeln();
  classString.write(_generateAccessorMethods(i18n));
  classString.write(_generateGetStringMethod(i18n, featureClass));
  classString.writeln('}');

  return DartClass(code: classString.toString());
}

///
/// ```dart
/// class I18n {
///  final I18nLookup _lookup;
///
///  I18n(this._lookup);
///
///  static Locale? _locale;
///
///  static Locale? get currentLocale => _locale;
///
///  /// add custom locale lookup which will be called first
///  static I18nLookup? customLookup;
///
///  static const I18nDelegate delegate = I18nDelegate();
///
///  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n)!;
///
///  static List<Locale> get supportedLocales {
///    return const <Locale>[
///      Locale("en"),
///      Locale("de"),
///      Locale("pl"),
///      Locale("de", "AT")
///    ];
///  }
///
///  String get hello {
///    return customLookup?.hello ?? _lookup.hello;
///  }
///
///  String? getString(String key, [Map<String, String>? placeholders]) {
///    switch (key) {
///      case I18nKeys.hello:
///        return hello;
///    }
///    return null;
///  }
///}
/// ```
///
DartClass generateI18nClass(
  I18nLocales i18n, [
  Iterable<String>? features,
]) {
  final classString = StringBuffer("""class I18n {
  final I18nLookup _lookup;

""");

  classString.writeln(_generateConstructor(features));

  classString.write(
    """
  static Locale? _locale;

  static Locale? get currentLocale => _locale;

  /// add custom locale lookup which will be called first
  static I18nLookup? customLookup;

  static const I18nDelegate delegate = I18nDelegate();

  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n)!;

""",
  );

  classString.writeln(_generateSupportedLocales(i18n));

  features?.forEach((feature) {
    final className = 'I18n${ReCase(feature).pascalCase}';
    final propertyName = ReCase(feature).camelCase;

    if (i18n.defaultValues.strings
        .any((e) => e.escapedKey.toLowerCase() == propertyName.toLowerCase())) {
      throw StateError(
        'There is a string and a feature with the same name: $propertyName',
      );
    }

    classString.writeln('  final $className $propertyName;');
    classString.writeln();
  });

  classString.write(_generateAccessorMethods(i18n));
  classString.write(_generateGetStringMethod(i18n));

  classString.writeln("}");
  return DartClass(code: classString.toString());
}

String _generateConstructor(Iterable<String>? features) {
  final code = StringBuffer('  I18n(this._lookup)');

  if (features == null || features.isEmpty) {
    code.writeln(';');
  } else {
    features.forEachIndexed((index, feature) {
      if (index == 0) {
        code.writeln();
        code.write('      :');
      } else {
        code.write('       ');
      }

      final propertyName = ReCase(feature).camelCase;
      final className = ReCase(feature).pascalCase;

      code.write(
          ' $propertyName = I18n$className(_lookup.create${className}Lookup())');

      if (index == (features.length - 1)) {
        code.writeln(';');
      } else {
        code.writeln(',');
      }
    });
  }

  return code.toString();
}

String _generateSupportedLocales(I18nLocales i18n) {
  final code = StringBuffer("""  static List<Locale> get supportedLocales {
    return const <Locale>[
""");

  final locales = i18n.locales
      .map((it) => it.locale)
      .where((it) => it != i18n.defaultLocale)
      .toList();

  code.write("      ${_generateLocaleInitialization(i18n.defaultLocale)}");
  for (final locale in locales) {
    code.write(",\n      ${_generateLocaleInitialization(locale)}");
  }
  code.write("\n");
  code.writeln("    ];");
  code.writeln("  }");
  return code.toString();
}

String _generateAccessorMethods(I18nLocales i18n) {
  final code = StringBuffer("");

  final values = i18n.defaultValues.strings;

  for (final value in values) {
    final methodCall = _stringValueMethodName(value);
    code.write(_genrateAccessorMethodComment(i18n, value));
    code.writeln(generateMethod(
        name: value.escapedKey,
        parameters: value.placeholders,
        code: "    return customLookup?.$methodCall ?? _lookup.$methodCall;"));
  }

  return code.toString();
}

String _genrateAccessorMethodComment(I18nLocales i18n, I18nString string) {
  final code = StringBuffer();
  code
    ..writeln("  ///")
    ..writeln("  /// <table style=\"width:100%\">")
    ..writeln("  ///   <tr>")
    ..writeln("  ///     <th>Locale</th>")
    ..writeln("  ///     <th>Translation</th>")
    ..writeln("  ///   </tr>");

  final locales = i18n.locales.toList()
    ..sort((item1, item2) =>
        item1.locale.toString().compareTo(item2.locale.toString()))
    ..remove(i18n.defaultValues)
    ..insert(0, i18n.defaultValues);

  for (final item in locales) {
    final localeString = item.locale.toString();
    final translation =
        item.strings.firstWhereOrNull((it) => it.key == string.key);

    code
      ..writeln("  ///   <tr>")
      ..writeln("  ///     <td style=\"width:60px;\">$localeString</td>");

    if (translation == null) {
      code.writeln("  ///     <td><font color=\"yellow\">⚠</font></td>");
    } else {
      code.writeln(
          "  ///     <td>\"${escapeStringLiteral(translation.value)}\"</td>");
    }
    code.writeln("  ///   </tr>");
  }
  code.writeln("  ///  </table>");
  code.writeln("  ///");
  return code.toString();
}

String _stringValueMethodName(I18nString value) {
  if (value.placeholders.isEmpty) {
    return value.escapedKey;
  } else {
    return "${value.escapedKey}(${value.placeholders.join(", ")})";
  }
}

String _generateGetStringMethod(I18nLocales i18n, [String? featureClass]) {
  final code = StringBuffer();
  code
    ..writeln(
        "  String? getString(String key, [Map<String, String>? placeholders]) {")
    ..writeln("    switch (key) {");

  final values = i18n.defaultValues.strings;

  final methodName = StringBuffer();
  for (final value in values) {
    methodName.clear();
    if (value.placeholders.isEmpty) {
      methodName.write(value.escapedKey);
    } else {
      methodName.write("${value.escapedKey}(");
      var isFirstPlaceholder = true;
      for (final placeholder in value.placeholders) {
        if (!isFirstPlaceholder) {
          methodName.write(", ");
        }
        isFirstPlaceholder = false;
        methodName.write("placeholders?[\"$placeholder\"] ?? \"\"");
      }
      methodName.write(")");
    }

    code
      ..writeln("      case I18n${featureClass ?? ''}Keys.${value.escapedKey}:")
      ..writeln("        return $methodName;");
  }

  code
    ..writeln("    }")
    ..writeln("    return null;")
    ..writeln("  }");
  return code.toString();
}

String _generateLocaleInitialization(Locale locale) {
  if (locale.countryCode == null && locale.scriptCode == null) {
    return "Locale(\"${locale.languageCode}\")";
  }
  if (locale.scriptCode == null) {
    return "Locale(\"${locale.languageCode}\", \"${locale.countryCode}\")";
  }
  if (locale.countryCode == null) {
    return "Locale.fromSubtags(languageCode: \"${locale.languageCode}\", scriptCode: \"${locale.scriptCode}\")";
  }
  return "Locale.fromSubtags(languageCode: \"${locale.languageCode}\", scriptCode: \"${locale.scriptCode}\", countryCode: \"${locale.countryCode}\")";
}
