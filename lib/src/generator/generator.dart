import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/generator/fonts_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:recase/recase.dart';

import 'i18n/generator.dart';

String generateFile(Resources res, Arguments arguments) {
  List<DartClass> classes = [];
  if (res.i18n != null) {
    classes.addAll(generateI18nClasses(res.i18n));
  }
  classes.add(generateFontClass(res.fonts));
  classes.addAll(generateAssetsClass(res.assets.assets));

  classes = classes.where((item) => item != null).toList();

  String fullCode = "";
  List<String> imports = classes.expand((it) => it.imports).toSet().toList();
  imports.sort();
  for (var import in imports) {
    fullCode += "import '$import';\n";
  }

  if (fullCode.isNotEmpty) {
    fullCode += "\n";
  }

  for (var dartClass in classes) {
    fullCode += dartClass.code + "\n";
  }
  return fullCode;
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
