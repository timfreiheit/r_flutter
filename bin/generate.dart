#!/usr/bin/env dart
import 'dart:convert';
import 'dart:io';

import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/generator/generator.dart';
import 'package:r_flutter/src/model/resources.dart';
import 'package:r_flutter/src/parser/assets_parser.dart';
import 'package:r_flutter/src/parser/fonts_parser.dart';
import 'package:r_flutter/src/parser/strings_parser.dart';
import 'package:yaml/yaml.dart';

main(List<String> args) {
  var arguments = Arguments();
  arguments.parse(args);

  final pubspecFile = File(arguments.pubspecFilename).absolute;
  if (!pubspecFile.existsSync()) {
    print("pubspec file does not exists: " + pubspecFile.path);
    exit(1);
  }

  final yaml = loadYaml(pubspecFile.readAsStringSync());
  final res = Resources(
    fonts: parseFonts(yaml),
    assets: parseAssets(yaml, arguments.ignoreAssets),
    stringReferences: parseStrings(arguments.intlFilename)
  );

  final outoutFile = File(arguments.outputFilename);
  outoutFile.writeAsStringSync(generateFile(res));

  print("${outoutFile.path} generated successfully");
}
