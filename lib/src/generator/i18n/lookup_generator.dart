import 'package:r_flutter/src/generator/i18n/i18n_generator_utils.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

List<DartClass> generateLookupClasses(I18nLocales i18n) {
  final classes = <DartClass>[];

  classes.add(generateLookupClass(
    i18n: i18n,
    value: i18n.defaultValues,
    isDefaultClass: true,
  ));

  for (final locale in i18n.locales) {
    classes.add(generateLookupClass(
      i18n: i18n,
      value: locale,
      isDefaultClass: false,
    ));
  }

  return classes;
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
    {I18nLocales i18n, I18nLocale value, bool isDefaultClass}) {
  final code = StringBuffer("class I18nLookup");

  if (!isDefaultClass) {
    code.write("_${value.locale}");
    code.write(" extends I18nLookup");

    final parent = _findParent(i18n, value);
    if (parent != null) {
      code.write("_${parent.locale}");
    }
  }
  code.write(" {\n");

  if (isDefaultClass) {
    code.writeln(
        "  String getString(String key, [Map<String, String> placeholders]) {");
    code.writeln("    return null;");
    code.writeln("  }\n");
  }

  bool isFirstMethod = true;
  final defaultLocale = i18n.defaultValues;
  for (final item in value.strings) {
    I18nString defaultItem;
    if (value != defaultLocale) {
      defaultItem = defaultLocale.strings
          .firstWhere((it) => it.key == item.key, orElse: () => null);
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

    if (isDefaultClass) {
      final methodCode =
          StringBuffer("    return getString(I18nKeys.${item.escapedKey}");

      if (defaultItem.placeholders.isNotEmpty) {
        methodCode.write(", {");

        var isFirstPlaceholder = true;
        for (final placeholder in defaultItem.placeholders) {
          if (!isFirstPlaceholder) {
            methodCode.write(", ");
          }
          isFirstPlaceholder = false;
          methodCode.write("\"$placeholder\": $placeholder");
        }

        methodCode.write("});");
      } else {
        methodCode.write(");");
      }

      code.write(generateMethod(
        name: defaultItem.escapedKey,
        parameters: defaultItem.placeholders,
        code: methodCode.toString(),
      ));
    } else {
      String valueString = item.value;
      valueString = escapeStringLiteral(valueString);
      for (final placeholder in defaultItem.placeholders) {
        valueString =
            valueString.replaceAll("{$placeholder}", "\${$placeholder}");
      }
      code.writeln("  @override");
      code.write(generateMethod(
          name: defaultItem.escapedKey,
          parameters: defaultItem.placeholders,
          code: "    return \"$valueString\";"));
    }
  }

  code.writeln("}");
  return DartClass(code: code.toString());
}

I18nLocale _findParent(I18nLocales i18n, I18nLocale value) {
  if (value.locale.countryCode != null) {
    final parent = i18n.locales.firstWhere(
      (it) =>
          it.locale.countryCode == null &&
          it.locale.languageCode == value.locale.languageCode,
      orElse: () => null,
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
