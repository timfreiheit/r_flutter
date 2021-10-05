import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';
import 'package:recase/recase.dart';

///
/// ```dart
/// class I18nKeys {
///  static const String appName = "appName";
///  static const String string1 = "string1";
/// }
/// ```
///
List<DartClass> generateI18nKeysClasses(
  I18nLocales locales, [
  Map<String, I18nLocales>? i18nFeatures,
]) {
  final featureClassNames = <String, String>{};
  final featureClasses = <DartClass>[];

  i18nFeatures?.forEach((featureName, locales) {
    final featureClassName = 'I18n${ReCase(featureName).pascalCase}Keys';
    featureClassNames[featureName] = featureClassName;

    featureClasses
        .add(_generateI18nKeysClass(locales, className: featureClassName));
  });

  return <DartClass>[
    _generateI18nKeysClass(locales, featureClassNames: featureClassNames),
    ...featureClasses
  ];
}

DartClass _generateI18nKeysClass(
  I18nLocales locales, {
  String? className,
  Map<String, String>? featureClassNames,
}) {
  final classString = StringBuffer("class ${className ?? 'I18nKeys'} {\n");

  if (className != null) {
    classString.writeln('  const $className();');
  }

  final items = locales.defaultValues.strings;
  for (final item in items) {
    classString
        .writeln('  static const String ${item.escapedKey} = "${item.key}";');
  }

  featureClassNames?.forEach((featureName, featureClassName) {
    final propertyName = ReCase(featureName).camelCase;

    if (items
        .any((e) => e.escapedKey.toLowerCase() == propertyName.toLowerCase())) {
      throw StateError(
        'There is a string and a feature with the same name: $propertyName',
      );
    }

    classString.writeln(
      '  static const $featureClassName $propertyName = $featureClassName();',
    );
  });

  classString.writeln("}");
  return DartClass(code: classString.toString());
}
