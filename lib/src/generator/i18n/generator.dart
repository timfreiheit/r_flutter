
import 'package:r_flutter/src/generator/i18n/i18n_generator.dart';
import 'package:r_flutter/src/generator/i18n/lookup_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/i18n.dart';

import 'delegate_generator.dart';
import 'keys_generator.dart';

List<DartClass> generateI18nClasses(I18nLocales i18n) {
  return [
    generateI18nClass(i18n),
    generateI18nKeysClass(i18n),
    ...generateLookupClasses(i18n),
    generateI18nDelegate(i18n)
  ];
}
