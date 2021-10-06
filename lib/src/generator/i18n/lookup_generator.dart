import 'package:collection/collection.dart';
import 'package:r_flutter/src/generator/i18n/i18n_generator_utils.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:recase/recase.dart';

List<DartClass> generateLookupClasses(
  I18nLocales i18n,
  Map<String, I18nLocales>? i18nFeatures,
) {
  final classes = <DartClass>[];

  classes.add(
    generateDefaultLookupClass(
      i18n,
      i18n.defaultValues,
      features: i18nFeatures?.keys,
    ),
  );

  i18nFeatures?.forEach((featureName, locales) {
    classes.add(
      generateDefaultLookupClass(
        locales,
        locales.defaultValues,
        featureName: featureName,
      ),
    );
  });

  for (final locale in i18n.locales) {
    classes.add(
      generateLookupClass(
        i18n,
        locale,
        features: i18nFeatures?.keys,
      ),
    );
  }

  i18nFeatures?.forEach((featureName, locales) {
    for (final locale in locales.locales) {
      classes.add(
        generateLookupClass(
          locales,
          locale,
          featureName: featureName,
        ),
      );
    }
  });

  return classes;
}

///
/// ```dart
/// class I18nLookup {
///   String getString(String key, [Map<String, String>? placeholders]) {
///     throw UnimplementedError("I18nLookup.getString");
///   }
///
///   String get hello {
///     return getString(I18nKeys.hello);
///   }
///
///   String get world {
///     return getString(I18nKeys.world);
///   }
/// }
/// ```
///
DartClass generateDefaultLookupClass(
  I18nLocales i18n,
  I18nLocale value, {
  Iterable<String>? features,
  String? featureName,
}) {
  final featureClassName =
      featureName != null ? ReCase(featureName).pascalCase : '';
  final code = StringBuffer(
    "class I18n${featureClassName}Lookup",
  );

  code.write(" {\n");

  code.writeln(
    "  String getString(String key, [Map<String, String>? placeholders]) {",
  );
  code.writeln(
    '    throw UnimplementedError("I18n${featureClassName}Lookup.getString");',
  );
  code.writeln("  }\n");

  bool isFirstMethod = true;
  final defaultLocale = i18n.defaultValues;
  for (final item in value.strings) {
    I18nString? defaultItem;
    if (value != defaultLocale) {
      defaultItem =
          defaultLocale.strings.firstWhereOrNull((it) => it.key == item.key);
    } else {
      defaultItem = item;
    }

    if (defaultItem == null) {
      continue;
    }

    if (!isFirstMethod) {
      code.write("\n");
    }
    isFirstMethod = false;

    final methodCode = StringBuffer(
      "    return getString(I18n${featureClassName}Keys.${item.escapedKey}",
    );

    if (defaultItem.placeholders.isNotEmpty) {
      methodCode.write(", {");

      var isFirstPlaceholder = true;
      for (final placeholder in defaultItem.placeholders) {
        if (!isFirstPlaceholder) {
          methodCode.write(", ");
        }
        isFirstPlaceholder = false;
        methodCode.write('"$placeholder": $placeholder');
      }

      methodCode.write("});");
    } else {
      methodCode.write(");");
    }

    code.write(
      generateMethod(
        name: defaultItem.escapedKey,
        parameters: defaultItem.placeholders,
        code: methodCode.toString(),
      ),
    );
  }

  features?.forEach((feature) {
    final featureClass = ReCase(feature).pascalCase;
    final className = 'I18n${featureClass}Lookup';

    code.writeln();
    code.writeln('  $className create${featureClass}Lookup() => $className();');
  });

  code.writeln("}");
  return DartClass(code: code.toString());
}

///
/// ```dart
/// class I18nLookup_de_AT extends I18nLookup_de {
///  @override
///  String get string1 {
///    return "Text_AT";
///  }
/// }
/// ```
///
DartClass generateLookupClass(
  I18nLocales i18n,
  I18nLocale value, {
  Iterable<String>? features,
  String? featureName,
}) {
  final featureClassName =
      featureName != null ? ReCase(featureName).pascalCase : '';
  final code = StringBuffer("class I18n${featureClassName}Lookup");

  code.write("_${value.locale}");
  code.write(" extends I18n${featureClassName}Lookup");

  final parent = _findParent(i18n, value);
  if (parent != null) {
    code.write("_${parent.locale}");
  }
  code.writeln(" {");

  bool isFirstMethod = true;
  final defaultLocale = i18n.defaultValues;
  for (final item in value.strings) {
    I18nString? defaultItem;
    if (value != defaultLocale) {
      defaultItem =
          defaultLocale.strings.firstWhereOrNull((it) => it.key == item.key);
    } else {
      defaultItem = item;
    }

    if (defaultItem == null) {
      continue;
    }

    if (!isFirstMethod) {
      code.writeln();
    }
    isFirstMethod = false;

    String valueString = item.value;
    valueString = escapeStringLiteral(valueString);
    for (final placeholder in defaultItem.placeholders) {
      valueString =
          valueString.replaceAll("{$placeholder}", "\${$placeholder}");
    }
    code.writeln("  @override");
    code.write(
      generateMethod(
        name: defaultItem.escapedKey,
        parameters: defaultItem.placeholders,
        code: '    return "$valueString";',
      ),
    );
  }

  features?.forEach((feature) {
    final featureClass = ReCase(feature).pascalCase;
    final className = 'I18n${featureClass}Lookup_${value.locale}';
    code.writeln();
    code.writeln('  @override');
    code.writeln('  $className create${featureClass}Lookup() => $className();');
  });

  code.writeln("}");
  return DartClass(code: code.toString());
}

I18nLocale? _findParent(I18nLocales i18n, I18nLocale value) {
  if (value.locale.countryCode != null || value.locale.scriptCode != null) {
    final parent = i18n.locales.firstWhereOrNull(
      (it) =>
          it.locale.countryCode == null &&
          it.locale.scriptCode == null &&
          it.locale.languageCode == value.locale.languageCode,
    );
    if (parent != null) {
      return parent;
    }
  }
  final parent = i18n.defaultValues;
  if (parent == value) {
    return null;
  }
  return parent;
}
