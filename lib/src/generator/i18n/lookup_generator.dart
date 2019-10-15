import 'package:r_flutter/src/generator/i18n/i18n_generator_utils.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

List<DartClass> generateLookupClasses(I18nLocales i18n) {
  List<DartClass> classes = [];

  classes.add(generateLookupClass(
    i18n: i18n,
    value: i18n.defaultValues,
    isDefaultClass: true,
  ));

  for (var locale in i18n.locales) {
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
  StringBuffer code = StringBuffer("class I18nLookup");

  if (!isDefaultClass) {
    code.write("_" + value.locale.toString());
    code.write(" extends I18nLookup");

    I18nLocale parent = _findParent(i18n, value);
    if (parent != null) {
      code.write("_" + parent.locale.toString());
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
  for (var item in value.strings) {
    if (!isFirstMethod) {
      code.write("\n");
    }
    isFirstMethod = false;

    I18nString defaultItem;
    if (value != defaultLocale) {
      defaultItem =
          defaultLocale.strings.firstWhere((it) => it.key == item.key, orElse: () => null);
    } else {
      defaultItem = item;
    }

    if (defaultItem == null) {
        continue;
    }

    if (isDefaultClass) {
      String methodCode = "    return getString(I18nKeys.${item.escapedKey}";

      if (defaultItem.placeholders.isNotEmpty) {
        methodCode += ", {";

        for (var placeholder in defaultItem.placeholders) {
          if (!methodCode.endsWith("{")) {
            methodCode += ", ";
          }
          methodCode += "\"$placeholder\": $placeholder";
        }

        methodCode += "});";
      } else {
        methodCode += ");";
      }

      code.write(generateMethod(
          name: defaultItem.escapedKey,
          parameters: defaultItem.placeholders,
          code: methodCode));
    } else {
      String valueString = item.value;
      valueString = escapeStringLiteral(valueString);
      for (var placeholder in defaultItem.placeholders) {
        valueString =
            valueString.replaceAll("{$placeholder}", "\${$placeholder}");
      }
      code.writeln("  @override");
      code.write(generateMethod(
          name: defaultItem.escapedKey,
          parameters: defaultItem.placeholders,
          code: "    return \"${valueString}\";"));
    }
  }

  code.writeln("}");
  return DartClass(code: code.toString());
}

I18nLocale _findParent(I18nLocales i18n, I18nLocale value) {
  if (value.locale.countryCode != null) {
    I18nLocale parent = i18n.locales.firstWhere((it) =>
        it.locale.countryCode == null &&
        it.locale.languageCode == value.locale.languageCode);
    if (parent != null) {
      return parent;
    }
  }
  I18nLocale parent = i18n.defaultValues;
  if (parent == value) {
    return null;
  }
  return parent;
}
