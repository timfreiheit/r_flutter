import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/generator/fonts_generator.dart';
import 'package:r_flutter/src/generator/strings_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:recase/recase.dart';

String generateFile(Resources res, Arguments arguments) {
  List<DartClass> classes = [];
  classes.add(generateStringBindingClass(res.stringReferences));
  classes.add(generateFontClass(res.fonts));
  classes.addAll(generateAssetsClass(res.assets.assets));

  classes = classes.where((item) => item != null).toList();

  String fullCode = "";
  for (var dartClass in classes) {
    for (var import in dartClass.imports) {
      fullCode += "import '$import';\n";
    }
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
