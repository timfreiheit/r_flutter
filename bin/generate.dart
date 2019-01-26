#!/usr/bin/env dart
import 'dart:convert';
import 'dart:io';

import 'package:r_flutter/src/arguments.dart';
import 'package:r_flutter/src/assets_parser.dart';
import 'package:r_flutter/src/fonts_parser.dart';
import 'package:r_flutter/src/output.dart';
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
  final output = Output(
    fonts: parseFonts(yaml),
    assets: parseAssets(yaml, arguments.ignoreAssets),
  );

  final outoutFile = File(arguments.outputFilename);
  outoutFile.writeAsStringSync(output.generateFile());

  print("${outoutFile.path} generated successfully");
}
