import 'package:r_flutter/src/generator/i18n/i18n_generator_utils.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

List<DartClass> generateLookupClasses(I18nLocales i18n) {
  List<DartClass> classes = [];

  classes.add(_generateLookupClass(
    i18n: i18n,
    value: i18n.defaultValues,
    isDefaultClass: true,
  ));

  for (var locale in i18n.locales) {
    classes.add(_generateLookupClass(
      i18n: i18n,
      value: locale,
      isDefaultClass: false,
    ));
  }

  return classes;
}

DartClass _generateLookupClass(
    {I18nLocales i18n, I18nLocale value, bool isDefaultClass}) {
  String code = "class I18nLookup";

  if (!isDefaultClass) {
    code += "_" + value.locale.toString();
    code += " extends I18nLookup";

    I18nLocale parent = _findParent(i18n, value);
    if (parent != null) {
      code += "_" + parent.locale.toString();
    }
  }
  code += " {\n";

  if (isDefaultClass) {
    code +=
        "  String getString(String key, [Map<String, String> placeholders]) {\n";
    code += "    return null;\n";
    code += "  }\n\n";
  }

  bool isFirstMethod = true;
  final defaultLocale = i18n.defaultValues;
  for (var item in value.strings) {
    if (!isFirstMethod) {
      code += "\n";
    }
    isFirstMethod = false;
    
    I18nString defaultItem;
    if (value != defaultLocale) {
      defaultItem =
          defaultLocale.strings.firstWhere((it) => it.key == item.key);
    } else {
      defaultItem = item;
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

      code += generateMethod(
          name: defaultItem.escapedKey,
          parameters: defaultItem.placeholders,
          code: methodCode);
    } else {
      String valueString = item.value;
      valueString = escapeStringLiteral(valueString);
      for (var placeholder in defaultItem.placeholders) {
        valueString =
            valueString.replaceAll("{$placeholder}", "\${$placeholder}");
      }
      code += "  @override\n";
      code += generateMethod(
          name: defaultItem.escapedKey,
          parameters: defaultItem.placeholders,
          code: "    return \"${valueString}\";");
    }
  }

  code += "}\n";
  return DartClass(code: code);
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
