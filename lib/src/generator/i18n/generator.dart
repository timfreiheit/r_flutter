import 'package:r_flutter/src/generator/i18n/i18n_generator.dart';
import 'package:r_flutter/src/generator/i18n/lookup_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

import 'delegate_generator.dart';
import 'keys_generator.dart';

List<DartClass> generateI18nClasses(
  I18nLocales i18n,
  Map<String, I18nLocales>? i18nFeatures,
) {
  return [
    generateI18nClass(i18n),
    ...generateI18nKeysClasses(i18n, i18nFeatures),
    ...generateLookupClasses(i18n, i18nFeatures),
    generateI18nDelegate(i18n)
  ];
}
