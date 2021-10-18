import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/generator/fonts_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:recase/recase.dart';

import 'i18n/generator.dart';

String generateFile(Resources res, Config arguments) {
  final classes = <DartClass>[];
  if (res.i18n != null) {
    classes.addAll(generateI18nClasses(res.i18n!, res.i18nFeatures));
  }
  final fontClass = generateFontClass(res.fonts);
  if (fontClass != null) {
    classes.add(fontClass);
  }
  classes.addAll(generateAssetsClass(res.assets.assets));

  final fullCode = StringBuffer("");
  final imports = classes.expand((it) => it.imports).toSet().toList();
  imports.sort();
  for (final import in imports) {
    fullCode.writeln("import '$import';");
  }

  if (fullCode.isNotEmpty) {
    fullCode.write("\n");
  }

  for (final dartClass in classes) {
    fullCode.writeln(dartClass.code);
  }
  return fullCode.toString();
}

String createVariableName(String name) {
  return ReCase(name)
      .camelCase
      .replaceAll(r"ä", "ae")
      .replaceAll(r"ö", "oe")
      .replaceAll(r"ü", "ue")
      .replaceAll(r"Ä", "Ae")
      .replaceAll(r"Ö", "Oe")
      .replaceAll(r"Ü", "Üe")
      .replaceAll(r"ß", "ss")
      .replaceAll(RegExp(r"[^a-zA-Z0-9]"), "");
}
