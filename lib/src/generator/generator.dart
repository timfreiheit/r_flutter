import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/assets_generator.dart';
import 'package:r_flutter/src/generator/fonts_generator.dart';
import 'package:r_flutter/src/model/dart_class.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:recase/recase.dart';

import 'i18n/generator.dart';

String generateFile(Resources res, Config arguments) {
  var classes = <DartClass>[];
  if (res.i18n != null) {
    classes.addAll(generateI18nClasses(res.i18n));
  }
  classes.add(generateFontClass(res.fonts));
  classes.addAll(generateAssetsClass(res.assets.assets));

  classes = classes.where((item) => item != null).toList();

  final fullCode = StringBuffer('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides


''');

  final imports = classes.expand((it) => it.imports).toSet().toList();
  imports.sort();
  for (final import in imports) {
    fullCode.writeln("import '$import';");
  }

  if (fullCode.isNotEmpty) {
    fullCode.writeln();
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
